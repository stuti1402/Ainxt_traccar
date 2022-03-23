import 'dart:io';
import 'dart:typed_data';

import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/helper/map_helper.dart';
import 'package:emka_gps/helper/map_marker.dart';
import 'package:emka_gps/models/chart.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/models/geoFence.dart';
import 'package:emka_gps/models/maintenance.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/models/stops.dart';
import 'package:emka_gps/models/summary.dart';
import 'package:emka_gps/models/trips.dart';
import 'package:emka_gps/models/user.dart';
import 'package:emka_gps/screens/google_map_page.dart';
import 'package:emka_gps/screens/maintenance.dart';
import 'package:fluster/fluster.dart';
import 'package:latlong2/latlong.dart' as latlong2;

//import 'package:device/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as prefix;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
//import 'package:flutter_tracking_app/models/device.custom.dart';
//import 'package:flutter_tracking_app/models/user.model.dart';
//import 'package:flutter_tracking_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:traccar_client/traccar_client.dart';
//import '../traccar_client/traccar_client.dart';
import 'dart:ui' as ui;

class AppProvider with ChangeNotifier {
  late bool isLoggedIn = false;
  late bool isResLoggedIn = false;
  late bool isResLoggedOut = false;

  int homeActiveTabIndex = 2;
  // User user = new User();
  late User user;
  List<Device> _devices = [];
  List<Maintenances> _maintenance = [];
  List<Event> _events = [];
  List<Stops> _stops = [];
  List<Position> _todayTrip = [];
  List<SummaryModel> _summary = [];

  List<Trips> _trips = [];

  List<GeoFence> _geoFences = [];
  List<Chart> _charts = [];

  late String _apiCookie = "";
  late bool rememberMe = false;
  List<Position> _positions = [];
  late BitmapDescriptor _pinLocationIcon;
  late BitmapDescriptor _pinLocationIconMove;
  late Set<Marker> _stopsMarkers = Set();
  Set<Marker> get stopsMarkers => _stopsMarkers;

  late Set<Marker> _eventMarker = Set();
  Set<Marker> get eventMarker => _eventMarker;
  late Position _selectedEventPosition;
  Position get selectedEventPosition => _selectedEventPosition;
  late Set<Marker> _markerss = Set();
  Set<Marker> get markerss => _markerss;
  late Set<Marker> _markertoSuivi = Set();
  Set<Marker> get markersToSuivi => _markertoSuivi;

  late Set<Marker> _markerStartEndTrips = Set();
  Set<Marker> get markerStartEndTrips => _markerStartEndTrips;

  LatLng _centerToSuivi = LatLng(35, 9);
  LatLng get centerToSuivi => _centerToSuivi;
  LatLng _eventMapCenter = LatLng(35, 9);
  LatLng get eventMapCenter => _eventMapCenter;
  LatLng _centerFirstStop = LatLng(35, 9);
  LatLng get centerFirstStop => _centerFirstStop;
  LatLng _centerTodayTrip = LatLng(35, 9);
  LatLng get centerTodayTrip => _centerTodayTrip;
  late LatLng minBounds;
  late LatLng maxBounds;

  late LatLngBounds _latLngBounds =
      LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
  LatLngBounds get latLngBounds => _latLngBounds;

  late LatLngBounds _stopsLatLngBounds =
      LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
  LatLngBounds get stopsLatLngBounds => _stopsLatLngBounds;

  late Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;
  late List<prefix.Marker> _mapmarkersL = [];
  List<prefix.Marker> get mapmarkersL => _mapmarkersL;
  List points = [
    latlong2.LatLng(35.5, 9.709),
    latlong2.LatLng(35.8566, 9.8522),
  ];
  late int pointIndex = 0;
  final MarkerId markerId = MarkerId("0");
  late int _selectedId = 0;
  int get selectedId => _selectedId;

  late Position _selectedPosition = new Position(
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
  Position get selectedPosition => _selectedPosition;

  late Device _selectedDevice = new Device(
      status: 'status',
      disabled: false,
      lastUpdate: 'lastUpdate',
      position: null);
  Device get selectedDevice => _selectedDevice;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  late Location _location;
  Location get location => _location;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon;
  BitmapDescriptor get pinLocationIconMove => _pinLocationIconMove;

  late LatLng _locationPosition = LatLng(33.8869, 9.5375);
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Markers loading flag
  bool _areMarkersLoading = true;
  late List<LatLng> _markerLocations;
  List<LatLng> get markerLocations => _markerLocations;
  final Color _clusterColor = Colors.blue;
  late List<MapMarker> _mapmarkers = [];
  List<MapMarker> get mapmarkers => _mapmarkers;
  late Uint8List moveIcon;
    late Uint8List eventIcon;

  late Uint8List stoppedIcon;
  late Uint8List parkIcon;
  late Uint8List startMarker;

  late bool setbounds = false;
  late String _devicesIds = '';
  late Set<Polyline> polylineSet = new Set();
  late List<LatLng> pointsPlyline = [];

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  AppProvider() {
    _location = new Location();
    _markers = <MarkerId, Marker>{};
    _markerLocations = <LatLng>[];
    _mapmarkers = <MapMarker>[];
    _mapmarkersL = <prefix.Marker>[];
  }

  //loggedIn Updates
  Future setLoggedIn({required bool status}) async {
    isLoggedIn = status;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool('kIsloggedInKey', status);
  }

  Future getLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print(
        'the preference value ${sharedPreferences.getBool('kIsloggedInKey')}');
    isLoggedIn = sharedPreferences.getBool('kIsloggedInKey') ?? isLoggedIn;
    return Future.value(isLoggedIn);
  }

  setSelectedId({required id}) {
    _selectedId = id;
  }

  setResLoggedIn({required res}) {
    isResLoggedIn = res;
  }

  getResLoggedIn() {
    return isResLoggedIn;
  }

  setResLoggedOut({required res}) {
    isResLoggedOut = res;
  }

  getResLoggedOut() {
    return isResLoggedOut;
  }

  setSelectedDevicePosition(Position e) {
    _selectedPosition = e;
    //_selectedDevice = getDeviceById(e.deviceId);
  }

  setSelectedDevice(int id) {
    _selectedDevice = getDeviceById(id);
    //_selectedDevice = getDeviceById(e.deviceId);
  }

  setSuiviDevicePosition(id) {
    _markertoSuivi.clear();
    _selectedDevice = getDeviceById(id);
    _selectedPosition = getPositionById(id);
    _centerToSuivi =
        LatLng(_selectedPosition.latitude, _selectedPosition.longitude);
    Marker newMarkerToSuivi = Marker(
      markerId: MarkerId(_selectedPosition.deviceId.toString()),

      position: LatLng(
        _selectedPosition.latitude,
        _selectedPosition.longitude,
      ),
      rotation: (_selectedPosition.course!),
      icon: getIcon(_selectedPosition.attributes.motion!),
      /* infoWindow: InfoWindow(
            title: getDeviceById(e.deviceId).name,
            snippet: (e.speed * 1.852).toString(),
          ),*/
      onTap: () {
        print('Marker clicked');
      },
      //icon:BitmapDescriptor.fromBytes(markerIcon),
      draggable: false,
    );
    // _latLngBounds = LatLngBounds(northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
    _markertoSuivi.add(newMarkerToSuivi);
    print('initokok');
  }

  //User states
  setUser({required User user}) {
    user = user;
  }

  User getUser() {
    return user;
  }

  //Active Tabs//
  getSelectedTabIndex() => homeActiveTabIndex;
  setSelectedTabIndex(int index) {
    homeActiveTabIndex = index;
    notifyListeners();
  }

  //Devices
  List<Device> getDevices() => _devices;
  setDevices(List<Device> device) {
    _devices = device;
    notifyListeners();
  }

  List<Maintenances> getMaintenances() => _maintenance;
  setMaintenance(List<Maintenances> maintenance) {
    _maintenance = maintenance;
    notifyListeners();
  }

  String getDevicesIds() => _devicesIds;
  setDevicesIds(String devicesIds) {
    _devicesIds = devicesIds;
  }

  bool checkIsIdExist(int id) {
    if (_devicesIds.contains(id.toString()))
      return true;
    else
      return false;
  }

  clearMarkerss() {
    _markerss.clear();
  }

  List<Event> getEvents() => _events;
  setEvents(events) {
    _events = events;
    notifyListeners();
  }

  List<Stops> getStops() => _stops;
  setStops(stops) {
    _stops = stops;
    notifyListeners();
  }

  List<Position> getTodayTrip() => _todayTrip;
  setTodayTrip(todayTrip) {
    _todayTrip = todayTrip;
    notifyListeners();
  }

  setTodayTripPolyline(List<Position> _todayTrip) {
    pointsPlyline = [];
    polylineSet.clear();

    for (var e in _todayTrip) {
      pointsPlyline.add(LatLng(e.latitude, e.longitude));
    }

    if (_todayTrip.length != 0) {
      int index = (_todayTrip.length / 2).toInt();
      _centerTodayTrip =
          LatLng(_todayTrip[index].latitude, _todayTrip[index].longitude);

      Marker newStartMarker = Marker(
        markerId: MarkerId(_todayTrip[0].id.toString()),

        position: LatLng(
          _todayTrip[0].latitude,
          _todayTrip[0].longitude,
        ),

        icon: getStartIcon(),
        infoWindow: InfoWindow(
          title: (_todayTrip[0].address != null && _todayTrip[0].address != '')
              ? _todayTrip[0].address
              : 'Address Not Found',
        ),
        onTap: () {
          print('Marker clicked');
        },
        //icon:BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
      );

      Marker newEndMarker = Marker(
        markerId: MarkerId(_todayTrip[_todayTrip.length - 1].id.toString()),

        position: LatLng(
          _todayTrip[_todayTrip.length - 1].latitude,
          _todayTrip[_todayTrip.length - 1].longitude,
        ),
        rotation: _todayTrip[_todayTrip.length - 1].course!,
        icon: getIcon(_todayTrip[_todayTrip.length - 1].attributes.motion!),
        infoWindow: InfoWindow(
          title: (_todayTrip[_todayTrip.length - 1].address != null &&
                  _todayTrip[_todayTrip.length - 1].address != '')
              ? _todayTrip[_todayTrip.length - 1].address
              : 'Address Not Found',
          // snippet: stp.duration.toString(),
        ),
        onTap: () {
          print('Marker clicked');
        },
        //icon:BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
      );
      _markerStartEndTrips.clear();

      _markerStartEndTrips.add(newStartMarker);

      _markerStartEndTrips.add(newEndMarker);
    }

    print('polypoints${pointsPlyline.length}');
    polylineSet.add(Polyline(
      polylineId: PolylineId('1'),
      points: pointsPlyline,
      color: Colors.blue,
      width: 3,
    ));
  }

  List<SummaryModel> getSummary() => _summary;
  setSummary(summary) {
    _summary = summary;
    notifyListeners();
  }

  setEventMarker(posId) {
    _eventMarker.clear();

    Position pos = getPositionByPosId(posId);
    _selectedEventPosition = pos;
    notifyListeners();
    _eventMapCenter = LatLng(pos.latitude, pos.longitude);
    Marker newEventMarker = Marker(
      markerId: MarkerId(posId.toString()),

      position: LatLng(
        pos.latitude,
        pos.longitude,
      ),
      rotation: pos.course!,
      icon: getEventIcon(),
      infoWindow: InfoWindow(
        title: (pos.address != null && pos.address != '')
            ? pos.address
            : 'Address Not Found',
        // snippet: stp.duration.toString(),
      ),
      onTap: () {
        print('Marker clicked');
      },
      //icon:BitmapDescriptor.fromBytes(markerIcon),
      draggable: false,
    );
    // _latLngBounds = LatLngBounds(northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
    _eventMarker.add(newEventMarker);
  }

  setStopsMapMarkers(List<Stops> stopsList) {
    _stopsMarkers.clear();
    print("lenghth::${stopsList.length}");
    int index = 0;
    ///////////
    double minLat = 35;
    double maxLat = 35;
    double minLon = 9;
    double maxLon = 9;
    if (stopsList.isNotEmpty) {
      minLat = stopsList[0].latitude!;
      maxLat = stopsList[0].latitude!;
      minLon = stopsList[0].longitude!;
      maxLon = stopsList[0].longitude!;
      _centerFirstStop = LatLng(stopsList[0].latitude, stopsList[0].longitude);
    }

    // _centerFirstStop = LatLng(stopsList[0].latitude, stopsList[0].longitude);

    print('centerStop:$_centerFirstStop');
    for (var stp in stopsList) {
      print('stopindex$index');
      notifyListeners();
      if (stp.latitude > maxLat) maxLat = stp.latitude;
      if (stp.latitude < minLat) minLat = stp.latitude;
      if (stp.longitude > maxLon) maxLon = stp.longitude;
      if (stp.longitude < minLon) minLon = stp.longitude;
      notifyListeners();
      Marker newStopMarker = Marker(
        markerId: MarkerId(index.toString()),

        position: LatLng(
          stp.latitude,
          stp.longitude,
        ),

        icon: getStopIcon(),
        infoWindow: InfoWindow(
          title: (stp.address != null && stp.address != '')
              ? stp.address
              : 'Address Not Found',
          // snippet: stp.duration.toString(),
        ),
        onTap: () {
          print('Marker clicked');
        },
        //icon:BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
      );
      // _latLngBounds = LatLngBounds(northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
      _stopsMarkers.add(newStopMarker);
      index += 1;
    }
    _stopsLatLngBounds = LatLngBounds(
        northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
  }

  List<GeoFence> getGeoFences() => _geoFences;
  setGeoFences(List<GeoFence> geofence) {
    _geoFences = geofence;
    // print('geofences::${_geoFences[0].area}');
    notifyListeners();
  }

  List<Chart> getCharts() => _charts;
  setCharts(charts) {
    _charts = charts;
    notifyListeners();
  }

  String getCookie() => _apiCookie;

  setCookie({required String apiCookie}) {
    _apiCookie = apiCookie;
    notifyListeners();
  }

  addPosition({required Position position}) {
    _positions.add(position);
    notifyListeners();
  }

  replacePosition({required Position position, required int index}) async {
    //  print('${_positions[index].id} changed to ${position.id}');
    _positions[index] = position;
    print("change in ${position.deviceId}");
    //_markers.clear();
    _markerss.clear();
    _markertoSuivi.clear();
    // _markerLocations.clear();
    _markerLocations = [];
    _mapmarkers = [];
    _mapmarkersL = [];
    if (setbounds == false) await getLatlngBounds();
    double minLat = _positions[0].latitude;
    double maxLat = _positions[0].latitude;
    double minLon = _positions[0].longitude;
    double maxLon = _positions[0].longitude;
    for (var e in _positions) {
      if (selectedId == e.deviceId) {
        _centerToSuivi = LatLng(e.latitude, e.longitude);
        setSelectedDevicePosition(e);
        setSelectedDevice(e.deviceId);
        Marker newMarkerToSuivi = Marker(
          markerId: MarkerId(e.deviceId.toString()),

          position: LatLng(
            e.latitude,
            e.longitude,
          ),
          rotation: (e.course!),
          icon: getIcon(e.attributes.motion!),
          /* infoWindow: InfoWindow(
            title: getDeviceById(e.deviceId).name,
            snippet: (e.speed * 1.852).toString(),
          ),*/
          onTap: () {
            print('Marker clicked');
          },
          //icon:BitmapDescriptor.fromBytes(markerIcon),
          draggable: false,
        );
        // _latLngBounds = LatLngBounds(northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
        _markertoSuivi.add(newMarkerToSuivi);
      }

      // print('${e.deviceId}:: ${e.id}');
      notifyListeners();
      if (e.latitude > maxLat) maxLat = e.latitude;
      if (e.latitude < minLat) minLat = e.latitude;
      if (e.longitude > maxLon) maxLon = e.longitude;
      if (e.longitude < minLon) minLon = e.longitude;
      _markerLocations.add(LatLng(e.latitude, e.longitude));
      notifyListeners();
      if (_selectedId == e.deviceId) {
        setSelectedDevicePosition(e);
      }

/*
      _mapmarkers.add(MapMarker(
          id: e.deviceId.toString(),
          position: LatLng(
            e.latitude,
            e.longitude,
          ),
          icon: getIcon(e.attributes.motion!),
          infowindow: InfoWindow(
              title: getDeviceById(e.deviceId).name, snippet: e.address),
          rotation: (e.course!)));
*/

      Marker newmarker = Marker(
        markerId: MarkerId(e.deviceId.toString()),

        position: LatLng(
          e.latitude,
          e.longitude,
        ),
        rotation: (e.course!),

        icon: getIcon(e.attributes.motion!),
        infoWindow: InfoWindow(
          title: getDeviceById(e.deviceId).name,
          snippet: e.address,
        ),
        onTap: () {
          print('Marker clicked');
          setSelectedDevicePosition(e);
          setSelectedId(id: e.deviceId);
          setSelectedDevice(e.deviceId);
          _mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            zoom: 15,
            target: LatLng(e.latitude, e.longitude),
          )));
        },
        //icon:BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
      );
      // _latLngBounds = LatLngBounds(northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
      _markerss.add(newmarker);
      notifyListeners();
    }
    print('listlist:: $_markerLocations');
  }

  get getPositions {
    return _positions;
  }

  List<Position> getPositionsList() {
    return _positions;
  }

  setPositions(List<Position> pos) => _positions = pos;

  getLatlngBounds() {
    double minLat = _positions[0].latitude;
    double maxLat = _positions[0].latitude;
    double minLon = _positions[0].longitude;
    double maxLon = _positions[0].longitude;
    for (var e in _positions) {
      // print('${e.deviceId}:: ${e.id}');
      notifyListeners();
      if (e.latitude > maxLat) maxLat = e.latitude;
      if (e.latitude < minLat) minLat = e.latitude;
      if (e.longitude > maxLon) maxLon = e.longitude;
      if (e.longitude < minLon) minLon = e.longitude;
      notifyListeners();
    }
    _latLngBounds = LatLngBounds(
        northeast: LatLng(maxLat, maxLon), southwest: LatLng(minLat, minLon));
    setbounds = true;
    print('lklk$_latLngBounds');
  }

  //////////////////////////
  ///
  initialization() async {
    // await getUserLocation();
    await setCustomMapPin();
    tz.initializeTimeZones();

    await TraccarClientService(appProvider: this).getDevices();
    await TraccarClientService(appProvider: this).getGeoFences();
    TraccarClientService(appProvider: this).getDevicePositionsStream;
    // await getLatlngBounds();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        print(_locationPosition);

        // _markers.clear();

        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            _locationPosition.latitude,
            _locationPosition.longitude,
          ),
          //icon: pinLocationIcon,
          draggable: true,
          onDragEnd: ((newPosition) {
            _locationPosition = LatLng(
              newPosition.latitude,
              newPosition.longitude,
            );

            notifyListeners();
          }),
        );

        _markers[markerId] = marker;

        notifyListeners();
      },
    );
  }

  setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  int iconPxSize() {
    if (Platform.isAndroid) {
      double mq = ui.ViewConfiguration().devicePixelRatio;
      print('mqmq::$mq');
      int px = 65; // default for 1.0x
      if (mq > 1.5 && mq < 2.5) {
        px = 55;
      } else if (mq >= 2.5) {
        px = 45;
      }
      return px;
    }
    // this is for iOS
    return 65;
  }

  setCustomMapPin() async {
    moveIcon =
        await getBytesFromAsset('assets/images/greenarrow.png', iconPxSize());
         eventIcon =
        await getBytesFromAsset('assets/images/blueArrow.png', iconPxSize());
    stoppedIcon =
        await getBytesFromAsset('assets/images/redarrow.png', iconPxSize());
    parkIcon =
        await getBytesFromAsset('assets/images/parking.png', iconPxSize());
    startMarker = await getBytesFromAsset('assets/images/startMarker.png', 100);

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)),
            'assets/images/destination_map_marker.png')
        .then((d) {
      _pinLocationIcon = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)),
            'assets/images/greenarrow.png')
        .then((d) {
      _pinLocationIconMove = d;
    });
  }

  takeSnapshot() {
    return _mapController.takeSnapshot();
  }

  getIcon(bool motion) {
    if (motion == true)
      return BitmapDescriptor.fromBytes(moveIcon);
    else
      return BitmapDescriptor.fromBytes(stoppedIcon);
  }
getEventIcon() {
   
      return BitmapDescriptor.fromBytes(eventIcon);
  }
  getStopIcon() {
    return BitmapDescriptor.fromBytes(parkIcon);
  }

  getStartIcon() {
    return BitmapDescriptor.fromBytes(startMarker);
  }

  Device getDeviceById(int deviceId) {
    return _devices.firstWhere((device) => device.id == deviceId);
  }

  String getDeviceCategoryByID(int deviceId) {
    if (deviceId != null && deviceId != 0) {
      Device device = _devices.firstWhere((device) => device.id == deviceId);
      String category = device.category!;
      return category;
    } else
      return '';
  }

  String getDeviceNameById(int deviceId) {
    Device d = _devices.firstWhere((device) => device.id == deviceId);
    return d.name!;
  }

  int? getDeviceIdByName(String? name) {
    Device d = _devices.firstWhere((device) => device.name == name);
    return d.id;
  }

  double? getDeviceTotalDistanceById(int id) {
    Position d = _positions.firstWhere((pos) => pos.deviceId == id);
    return d.attributes.totalDistance;
  }

  int? getDeviceTotalWorkingHoursById(int id) {
    Position d = _positions.firstWhere((pos) => pos.deviceId == id);

    return d.attributes.hours;
  }

  int? getDeviceHoursById(int id) {
    Position d = _positions.firstWhere((pos) => pos.deviceId == id);
    return d.attributes.hours;
  }

  GeoFence getGeoFenceById(id) {
    GeoFence geofence = _geoFences.firstWhere((geo) => geo.id == id);
    return geofence;
  }
Maintenances getMaintenanceById(id) {
    Maintenances maintenance = _maintenance.firstWhere((maint) => maint.id == id);
    return maintenance;
  }
  Position getPositionById(int deviceId) {
    Position pos = _positions.firstWhere((pos) => pos.deviceId == deviceId);
    print('plpl::${pos.address}');
    return pos;
  }

  Position getPositionByPosId(int id) {
    Position pos = _positions.firstWhere((pos) => pos.deviceId == id);
    print('plpl::${pos.address}');
    return pos;
  }

  bool getMotionId(int deviceId) {
    Position pos = _positions.firstWhere((pos) => pos.deviceId == deviceId);
    bool motion = pos.attributes.motion!;

    return motion;
  }
}
