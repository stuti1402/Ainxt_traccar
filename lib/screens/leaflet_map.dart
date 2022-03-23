import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/leafletMap_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LeafletMap extends StatefulWidget {
  const LeafletMap({Key? key}) : super(key: key);

  @override
  _LeafletMapState createState() => _LeafletMapState();
}

class _LeafletMapState extends State<LeafletMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeafletMapCluster(),
    );
  }
}

class LeafletMapCluster extends StatefulWidget {
  const LeafletMapCluster({Key? key}) : super(key: key);

  @override
  _LeafletMapClusterState createState() => _LeafletMapClusterState();
}

class _LeafletMapClusterState extends State<LeafletMapCluster> {
  final PopupController _popupController = PopupController();
  late LeafRenderObjectWidget mapProvider;

  late List<Marker> markers;
  

  @override
  void initState() {
   

    super.initState();
    Provider.of<AppProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (consumerContext, model, child) {
      if (model.mapmarkersL != null) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              model.pointIndex++;
              if (model.pointIndex >= model.points.length) {
                model.pointIndex = 0;
              }
              setState(() {
                model.mapmarkersL[0] = Marker(
                  point: model.points[model.pointIndex],
                  anchorPos: AnchorPos.align(AnchorAlign.center),
                  height: 30,
                  width: 30,
                  builder: (ctx) => Icon(Icons.pin_drop),
                );
                markers = List.from(model.mapmarkersL);
              });
            },
            child: Icon(Icons.refresh),
          ),
          body: FlutterMap(
            options: MapOptions(
              center: model.points[0],
              zoom: 5,
              maxZoom: 15,
              plugins: [
                MarkerClusterPlugin(),
              ],
              //onTap: (_) => _popupController.hideAllPopups(), // Hide popup when the map is tapped.
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: model.mapmarkersL,
                polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                popupOptions: PopupOptions(
                    popupSnap: PopupSnap.markerTop,
                    popupController: _popupController,
                    popupBuilder: (_, marker) => Container(
                          width: 200,
                          height: 100,
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () => debugPrint('Popup tap!'),
                            child: Text(
                              'Container popup for marker at ${marker.point}',
                            ),
                          ),
                        )),
                builder: (context, markers) {
                  return FloatingActionButton(
                    onPressed: null,
                    child: Text(model.mapmarkersL.length.toString()),
                  );
                },
              ),
            ],
          ),
        );
      }
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
