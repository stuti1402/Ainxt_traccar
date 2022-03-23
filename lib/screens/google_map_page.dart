import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:emka_gps/components/components.dart';
import 'package:emka_gps/components/explore_content_widget.dart';
import 'package:emka_gps/components/explore_widget.dart';
import 'package:emka_gps/components/recent_search_widget.dart';
import 'package:emka_gps/components/search_menu_widget.dart';
import 'package:emka_gps/global/app_colors.dart';
import 'package:emka_gps/helper/map_helper.dart';
import 'package:emka_gps/helper/map_marker.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/geoFence.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../helper/ui_helper.dart';

const d_grey = Color(0xFFEDECF2);

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage();

  @override
  State<StatefulWidget> createState() {
    return _GoogleMapState();
  }
}

class _GoogleMapState extends State<GoogleMapPage>
    with TickerProviderStateMixin {
  AnimationController? animationControllerExplore;
  AnimationController? animationControllerSearch;
  AnimationController? animationControllerMenu;
  late CurvedAnimation curve;
  late Animation<double> animation;
  Animation<double>? animationW;
  Animation<double>? animationR;
  double value = 0.0;
  bool isSelected = false;
  bool isLogoutSelected = false;
  late GoogleMapController _googleMapController;
  late int _selectedId = 0;
  late bool _visibility = false;

  /// get currentOffset percent
  get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;

  bool isExploreOpen = false;

  bool isSearchOpen = false;
  bool isMenuOpen = false;
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController mcontroller;

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 7;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.orange;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  List<GeoFence> _geofences = [];

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
  ];
  List<Device> _devices = [];
  final List<Map<String, dynamic>> _selectSearchItemsDevice = [];
  final addFormKey = GlobalKey<FormState>();
  final _selectedDeviceController = TextEditingController();
  String _idValueChanged = '';
  String _idValueToValidate = '';
  String _idValueSaved = '';

  Language _language = Language();
  LatLngBounds _latLngBounds =
  LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
  final List<Map<String, dynamic>> _addFormSelectItemsDevice = [];
  late double searchOpacity = 0.7;

  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
    Provider.of<AppProvider>(context, listen: false).initialization();

    setState(() {
      value = 0.0;
      _language.getLanguage();
      _latLngBounds =
          LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
      isFitbounds = false;
      checkLoginStatus();
    });
  }

  late bool isFitbounds = false;
  fitBounds(LatLngBounds latLngBounds) {
    print('latlngbounds$latLngBounds');

    if (_latLngBounds != latLngBounds &&
        isFitbounds == false &&
        isMapCreated == true) {
      isFitbounds = true;
      _latLngBounds = latLngBounds;
      mcontroller
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
    }
  }

  late Device? _device = new Device(
      status: 'status',
      disabled: false,
      lastUpdate: 'lastUpdate',
      position: null);
  late Position? _position = new Position(
    deviceId: 0,
    outdated: false,
    valid: false,
    latitude: 0,
    longitude: 0,
    altitude: 0,
    speed: 0,
    course: 0,
    id: 0,
    attributes: new PositionAttributes(),
  );

  setVisibility(int id) async {
    print('enter');
    _selectedId = id;
    if (_selectedId == 0 && isExploreOpen == false) {
      print('enterF');

      _visibility = false;
    } else {
      _visibility = true;
      print('enterT');
    }
  }

  getDevicePosition(int id, Position pos, Device device) {
    // _device = _appProvider.getDeviceById(id);
    // _position = _appProvider.getPositionById(id);
    _device = device;
    _position = pos;
    // print('pospos${_position!.speed}');
    //print('deviceInfo${_device!.name}');
  }

  setFitBounds(LatLngBounds latLngBounds) {
    print('latlngbounds$latLngBounds');

    if (_latLngBounds != latLngBounds && isFitbounds == false) {
      isFitbounds = true;
      mcontroller
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
    }
  }

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.

  late bool isMapCreated = false;
  void _onMapCreated(GoogleMapController controller, markers) {
    _mapController.complete(controller);
    mcontroller = controller;
    isMapCreated = true;

    setState(() {
      _isMapLoading = false;
      mcontroller = controller;
    });
    //controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
    // _initMarkers(_mlocations);
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers(List<MapMarker> _mlocations) async {
    final List<MapMarker> markers = [];
    print('locm:::$_mlocations');
/*
    for (LatLng markerLocation in _mlocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _mlocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }
*/
    _clusterManager = await MapHelper.initClusterManager(
      _mlocations,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      mcontroller,
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  /// search drag callback
  void onSearchHorizontalDragUpdate(details) {
    offsetSearch -= details.delta.dx;
    if (offsetSearch < 0) {
      offsetSearch = 0;
    } else if (offsetSearch > (347 - 68.0)) {
      offsetSearch = 347 - 68.0;
    }
    setState(() {});
  }

  /// explore drag callback
  void onExploreVerticalUpdate(details) {
    offsetExplore -= details.delta.dy;
    if (offsetExplore > 644) {
      offsetExplore = 644;
    } else if (offsetExplore < 0) {
      offsetExplore = 0;
    }
    setState(() {});
  }

  /// animate Explore
  ///
  /// if [open] is true , make Explore open
  /// else make Explore close
  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                    (isExploreOpen
                        ? currentExplorePercent
                        : (1 - currentExplorePercent)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerExplore!, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
        .animate(curve)
      ..addListener(() {
        setState(() {
          offsetExplore = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isExploreOpen = open;
        }
      });
    animationControllerExplore!.forward();
  }

  void animateSearch(bool open) {
    animationControllerSearch = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                    (isSearchOpen
                        ? currentSearchPercent
                        : (1 - currentSearchPercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerSearch!, curve: Curves.ease);
    animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0)
        .animate(curve)
      ..addListener(() {
        setState(() {
          offsetSearch = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isSearchOpen = open;
        }
      });
    animationControllerSearch!.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu!, curve: Curves.ease);
    animation =
    Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetMenu = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isMenuOpen = open;
        }
      });
    animationControllerMenu!.forward();
  }

  List<Position> _positions = [];
  late int _posIndex = 0;
  late LatLng _mapCenter = LatLng(33.8869, 9.5375);
  deviceSearching(val) {
    searchOpacity = 1;
    setState(() {
      _appProvider.setSelectedId(id: int.parse(val));
    });
    _position = _appProvider.getPositionById(int.parse(val));
    _appProvider.setSelectedDevice(int.parse(val));
    _appProvider.setSelectedDevicePosition(_position!);
    _mapCenter = LatLng(_position!.latitude, _position!.longitude);
    mcontroller.animateCamera(CameraUpdate.newLatLngZoom(_mapCenter, 16));
    mcontroller.showMarkerInfoWindow(MarkerId((val.toString())));
  }

  nextDevice() {
    _selectedDeviceController.clear();
    _idValueChanged = '';
    _idValueToValidate = '';
    _idValueSaved = '';
    searchOpacity = 0.7;
    print('posIndex$_posIndex');
    print('posIndex::${_positions.length}');

    if (_posIndex == _positions.length) {
      _posIndex = 0;
      print('posIndexpos0Index');
      _mapCenter = LatLng(
          _positions[_posIndex].latitude, _positions[_posIndex].longitude);

      setState(() {
        _appProvider.setSelectedId(id: _positions[_posIndex].deviceId);
      });
      _position = _appProvider.getPositionById(_positions[_posIndex].deviceId);
      _appProvider.setSelectedDevice(_positions[_posIndex].deviceId);
      _appProvider.setSelectedDevicePosition(_position!);
      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(_mapCenter, 16));
      mcontroller.showMarkerInfoWindow(
          MarkerId((_positions[_posIndex].deviceId.toString())));
      _posIndex += 1;
    } else {
      _mapCenter = LatLng(
          _positions[_posIndex].latitude, _positions[_posIndex].longitude);

      setState(() {
        _appProvider.setSelectedId(id: _positions[_posIndex].deviceId);
      });
      _position = _appProvider.getPositionById(_positions[_posIndex].deviceId);
      _appProvider.setSelectedDevice(_positions[_posIndex].deviceId);
      _appProvider.setSelectedDevicePosition(_position!);
      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(_mapCenter, 16));
      mcontroller.showMarkerInfoWindow(
          MarkerId((_positions[_posIndex].deviceId.toString())));
      _posIndex += 1;
    }
  }

  MapType _currentMapType = MapType.hybrid;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
      _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
    print(_currentMapType);
  }

  late bool geoDrawed = false;
  late Set<Polygon> polygonSet = new Set();
  late List<LatLng> polygonCoords = [];
  late Set<Circle> cirlcesSet = new Set();

  drawGeoFencesOnMap(List<GeoFence> geofences) {
    if (geoDrawed == false && _geofences != []) {
      polygonSet.clear();
      cirlcesSet.clear();
      for (var geo in geofences) {
        polygonCoords = [];
        print('geogeo:${geo.area}');
        geoDrawed = true;
        if (geo.area[0] == 'P')
          convertGeoPolygon(geo.id, geo.area, geo.attributes!.color);
        if (geo.area[0] == 'C')
          convertGeoCircle(geo.id, geo.area, geo.attributes!.color);
      }
    }
  }

  convertGeoCircle(id, area, color) {
    String center = area.substring(area.indexOf("(") + 1, area.indexOf(","));
    String rayan = area.substring(area.indexOf(",") + 1, area.indexOf(")"));
    String xCenter = center.substring(0, center.indexOf(" "));
    String yCenter = center.substring(
      center.indexOf(" "),
    );
    Color circleColor;
    if (color == null)
      circleColor = AppColors.lightBackground; //Color(0x7FFFFFFF);
    else
      circleColor =
          Color(int.parse(color.replaceAll('#', '0xFF914DFF'))); //'0x7F'

    cirlcesSet.add(Circle(
        circleId: CircleId(id.toString()),
        center: LatLng(double.parse(xCenter), double.parse(yCenter)),
        radius: double.parse(rayan),
        fillColor: circleColor,
        strokeColor: circleColor));
  }

  convertGeoPolygon(id, area, color) {
    late String sub = '';
    late String sub2 = '';
    late String conv = '';

    area = area.substring(area.indexOf("(") + 2, area.indexOf(")")) + ',';
    while (area != '') {
      sub = area.substring(0, area.indexOf(",") + 1);
      area = area.replaceAll(sub, '');
      sub = sub.replaceAll(',', '');
      print('area::$sub');
      String x = sub.split(' ')[0];
      String y = sub.split(' ')[1];
      polygonCoords.add(LatLng(double.parse(x), double.parse(y)));
    }
    Color polyColor;
    if (color == null)
      polyColor = AppColors.lightBackground; //Color(0x7FFFFFFF);
    else
      polyColor =
          Color(int.parse(color.replaceAll('#', '0xFF914DFF'))); //'0x7F'
    polygonSet.add(Polygon(
        polygonId: PolygonId(id.toString()),
        points: polygonCoords,
        strokeColor: polyColor,
        fillColor: polyColor,
        strokeWidth: 5));

    /*
    if (area[0] == 'C') {
      String center = area.substring(area.indexOf("(") + 1, area.indexOf(","));
      String rayan = area.substring(area.indexOf(",") + 1, area.indexOf(")"));
      String xCenter = center.substring(0, center.indexOf(" "));
      String yCenter = center.substring(
        center.indexOf(" "),
      );
      print('rayan$center');
      print('rayan$xCenter');
      print('rayan$yCenter');
      print('rayan$rayan');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    // var _language = Provider.of<Language>(context);
    _devices = _appProvider.getDevices();
    _selectSearchItemsDevice.clear();
    for (var e in _devices) {
      _selectSearchItemsDevice.add(
        {
          'value': e.id,
          'label': e.name!.toUpperCase(),
          'icon': Icon(Icons.car_rental),
          'textStyle': TextStyle(color: Colors.black),
        },
      );
    }
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            body: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        //  color: Colors.white70,
                        //margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      if (value != 0.0)
                        SafeArea(
                          child: Container(
                            width: 200.0,
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Container(
                                    height: 250,
                                    child: DrawerHeader(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                  "assets/images/logo.png"),
                                            ),
                                            Expanded(
                                                child: Text(
                                                  username.split("@").first,
                                                  style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 18),
                                                )),
                                          ],
                                        ))),
                                Expanded(
                                    child: ListView(
                                      children: [
                                        buildMenuItem(context,
                                            text: _language.tHome(),
                                            icon: Icons.home,
                                            route: '/home'),
                                        /*    buildMenuItem(context,
                                  text: _language.tReplay(),
                                  icon: Icons.repeat,
                                  route: '/replay'),
                              buildMenuItem(context,
                                  text: _language.tconsom(),
                                  icon: Icons.liquor,
                                  route: '/consommation'),*/
                                        buildMenuItem(context,
                                            text: _language.tDevices(),
                                            icon: Icons.directions_car_rounded,
                                            route: '/devices'),
/*
                                        buildMenuItem(context,
                                        text: "deviceReDe",
                                        icon: Icons.car_rental,
                                        route: '/devicesReDes'),
                                    */
                                        buildMenuItem(context,
                                            text:
                                            _language.tMaintenanceMaintenance(),
                                            icon: Icons.car_repair_rounded,
                                            route: '/maintenance'),
                                        buildMenuItem(context,
                                            text: _language.tMaintenancePaper(),
                                            icon: Icons.event_note_rounded,
                                            route: '/devicePaper'),
                                        /*
                                       buildMenuItem(context,
                                      text: "Accessoires",
                                      icon: Icons.auto_awesome_mosaic_outlined,
                                      route: '/deviceAccessoires'),

                              buildMenuItem(context,
                                  text: _language.tReport(),
                                  icon: Icons.report,
                                  route: '/report'),
                              buildMenuItem(context,
                                  text: _language.tGraphic(),
                                  icon: Icons.graphic_eq,
                                  route: '/graphic'),
                              buildMenuItem(context,
                                  text: _language.tDrivers(),
                                  icon: Icons.drive_eta_rounded,
                                  route: '/driver'),
                                  */
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        buildMenuItem(context,
                                            text: _language.tSettings(),
                                            icon: Icons.settings,
                                            route: '/settings'),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      new TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: value),
                          duration: Duration(milliseconds: 500),
                          builder: (_, double val, __) {
                            return (Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..setEntry(0, 3, 200 * val)
                                ..rotateY((pi / 6) * val),
                              child: Stack(
                                children: <Widget>[
                                  googleMapUI(),
                                  //explore
                                  ExploreWidget(
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    currentSearchPercent: currentSearchPercent,
                                    animateExplore: animateExplore,
                                    isExploreOpen: isExploreOpen,
                                    onVerticalDragUpdate:
                                    onExploreVerticalUpdate,
                                    onPanDown: () =>
                                        animationControllerExplore?.stop(),
                                    language: _language,
                                  ),

                                  /*
                              Visibility(
                                visible: _visibility,
                                child: ExploreWidget(
                                  currentExplorePercent: currentExplorePercent,
                                  currentSearchPercent: currentSearchPercent,
                                  animateExplore: animateExplore,
                                  isExploreOpen: isExploreOpen,
                                  onVerticalDragUpdate: onExploreVerticalUpdate,
                                  onPanDown: () =>
                                      animationControllerExplore?.stop(),
                                ),
                              ),
*/
                                  //blur
                                  offsetSearch != 0
                                      ? BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10 * currentSearchPercent
                                        as double,
                                        sigmaY: 10 * currentSearchPercent
                                        as double),
                                    child: Container(
                                      color: Colors.white.withOpacity(
                                          0.1 * currentSearchPercent),
                                      width: screenWidth,
                                      height: screenHeight,
                                    ),
                                  )
                                      : const Padding(
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  //explore content
                                  ExploreContentWidget(
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    selectedId: _selectedId,
                                    device: _device,
                                    position: _position,
                                    language: _language,
                                    deviceCategory: _appProvider
                                        .getDeviceCategoryByID(_selectedId),
                                  ),

                                  //recent search
                                  RecentSearchWidget(
                                    currentSearchPercent: currentSearchPercent,
                                  ),
                                  //search menu background
                                  offsetSearch != 0
                                      ? Positioned(
                                    bottom: realH(88),
                                    left:
                                    realW((standardWidth - 320) / 2),
                                    width: realW(320),
                                    height: realH(135 *
                                        currentSearchPercent as double),
                                    child: Opacity(
                                      opacity: currentSearchPercent,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.only(
                                                topLeft:
                                                Radius.circular(
                                                    realW(33)),
                                                topRight:
                                                Radius.circular(
                                                    realW(33)))),
                                      ),
                                    ),
                                  )
                                      : const Padding(
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  //search menu
                                  SearchMenuWidget(
                                    currentSearchPercent: currentSearchPercent,
                                    language: _language,
                                  ),
                                  //search
                                  /*  SearchWidget(
                                currentSearchPercent: currentSearchPercent,
                                currentExplorePercent: currentExplorePercent,
                                isSearchOpen: isSearchOpen,
                                animateSearch: animateSearch,
                                onHorizontalDragUpdate:
                                    onSearchHorizontalDragUpdate,
                                onPanDown: () =>
                                    animationControllerSearch?.stop(),
                              ),*/
                                  //search back
                                  SearchBackWidget(
                                    currentSearchPercent: currentSearchPercent,
                                    animateSearch: animateSearch,
                                    language: _language,
                                  ),
                                  //layer button
                                  MapButton(
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    currentSearchPercent: currentSearchPercent,
                                    bottom: 243,
                                    offsetX: -71,
                                    width: 71,
                                    height: 71,
                                    isRight: false,
                                    icon: Icons.layers,
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(255, 189, 89, 1),
                                      Color.fromRGBO(255, 145, 77, 1),
                                      //Color(0xFF59C2FF),
                                      //Color(0xFF1270E3),
                                    ]),
                                    child: IconButton(
                                        onPressed: () {
                                          // print('childchild');
                                          _onMapTypeButtonPressed();
                                        },
                                        icon: Icon(
                                          Icons.layers,
                                          size: realW(34),
                                          color: Colors.white,
                                        )),
                                  ),

                                  /*                                ////////SEARCHSECTION
                                  MapButton(
                                    currentExplorePercent:
                                        currentExplorePercent,
                                    currentSearchPercent: currentSearchPercent,
                                    bottom: 158,
                                    offsetX: -71,
                                    width: 71,
                                    height: 71,
                                    isRight: false,
                                    icon: Icons.layers,
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFF59C2FF),
                                      Color(0xFF1270E3),
                                    ]),
                                    child: IconButton(
                                        onPressed: () {
                                          // print('childchild');
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  //title: Text(_language.tUpdate()),
                                                  content: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Form(
                                                              key: addFormKey,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SelectFormField(
                                                                    type: SelectFormFieldType
                                                                        .dialog,
                                                                    controller:
                                                                        _selectedDeviceController,
                                                                    //initialValue: _initialValue,
                                                                    icon: Icon(Icons
                                                                        .car_rental),
                                                                    labelText:
                                                                        _language
                                                                            .tChooseDevice(),
                                                                    changeIcon:
                                                                        true,
                                                                    dialogTitle:
                                                                        _language
                                                                            .tDevices(),
                                                                    dialogCancelBtn:
                                                                        _language
                                                                            .tCancel(),
                                                                    enableSearch:
                                                                        true,
                                                                    dialogSearchHint:
                                                                        _language
                                                                            .tSearch(),
                                                                    items:
                                                                        _selectSearchItemsDevice,
                                                                    onChanged: (val) =>
                                                                        setState(() =>
                                                                            _idValueChanged =
                                                                                val),
                                                                    validator:
                                                                        (val) {
                                                                      setState(() =>
                                                                          _idValueToValidate =
                                                                              val ?? '');
                                                                      return null;
                                                                    },
                                                                    onSaved: (val) =>
                                                                        setState(() =>
                                                                            _idValueSaved =
                                                                                val ?? ''),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                             );
                                              });
                                        },
                                        icon: Icon(
                                          Icons.search,
                                          size: realW(34),
                                          color: Colors.white,
                                        )),
                                  ),
*/
//fitBounds button

                                  MapButton(
                                    currentSearchPercent: currentSearchPercent,
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    bottom: 243,
                                    offsetX: -68,
                                    width: 68,
                                    height: 71,
                                    icon: Icons.car_rental,
                                    iconColor: Colors.white,
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(255, 189, 89, 1),
                                      Color.fromRGBO(255, 145, 77, 1),

                                      //Color(0xFF59C2FF),
                                      //Color(0xFF1270E3),
                                    ]),
                                    child: IconButton(
                                        onPressed: () {
                                          // print('childchild');
                                          mcontroller.animateCamera(
                                              CameraUpdate.newLatLngBounds(
                                                  _latLngBounds, 100));
                                        },
                                        icon: Icon(
                                          Icons.wifi_protected_setup_rounded,
                                          size: realW(34),
                                          color: Colors.white,
                                        )),
                                  ),
//Skip Button
                                  /*MapButton(
                                    currentSearchPercent: currentSearchPercent,
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    bottom: 158,
                                    offsetX: -68,
                                    width: 68,
                                    height: 71,
                                    icon: Icons.my_location,
                                    iconColor: Colors.orange,
                                    child: IconButton(
                                        onPressed: () {
                                          if (_positions.length != 0) {
                                            print('posindexCall');
                                            nextDevice();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.skip_next,
                                          size: realW(34),
                                          color: Colors.orange,
                                        )),
                                  ),*/

                                  //Notif Button
                                  MapButton(
                                    currentSearchPercent: currentSearchPercent,
                                    currentExplorePercent:
                                    currentExplorePercent,
                                    bottom: 73,
                                    offsetX: -68,
                                    width: 68,
                                    height: 71,
                                    icon: Icons.my_location,
                                    iconColor: Colors.orange,
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(255, 189, 89, 1),
                                      Color.fromRGBO(255, 145, 77, 1),

                                      //Color(0xFF59C2FF),
                                      //Color(0xFF1270E3),
                                    ]),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/alerte');
                                        },
                                        icon: Icon(
                                          Icons.notifications_active_outlined,
                                          size: realW(34),
                                          color: Colors.white,
                                        )),
                                  ),

                                  //////////MapSection///////////
                                  Positioned(
                                      top: realH(20),
                                      left: realW(500 *
                                          (currentExplorePercent +
                                              currentSearchPercent) as double),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //animateMenu(true);
                                              setState(() {
                                                value == 0.0
                                                    ? value = 1.0
                                                    : value = 0.0;
                                              });
                                            },
                                            child: Opacity(
                                                opacity: 1 -
                                                    (currentSearchPercent +
                                                        currentExplorePercent)
                                                    as double,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        searchOpacity = 1;
                                                        print(
                                                            'searOpacity:$searchOpacity');
                                                      },
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            8.0,
                                                            8.0,
                                                            20.0,
                                                            8.0),
                                                        height: 65,
                                                        width: (MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width) -
                                                            40,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.0),
                                                            color: Colors.white
                                                                .withOpacity(
                                                                searchOpacity)),
                                                        child: SelectFormField(
                                                          type:
                                                          SelectFormFieldType
                                                              .dialog,
                                                          controller:
                                                          _selectedDeviceController,
                                                          //initialValue: _initialValue,

                                                          icon: Icon(
                                                            Icons.search,
                                                            color:
                                                            Colors.orange,
                                                          ),
                                                          labelText: _language
                                                              .tChooseDevice(),
                                                          cursorColor:
                                                          Colors.orange,
                                                          autocorrect: true,
                                                          changeIcon: true,
                                                          //dialogTitle: _language
                                                          //  .tDevices(),
                                                          dialogSearchHint:
                                                          _language
                                                              .tSearch(),

                                                          dialogCancelBtn:
                                                          _language
                                                              .tCancel(),
                                                          enableSearch: true,

                                                          style: TextStyle(
                                                            color:
                                                            Colors.orange,
                                                          ),
                                                          items:
                                                          _selectSearchItemsDevice,
                                                          onChanged: (val) {
                                                            setState(() => {
                                                              _idValueChanged =
                                                                  val,
                                                              print(
                                                                  'valChanged$val'),
                                                            });
                                                            deviceSearching(
                                                                val);
                                                          },

                                                          validator: (val) {
                                                            setState(() =>
                                                            _idValueToValidate =
                                                                val ?? '');
                                                            return null;
                                                          },
                                                          onSaved: (val) =>
                                                              setState(() => {
                                                                _idValueSaved =
                                                                    val ??
                                                                        '',
                                                              }),
                                                        ),
                                                      )),
                                                )),
                                          ),
                                        ],
                                      )),

                                  ///

                                  //menu button

                                  Positioned(
                                    bottom: realH(73),
                                    left: realW(-71 *
                                        (currentExplorePercent +
                                            currentSearchPercent) as double),
                                    child: GestureDetector(
                                      onTap: () {
                                        //animateMenu(true);
                                        setState(() {
                                          value == 0.0
                                              ? value = 1.0
                                              : value = 0.0;
                                        });
                                      },
                                      child: Opacity(
                                        opacity: 1 -
                                            (currentSearchPercent +
                                                currentExplorePercent)
                                            as double,
                                        child: Container(
                                          width: realW(71),
                                          height: realH(71),
                                          alignment: Alignment.centerLeft,
                                          padding:
                                          EdgeInsets.only(left: realW(17)),
                                          child: Icon(
                                            Icons.menu,
                                            size: realW(32),
                                            color: Colors.white,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                      realW(36)),
                                                  topRight: Radius.circular(
                                                      realW(36))),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.3),
                                                    blurRadius: realW(36)),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //menu
                                  /*
            MenuWidget(
                currentMenuPercent: currentMenuPercent,
                animateMenu: animateMenu),
               */
                                ],
                              ),
                            ));
                          }),
                    ],
                  ),
                ))));
  }

  Widget googleMapUI() {
    _appProvider = Provider.of<AppProvider>(context);
    _positions = Provider.of<AppProvider>(context, listen: true).getPositions;

    _geofences = _appProvider.getGeoFences();
    // print('geoF::${_geofences[0].area}');
    drawGeoFencesOnMap(_geofences);
    return Consumer<AppProvider>(builder: (consumerContext, model, child) {
      setVisibility(model.selectedId);

      if (model.markerss != null && model.markerss.length != 0) {
        //_initMarkers(model.mapmarkers);
        fitBounds(model.latLngBounds);
        // print("selectedDevice::${model.selectedId}");
        //  print('selectedDevice${model.selectedDevice.name}');
        //print('selectedDevice${model.selectedPosition.address}');
        getDevicePosition(
            model.selectedId, model.selectedPosition, model.selectedDevice);
        return Column(
          children: [
            //  Expanded(child: LeafletMap()),

            Expanded(
              child: GoogleMap(
                mapType: _currentMapType,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                polygons: polygonSet,
                circles: cirlcesSet,
                onTap: (position) {
                  setState(() {
                    if (isExploreOpen == false)
                      _appProvider.setSelectedId(id: 0);
                    _selectedDeviceController.clear();
                    _idValueChanged = '';
                    _idValueToValidate = '';
                    _idValueSaved = '';
                    searchOpacity = 0.7;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: _mapCenter,
                  zoom: _currentZoom,
                ),
                markers: model.markerss,
                onMapCreated: (controller) => {
                  _onMapCreated(controller, model.markerss),
                },
                onCameraMove: (position) => _updateMarkers(position.zoom),
              ),
            ),
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  String username = "";
  late WebSocketChannel channel;
  var list;
  late AppProvider _appProvider;

  checkLoginStatus() async {
    // channel = IOWebSocketChannel.connect('wss://tracking.emkatech/api/socket');
    //channel.stream.listen((data) => setState(() => print('data::$data')));

    //print('listlist::$list');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    username = sharedPreferences.getString('username')!;
    print('username::$username');
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerExplore?.dispose();
    animationControllerSearch?.dispose();
    animationControllerMenu?.dispose();
  }
}

logoutFunction(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove('username');
  sharedPreferences.remove('password');
  sharedPreferences.remove('kCookieKey');
  sharedPreferences.clear();
  Provider.of<AppProvider>(context, listen: false).setLoggedIn(status: false);
  // sharedPreferences.commit();
  Navigator.of(context).pushNamed('/login');
}

Widget buildMenuItem(BuildContext context,
    {required String text, required IconData icon, required String route}) {
  final color = Colors.black;
  return Material(
    child: ListTile(
      minLeadingWidth: 10,
      leading: Icon(
        icon,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    ),
  );
}