import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/position.dart';
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

class TodayTrip extends StatefulWidget {
  const TodayTrip({Key? key}) : super(key: key);

  @override
  _TodayTripState createState() => _TodayTripState();
}

class _TodayTripState extends State<TodayTrip> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Position> _todayTrip = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  late bool refreshed = false;
  LatLngBounds _latLngBounds =
      LatLngBounds(southwest: LatLng(35, 9), northeast: LatLng(35, 10));
  late bool isLoading = false;

  late Set<Polyline> polylineSet = new Set();

  @override
  void initState() {
    super.initState();
    isFitbounds = false;
    isLoading = false;
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(TodayTrip oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    _todayTrip = [];
    await _getTodayTrip().then((value) => _todayTrip =value);
    isLoading = true;
    if (isLoading == true) {
      _appProvider.setTodayTrip(_todayTrip);
      _appProvider.setTodayTripPolyline(_todayTrip);
    }

    _refreshController.refreshCompleted();
    refreshed = true;

    if (mounted) {
      setState(() {});
    }
  }

  late bool isFitbounds = false;

  _getTodayTrip() async {
    print('todayTripLoadedbegin');

    var todayFrom = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 01);

    var todayTo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    String formattedDateFrom =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayFrom);

    String formattedDateTo = DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayTo);
    String from = formattedDateFrom + '.000Z';
    String to = formattedDateTo + '.000Z';

   await TraccarClientService(appProvider: _appProvider)
        .getTodayTrip(from: from, to: to).then((value) => _todayTrip =value);

    print('todayTripLoadedend');
  return _todayTrip;
  }

  LatLng _mapCenter = LatLng(35, 9);

  setMapCenter(center) {
    if (center != _mapCenter) {
      _mapCenter = center;
      if (isMapCreated)
        mcontroller.animateCamera(CameraUpdate.newLatLng(_mapCenter));
    }
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

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _todayTrip = _appProvider.getTodayTrip();
    if (refreshed == false && isLoading == false) _onRefresh();
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
      body: isLoading == true
          ? googleMapForDeviceTrackingUI(_todayTrip)
          : loading(),
    ));
  }

  nextTripMarker() {
    print('posposindex:$_posIndex');

    if (_posIndex == 0) {
      LatLng triplatlng =
          LatLng(_todayTrip[0].latitude, _todayTrip[0].longitude);
      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(triplatlng, 18));
      mcontroller.showMarkerInfoWindow(MarkerId((_todayTrip[0].id.toString())));
      _posIndex = _todayTrip.length - 1;
    } else if (_posIndex == _todayTrip.length - 1) {
      LatLng triplatlng = LatLng(_todayTrip[_todayTrip.length - 1].latitude,
          _todayTrip[_todayTrip.length - 1].longitude);
      mcontroller.animateCamera(CameraUpdate.newLatLngZoom(triplatlng, 18));
      mcontroller.showMarkerInfoWindow(
          MarkerId((_todayTrip[_todayTrip.length - 1].id.toString())));

      _posIndex = 0;
    }
  }

  getDistance(tdis0, tdis1) {
    int distance = ((tdis1 - tdis0) / 1000).toInt();
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(distance.toInt())} " + _language.tKm();
    else
      return distance.toString() + _language.tKm();
  }

  Widget googleMapForDeviceTrackingUI(item) {
    return Consumer<AppProvider>(builder: (consumerContext, model, child) {
      if (model.stopsMarkers != null) {
        setMapCenter(model.centerTodayTrip);
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: GoogleMap(
                mapType: MapType.hybrid,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _mapCenter,
                  zoom: 7,
                ),
                markers: model.markerStartEndTrips,
                polylines: model.polylineSet,
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
                height: MediaQuery.of(context).size.height * 0.08,
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
                                  CameraUpdate.newLatLng(_mapCenter));
                              mcontroller.animateCamera(
                                  CameraUpdate.newLatLngZoom(_mapCenter, 7));
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
                            _language.tTodayTrip(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
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
                              if (_todayTrip.length != 0) nextTripMarker();
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
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: FittedBox(
                  child: (_todayTrip.length != 0 &&
                          isLoading == true &&
                          refreshed == true)
                      ? Text(
                          getDistance(
                              _todayTrip[0].attributes.totalDistance,
                              _todayTrip[_todayTrip.length - 1]
                                  .attributes
                                  .totalDistance),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        )
                      : Text(
                          _language.tNoTodayTrip(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                ),
              ),
            ),

            //  Expanded(child: deviceDash())
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

  //ListView element widget
}
