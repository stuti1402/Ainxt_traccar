import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatelessWidget {
  late GoogleMapController mapController;

  final MapType currentMapType;
  final LatLng center;
  final onMapTypeButtonPressed;
  final onTrafficEnabled;
  final bool trafficEnabled;
  GoogleMaps(
      {required this.onMapTypeButtonPressed,
      required this.currentMapType,
      required this.center,
      required this.onTrafficEnabled,
      required this.trafficEnabled,});

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Stack(children: [
      GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: currentMapType,
        trafficEnabled: trafficEnabled,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 11.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [
              Container(
                height: 30,
                width: 30,
                child: FloatingActionButton(
                  onPressed: onMapTypeButtonPressed,
  heroTag: "maplayer",
                  /*   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  
                  ),*/
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.map, size: 20.0),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 30,
                width: 30,
                child: FloatingActionButton(
                  onPressed: onTrafficEnabled,
heroTag: 'maptraffic',
                  /*   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  
                  ),*/
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.traffic_outlined,size: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
