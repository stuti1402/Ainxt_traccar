import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/models/geoFence.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsState createState() =>
      _EventDetailsState(eventDetails: this.event);
}

class _EventDetailsState extends State<EventDetails> {
  late Event eventDetails;
  _EventDetailsState({required this.eventDetails});

  @override
  late AppProvider _appProvider;

  Language _language = Language();
  LatLng _mapCenter = LatLng(35, 9);
  final Completer<GoogleMapController> _mapSuiviController = Completer();
  late bool isMapCreated = false;
  late GoogleMapController mcontroller;
  late bool geoDrawed = false;
  late Set<Polygon> polygonSet = new Set();
  late List<LatLng> polygonCoords = [];
  late Set<Circle> cirlcesSet = new Set();
  List<GeoFence> _geofences = [];
  final arabicNumber = ArabicNumbers();

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
      circleColor = Color(0x7FFFFFFF);
    else
      circleColor = Color(int.parse(color.replaceAll('#', '0x7F')));

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
      polyColor = Color(0x7FFFFFFF);
    else
      polyColor = Color(int.parse(color.replaceAll('#', '0x7F')));
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

  void _onMapCreated(GoogleMapController controller) {
    mcontroller = controller;

    // _mapSuiviController.complete(controller);

    setState(() {
      isMapCreated = true;

      mcontroller = controller;
    });
  }

  getActualtotalDistanceOrWorkingHours(deviceId, type) {
    if (type == 'hours') {
      int totalWorkigHours =
      _appProvider.getDeviceTotalWorkingHoursById(deviceId)!;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(((totalWorkigHours / 1000) / 3600).round())} " +
            _language.tHours();
      else
        return ((totalWorkigHours / 1000) / 3600).round().toString() +
            _language.tHours();
    } else {
      double totalDis = _appProvider.getDeviceTotalDistanceById(deviceId)!;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((totalDis / 1000).round())} " +
            _language.tKm();
      else
        return (totalDis / 1000).round().toString() + _language.tKm();
    }
  }

  getNextMaintenance(int start, int period, type) {
    int nextMaintenance = start + period;

    if (type == 'hours') {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((nextMaintenance / 3600).round())} " +
            _language.tHours();
      else
        return (nextMaintenance / 3600).round().toString() + _language.tHours();
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((nextMaintenance).round())} " +
            _language.tKm();
      else
        return (nextMaintenance).round().toString() + _language.tKm();
    }
  }

  translateLastVidangePeriod(int lv, type) {
    if (type == 'hours') {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((lv / 3600).toInt())} " +
            _language.tHours();
      else
        return (lv / 3600).toInt().toString() + _language.tHours();
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(lv)} " + _language.tKm();
      else
        return lv.toString() + _language.tKm();
    }
  }

  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    // _appProvider.setEventMarker(eventDetails.deviceId);

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            backgroundColor: Colors.orange,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  // Navigator.pop(context);
                  Navigator.of(context).pushNamed('/alerte');
                }),
              ),
              title:
              Text(_appProvider.getDeviceNameById(eventDetails.deviceId)),
              backgroundColor: Colors.orange,
              //centerTitle: true,
            ),
            body: googleMapForDeviceTrackingUI()));
  }

  Widget googleMapForDeviceTrackingUI() {
    _geofences = _appProvider.getGeoFences();

    drawGeoFencesOnMap(_geofences);
    return Consumer<AppProvider>(builder: (consumerContext, model, child) {
      if (model.stopsMarkers != null) {
        //  setMapCenter(model.centerFirstStop);

        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GoogleMap(
                mapType: MapType.hybrid,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                polygons: polygonSet,
                circles: cirlcesSet,
                initialCameraPosition: CameraPosition(
                  target: model.eventMapCenter,
                  zoom: 15,
                ),
                markers: model.eventMarker,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FittedBox(
                        alignment: Alignment.center,
                        child: Text(
                          getEventType(eventDetails.type.toString()),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        )),
                    //  Container(child: Text(getEventType(eventDetails.type.toString())),)
                  ],
                )),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: FittedBox(
                  child: Text(
                    model.selectedEventPosition.address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )),
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
                color: Colors.orange,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoading(),
                style: TextStyle(color: Colors.orange),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoadingMoreTime(),
                style: TextStyle(color: Colors.orange),
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
                Color.fromRGBO(255, 189, 89, 1),
                Color.fromRGBO(255, 145, 77, 1),

                //Color(0xFF1270E3),
                //Color(0xFF59C2FF),
              ])),
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: eventDetails != null
          ? ListView(
        children: [
          ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.access_alarm_sharp,
                color: Colors.white,
              ),
              title: Text(
                _language.tNotifTime(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                eventDetails.serverTime.toString().substring(
                    eventDetails.serverTime.toString().indexOf('T') + 1,
                    eventDetails.serverTime.toString().indexOf('.')),
                style: TextStyle(color: Colors.grey[100]),
              )),
          eventDetails.geofenceId != 0
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tGeoFenceName(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                _appProvider
                    .getGeoFenceById(eventDetails.geofenceId)
                    .name
                    .toString(),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.type == "deviceOverspeed"
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tSpeedLimitNotif(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                ((_appProvider
                    .getDeviceById(eventDetails.deviceId)
                    .attributes!
                    .speedLimit)! *
                    1.852)
                    .toString(),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.type == "deviceOverspeed"
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tSpeed(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                ((_appProvider
                    .getPositionByPosId(eventDetails.deviceId)
                    .speed) *
                    1.852)
                    .toString(),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.type == "deviceFuelDrop"
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tDeviceFuelDrop(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                ((_appProvider
                    .getDeviceById(eventDetails.deviceId)
                    .attributes!
                    .fuelDropThreshold)! +
                    _language.tLitre())
                    .toString(),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.geofenceId != 0
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tGeoFenceDescription(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                _appProvider
                    .getGeoFenceById(eventDetails.geofenceId)
                    .description
                    .toString(),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.maintenanceId != 0
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tMaintenanceName(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                _appProvider
                    .getMaintenanceById(eventDetails.maintenanceId)
                    .name,
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.maintenanceId != 0
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tLastVidange(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                (translateLastVidangePeriod(
                    ((_appProvider
                        .getMaintenanceById(
                        eventDetails.maintenanceId)
                        .start) /
                        1000)
                        .toInt(),
                    _appProvider
                        .getMaintenanceById(
                        eventDetails.maintenanceId)
                        .type)),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.maintenanceId != 0
              ? ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              title: Text(
                _language.tPeriod(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Text(
                (translateLastVidangePeriod(
                    ((_appProvider
                        .getMaintenanceById(
                        eventDetails.maintenanceId)
                        .period) /
                        1000)
                        .toInt(),
                    _appProvider
                        .getMaintenanceById(
                        eventDetails.maintenanceId)
                        .type)),
                style: TextStyle(color: Colors.grey[100]),
              ))
              : SizedBox(),
          eventDetails.maintenanceId != 0
              ? ListTile(
            minLeadingWidth: 10,
            leading: Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
            title: Text(_language.tNextVidange(),
                style:
                TextStyle(color: Colors.white, fontSize: 16)),
            trailing: Text(
              getNextMaintenance(
                  ((_appProvider
                      .getMaintenanceById(
                      eventDetails.maintenanceId)
                      .period) /
                      1000)
                      .toInt(),
                  ((_appProvider
                      .getMaintenanceById(
                      eventDetails.maintenanceId)
                      .start) /
                      1000)
                      .toInt(),
                  _appProvider
                      .getMaintenanceById(
                      eventDetails.maintenanceId)
                      .type),
              style: TextStyle(color: Colors.grey[100]),
            ),
          )
              : SizedBox(),
          eventDetails.maintenanceId != 0
              ? ListTile(
            minLeadingWidth: 10,
            leading: Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
            title: Text(
                eventDetails.type == 'hours'
                    ? _language.tCraneHours()
                    : _language.tTotalDistance(),
                style:
                TextStyle(color: Colors.white, fontSize: 16)),
            trailing: Text(
              getActualtotalDistanceOrWorkingHours(
                  eventDetails.deviceId,
                  _appProvider.getMaintenanceById(
                      eventDetails.maintenanceId)),
              style: TextStyle(color: Colors.grey[100]),
            ),
          )
              : SizedBox(),
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

  getEventType(String type) {
    switch (type) {
      case 'deviceOnline':
        return _language.tOnline();
      case 'deviceOffline':
        return _language.tOffline();
      case 'deviceUnknown':
        return _language.tDeviceUnknown();
      case 'deviceInactive':
        return _language.tDeviceInactive();
      case 'deviceMoving':
        return _language.tMoving();

      case 'deviceStopped':
        return _language.tStopped();
      case 'deviceOverspeed':
        return _language.tDeviceOverSpeed();
      case 'deviceFuelDrop':
        return _language.tDeviceFuelDrop();
      case 'geofenceEnter':
        return _language.tGeoFenceEnter();
      case 'geofenceExit':
        return _language.tGeoFenceExit();

      case 'ignitionOn':
        return _language.tIgnitionOn();
      case 'ignitionOff':
        return _language.tIgnitionOn();
      case 'maintenance':
        return _language.tMaintenance();

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return 'inconnu';
    }
  }
}