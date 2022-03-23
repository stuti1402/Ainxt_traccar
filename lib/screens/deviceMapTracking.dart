import 'dart:async';

import 'package:emka_gps/global/app_colors.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';


class DeviceMapTracking extends StatefulWidget {
  const DeviceMapTracking({Key? key}) : super(key: key);

  @override
  _DeviceMapTrackingState createState() => _DeviceMapTrackingState();
}

class _DeviceMapTrackingState extends State<DeviceMapTracking> {
  final Completer<GoogleMapController> _mapSuiviController = Completer();
  late bool isMapCreated = false;
  late GoogleMapController mcontroller;
  Language _language = Language();
  final arabicNumber = ArabicNumbers();

  void initState() {
    super.initState();
    setState(() {
      _language.getLanguage();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mcontroller = controller;

    _mapSuiviController.complete(controller);

    setState(() {
      isMapCreated = true;

      mcontroller = controller;
    });
    //controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
    // _initMarkers(_mlocations);
  }

  late AppProvider _appProvider;
  LatLng _mapCenter = LatLng(35, 9);
  setMapCenter(center) {
    _mapCenter = center;
    if (isMapCreated)
      mcontroller.animateCamera(CameraUpdate.newLatLng(_mapCenter));
  }
 getFuel(fs) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(fs.toInt())} " + _language.tLitre();
    else
      return fs.toString() + _language.tLitre();
  }
 getTotalDistance(td) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(td.toInt())} " + _language.tKm();
    else
      return td.toString() + _language.tKm();
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF149cf7),
        title: Text(
          _device!.name != null ? (_device!.name.toString()).toUpperCase() : '',
          style: TextStyle(color: Colors.white),
        ),
         leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Color(0xFF59C2FF),
      body: googleMapForDeviceTrackingUI(),
    );
  }

  late Device? _device =
      new Device(status: '', disabled: false, lastUpdate: '', position: null);
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
  getDevicePosition(Position pos, Device device) {
    // _device = _appProvider.getDeviceById(id);
    // _position = _appProvider.getPositionById(id);

    _device = device;
    _position = pos;
    // print('pospos${_position!.speed}');
    //print('deviceInfo${_device!.name}');
  }

  late bool devicePositionInitialise = false;
  Widget googleMapForDeviceTrackingUI() {
    // print('geoF::${_geofences[0].area}');
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Consumer<AppProvider>(builder: (consumerContext, model, child) {
      if (model.markersToSuivi != null) {
        if (devicePositionInitialise == false) {
          _appProvider.setSuiviDevicePosition(_appProvider.selectedId);
          devicePositionInitialise = true;
          print('initOK');
        }

        //_initMarkers(model.mapmarkers);
        // print("selectedDevice::${model.selectedId}");
        //  print('selectedDevice${model.selectedDevice.name}');
        //print('selectedDevice${model.selectedPosition.address}');
        setMapCenter(model.centerToSuivi);
        getDevicePosition(model.selectedPosition, model.selectedDevice);
        return Column(
          children: [
            //  Expanded(child: LeafletMap()),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GoogleMap(
                mapType: MapType.hybrid,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _mapCenter,
                  zoom: 18,
                ),
                markers: model.markersToSuivi,
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
                          Icon(
                            Icons.speed,
                            color: Colors.grey[350],
                          ),
                          if (_position!.attributes.rpm != null)
                            Row(
                              children: [
                                Text(
                                  (_position!.attributes.rpm)!
                                      .round()
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      color: AppColors.darkTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' tr/mn',
                                  style: TextStyle(
                                      color: Colors.grey[350],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          else
                            Text('--'),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.grey[350],
                          ),
                          if (_position!.speed != null)
                            Row(
                              children: [
                                Text(
                                  (_position!.speed * 1.852).round().toString(),
                                  style: GoogleFonts.poppins(
                                      color: AppColors.darkTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' km/h',
                                  style: TextStyle(
                                      color: Colors.grey[350],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          else
                            Text('--'),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.grey[350],
                          ),
                          if (_position!.attributes.coolantTemp != null)
                            Row(
                              children: [
                                Text(
                                  (_position!.attributes.coolantTemp)!
                                      .round()
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      color: AppColors.darkTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' °C',
                                  style: TextStyle(
                                      color: Colors.grey[350],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          else
                            Text('--'),
                        ],
                      ),
                    ),
                  ],
                )),

            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: FittedBox(
                child: Text(
                  _position!.address.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            /*   Container(
              child: ListTile(
                minLeadingWidth: 10,
                leading: Icon(
                  Icons.maps_home_work_outlined,
                  color: Colors.white,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        _position!.address.toString(),
                        overflow: TextOverflow.ellipsis, maxLines: 1,
                        //softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          */
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
    }));
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
      child: ListView(
        children: [
          ListTile(
            minLeadingWidth: 10,
            leading: Icon(
              Icons.update_rounded,
              color: Colors.white,
            ),
            title: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (_position!.fixTime != null && _position!.fixTime != '')
                      ? ((DateTime.parse(_position!.fixTime.toString()))
                              .add(new Duration(hours: 1))
                              .toString())
                          .substring(
                              0,
                              ((DateTime.parse(_position!.fixTime.toString()))
                                      .add(new Duration(hours: 1))
                                      .toString())
                                  .indexOf('.'))
                      : '--',
                  style: TextStyle(color: Colors.grey[100]),
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
              _language.tFuel().toString(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _position!.attributes.fuel != null
                      ?getFuel(_position!.attributes.fuel)
                      : '--',
                  style: TextStyle(color: Colors.grey[100]),
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
              _language.tIgnition(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _position!.attributes.ignition != null
                      ? _position!.attributes.ignition == false
                          ? _language.tNo()
                          : _language.tYes()
                      : '--',
                  style: TextStyle(color: Colors.grey[100]),
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
              _language.tDriver(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _language.tUnknown(),
                  style: TextStyle(color: Colors.grey[100]),
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
              _language.tTotalDistance(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _position!.attributes.totalDistance != null
                      ? getTotalDistance(((_position!.attributes.totalDistance)! / 1000).round())
                      : '--',
                  style: TextStyle(color: Colors.grey[100]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
