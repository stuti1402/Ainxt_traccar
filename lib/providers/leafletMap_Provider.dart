import 'dart:typed_data';

import 'package:emka_gps/api/api_services.dart';

import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui' as ui;

class LeafletMapProvider with ChangeNotifier {
  //late String _apiCookie = "";
  late bool rememberMe;
  List<Position> _positions = [];

  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Markers loading flag
  bool _areMarkersLoading = true;
  // late List<LatLng> _markerLocations;
  //List<LatLng> get markerLocations => _markerLocations;
  final Color _clusterColor = Colors.blue;
  late List<Marker> _mapmarkersL = [];
  List<Marker> get mapmarkers => _mapmarkersL;
 List points = [
    LatLng(35.5, 9.709),
    LatLng(35.8566, 9.8522),
  ];
    late int pointIndex;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  LeafletMapProvider() {
    //_location = new Location();
    //_markers = <MarkerId, Marker>{};
    // _markerLocations = <LatLng>[];
    _mapmarkersL = <Marker>[];
  }

  //loggedIn Updates
  Future setLoggedIn({required bool status}) async {
    // isLoggedIn = status;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool('kIsloggedInKey', status);
  }

  Future getLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print(
        'the preference value ${sharedPreferences.getBool('kIsloggedInKey')}');
    //isLoggedIn = sharedPreferences.getBool('kIsloggedInKey') ?? isLoggedIn;
    //return Future.value(isLoggedIn);
  }

  //User states
  setUser({required User user}) {
    user = user;
  }

  //Active Tabs//

  //Devices

  setPosition({required Position position}) {
    _positions.add(position);
    notifyListeners();
  }

  replacePosition({required Position position, required int index}) {
    //  print('${_positions[index].id} changed to ${position.id}');
    _positions[index] = position;
    print("change in ${position.deviceId}");
    //_markers.clear();
    // _markerLocations.clear();
    // _markerLocations = [];
    _mapmarkersL = [];
    for (var e in _positions) {
      // print('${e.deviceId}:: ${e.id}');
      notifyListeners();
      // _markerLocations.add(LatLng(e.latitude, e.longitude));
      notifyListeners();
      _mapmarkersL.add(Marker(anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: points[pointIndex],
        builder: (ctx) => Icon(Icons.pin_drop),));
      /*
      _mapmarkers.add(MapMarker(
          id: e.deviceId.toString(),
          position: LatLng(
            e.latitude,
            e.longitude,
          ),
          icon: getIcon(e.attributes.motion!),
          infowindow: InfoWindow(title: 'device name', snippet: ' details'),
          rotation: (e.course!)));
      Marker newmarker = Marker(
        markerId: MarkerId(e.deviceId.toString()),
        position: LatLng(
          e.latitude,
          e.longitude,
        ),
        rotation: (e.course!),

        icon: getIcon(e.attributes.motion!),
        infoWindow: InfoWindow(title: 'device name', snippet: ' details'),
        onTap: () {
          print('Marker clicked');
        },
        //icon:BitmapDescriptor.fromBytes(markerIcon),
        draggable: false,
      );*/
      // _markers[MarkerId(e.deviceId.toString())] = newmarker;
      notifyListeners();
    }
    // print('listlist:: $_markerLocations');
  }

  //////////////////////////
  ///
  initialization() async {
    // await getUserLocation();
    //// await setCustomMapPin();
    // TraccarClientService(appProvider: this).getDevicePositionsStream;
  }

/*
  getIcon(bool motion) {
    if (motion == true)
      return pinLocationIcon;
    else
      return BitmapDescriptor.defaultMarkerWithHue((BitmapDescriptor.hueRed));
  }
*/

}
