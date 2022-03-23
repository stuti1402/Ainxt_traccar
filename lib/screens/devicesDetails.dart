import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const d_grey = Color(0xFFEDECF2);

class DevicesDetails extends StatefulWidget {
  final Device device;

  const DevicesDetails({Key? key, required this.device}) : super(key: key);

  @override
  _DevicesDetailsState createState() =>
      _DevicesDetailsState(deviceDetails: this.device);
}

class _DevicesDetailsState extends State<DevicesDetails> {
  late Device deviceDetails;
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  _DevicesDetailsState({required this.deviceDetails});
  //String get deviceDetails => deviceDetails;

  late AppProvider _appProvider;
  late Position _position;
  @override
  void didUpdateWidget(DevicesDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    setState(() => _language.getLanguage());
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _position = _appProvider.getPositionById(deviceDetails.id!);
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: AppBar(
              title: Text(
                _language.tDeviceDetails(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
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
                /*
            IconButton(
              onPressed: () {/*
                Navigator.of(context)
                    .pushNamed('/updateDevice', arguments: deviceDetails);*/
              },
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
            )*/
              ],
              centerTitle: true,
            ),
            backgroundColor: d_grey,
            body: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.car_rental,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tDeviceName()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              deviceDetails.name.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.gps_fixed,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tGpsProtocol()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.protocol.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.accessibility,
                          color: Colors.blue,
                        ),
                        title: Text("Imei"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              deviceDetails.uniqueId.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.phone_android_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tPhone()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              deviceDetails.phone.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.car_rental_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tStatus()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              deviceDetails.status == 'offline'
                                  ? _language.tOffline()
                                  : _language.tOnline(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.car_rental_rounded,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tMovment()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.motion == true
                                  ? _language.tMoving()
                                  : _language.tStopped(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.engineering_outlined,
                          color: Colors.blue,
                        ),
                        title: Text("ACC"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.ignition == true
                                  ? _language.tIgnitionOn()
                                  : _language.tIgnitionOff(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.satellite,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tSat()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.sat.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.engineering_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tTotalDistance()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.totalDistance.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.engineering_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tDistance()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.distance.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.map_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tEngineHours()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.attributes.hours.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.date_range_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tLastUpdate()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            lastupdate(deviceDetails.lastUpdate),
                          ],
                        ),
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.speed_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tSpeed()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (_position.speed * 1.852).round().toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tLng()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.longitude.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tLat()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.latitude.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                        title: Text(_language.tAlt()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _position.altitude.toString(),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      ListTile(
                        minLeadingWidth: 10,
                        leading: Icon(
                          Icons.maps_home_work_outlined,
                          color: Colors.blue,
                        ),
                        //title: Text(_language.tAdress()),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              //  width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                _position.address.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  lastupdate(String date) {
    DateTime newdate = DateTime.parse(date);
    final date2 = DateTime.now();
    final difference = date2.difference(newdate).inDays;
    var diff = calculTime(newdate, date2);
    return Text(diff.toString(), style: TextStyle(color: Colors.grey));
  }

  calculTime(DateTime from, DateTime to) {
    // from = DateTime(from.year, from.month, from.day);
    // to = DateTime(to.year, to.month, to.day);
    if (to.difference(from).inMinutes < 60)
      return "${(to.difference(from).inMinutes).round()} min";
    if (to.difference(from).inHours < 24)
      return "${(to.difference(from).inHours).round()} h";
    if (to.difference(from).inDays > 1)
      return "${(to.difference(from).inDays).round()} j";
  }
}