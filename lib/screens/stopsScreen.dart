import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/stops.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class StopsScreen extends StatefulWidget {
  const StopsScreen({Key? key}) : super(key: key);

  @override
  _StopsScreenState createState() => _StopsScreenState();
}

class _StopsScreenState extends State<StopsScreen> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Stops> _stops = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  late bool refreshed = false;
  LatLngBounds _latLngBounds =
      LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
  late bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isFitbounds = false;
    isLoading = false;
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(StopsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    _stops = [];
    await _getStops();
    if (isLoading == true) {
      _appProvider.setStops(_stops);
      _appProvider.setStopsMapMarkers(_stops);
    }

    _refreshController.refreshCompleted();
    setState(() {
      refreshed = true;
    });
    if (mounted) {
      setState(() {});
    }
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

  Future<List<Stops>> _getStops() async {
    var todayFrom = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 01);

    var todayTo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    String formattedDateFrom =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayFrom);

    String formattedDateTo = DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayTo);
    String from = formattedDateFrom + '.000Z';
    String to = formattedDateTo + '.000Z';

    _stops = await TraccarClientService(appProvider: _appProvider)
        .getReportStops(from: from, to: to)
        .then((value) => _stops = value);
    isLoading = true;
    return _stops;
  }

  LatLng _mapCenter = LatLng(35, 9);

  setMapCenter(center) {
    _mapCenter = center;
    if (isMapCreated)
      mcontroller.animateCamera(CameraUpdate.newLatLng(_mapCenter));
  }

  final Completer<GoogleMapController> _mapSuiviController = Completer();
  late bool isMapCreated = false;
  late GoogleMapController mcontroller;

  void _onMapCreated(GoogleMapController controller) {
    mcontroller = controller;

    // _mapSuiviController.complete(controller);

    setState(() {
      isMapCreated = true;

      mcontroller = controller;
    });
  }

  late int _posIndex = 0;
  late int _stopIndex = 1;

  late Stops _selectedStop = new Stops(
      deviceId: null,
      address: null,
      deviceName: null,
      duration: null,
      spentFuel: null,
      endTime: null,
      engineHours: null,
      latitude: null,
      longitude: null,
      startTime: null);
  nextStop() {
    print('stopsIndex:::$_posIndex');
    if (_posIndex == _stops.length) {
      _posIndex = 0;
      _selectedStop = _stops[0];
      _mapCenter = LatLng(_stops[0].latitude, _stops[0].longitude);

      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(_mapCenter, 16));
      mcontroller.showMarkerInfoWindow(MarkerId((0.toString())));
      _stopIndex = 1;
      _posIndex += 1;
    } else {
      _mapCenter =
          LatLng(_stops[_posIndex].latitude, _stops[_posIndex].longitude);

      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(_mapCenter, 16));
      mcontroller.showMarkerInfoWindow(MarkerId((_posIndex.toString())));
      _selectedStop = _stops[_posIndex];
      if (_posIndex == 0) {
        _stopIndex = 1;
      } else
        _stopIndex += 1;
      _posIndex += 1;
    }
  }

  transformtotime(ms) {
    var mins = Duration(milliseconds: ms).inMinutes;
    if (mins >= 60) {
      var hr = Duration(minutes: mins).inHours;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(hr)} " + _language.tHours();
      return hr.toString() + ' hr';
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(mins)} " + _language.tMinutes();
      else {
        return mins.toString() + ' mn';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _stops = _appProvider.getStops();
    if (refreshed == false) _onRefresh();
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      backgroundColor: Color(0xFF59C2FF),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            Navigator.pop(context);
          }),
        ),
        title: Text(_appProvider
            .getDeviceNameById(_appProvider.selectedId)
            .toString()
            .toUpperCase()),
        backgroundColor: Color(0xFF149cf7),
        centerTitle: true,
      ),
      body:
          isLoading == true ? googleMapForDeviceTrackingUI(_stops) : loading(),
    )
     ); }

  getSpentFuel(fs) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(fs.toInt())} " + _language.tLitre();
    else
      return fs.toString() + ' L';
  }

  Widget googleMapForDeviceTrackingUI(item) {
    return Consumer<AppProvider>(builder: (consumerContext, model, child) {
      if (model.stopsMarkers != null) {
        fitBounds(model.stopsLatLngBounds);

        //  setMapCenter(model.centerFirstStop);
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: GoogleMap(
                mapType: MapType.hybrid,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _mapCenter,
                  zoom: 16,
                ),
                markers: model.stopsMarkers,
                onMapCreated: (controller) => {
                  _onMapCreated(
                    controller,
                  ),
                },
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  color: Colors.white,
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              mcontroller.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      _latLngBounds, 100));
                            },
                            icon: Icon(
                              Icons.replay_outlined,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _stops.length.toString() + _language.tStops(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_stops.length != 0) nextStop();
                            },
                            icon: Icon(
                              Icons.skip_next,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: FittedBox(
                child: _stops.length != 0
                    ? Text(
                        _selectedStop.deviceName != null
                            ? _language.tStopNum() + (_stopIndex).toString()
                            : _language.tNextStop(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      )
                    : Text(
                        _language.tNoStop(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
              ),
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            Expanded(child: deviceDash())
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

  Widget loading() {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingFour(
                color: Colors.blue,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoading(),
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoadingMoreTime(),
                style: TextStyle(color: Colors.blue),
              )
            ],
          )),
    );
  }

  Widget deviceDash() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Color(0xFF1270E3),
            Color(0xFF59C2FF),
          ])),
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: _stops.length != 0
          ? ListView(
              children: [
                ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.white,
                  ),
                  title: Text(
                    _language.tStartTime(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStop.startTime != null
                            ? _selectedStop.startTime.toString().substring(
                                _selectedStop.startTime
                                        .toString()
                                        .indexOf('T') +
                                    1,
                                _selectedStop.startTime.toString().indexOf('.'))
                            : '--',
                        style: TextStyle(color: Colors.grey[100], fontSize: 16),
                      )
                    ],
                  ),
                ),
                ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.white,
                  ),
                  title: Text(
                    _language.tEndTime(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStop.endTime != null
                            ? _selectedStop.endTime.toString().substring(
                                _selectedStop.endTime.toString().indexOf('T') +
                                    1,
                                _selectedStop.endTime.toString().indexOf('.'))
                            : '--',
                        style: TextStyle(color: Colors.grey[100], fontSize: 16),
                      )
                    ],
                  ),
                ),
                ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.white,
                  ),
                  title: Text(
                    _language.tDuration(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStop.duration != null
                            ? transformtotime(_selectedStop.duration)
                            : '--',
                        style: TextStyle(color: Colors.grey[100], fontSize: 16),
                      )
                    ],
                  ),
                ),
                ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.white,
                  ),
                  title: Text(
                    _language.tEngineHours(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStop.engineHours != null
                            ? transformtotime(_selectedStop.engineHours)
                            : '--',
                        style: TextStyle(color: Colors.grey[100], fontSize: 16),
                      )
                    ],
                  ),
                ),
                ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.white,
                  ),
                  title: Text(
                    _language.tFuelSpent(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStop.spentFuel != null
                            ? getSpentFuel(_selectedStop.spentFuel)
                            : '--',
                        style: TextStyle(color: Colors.grey[100], fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                // margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

                width: MediaQuery.of(context).size.width * 0.5,
                child: OutlineButton(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/googleMap');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_language.tHome(),
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  //ListView element widget
}
