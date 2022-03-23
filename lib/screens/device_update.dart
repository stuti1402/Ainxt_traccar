import 'package:emka_gps/models/device.dart';
import 'package:flutter/material.dart';

class DeviceUpdate extends StatefulWidget {
  final Device device;
  const DeviceUpdate({required this.device, Key? key}) : super(key: key);

  @override
  _DeviceUpdateState createState() =>
      _DeviceUpdateState(deviceupdate: this.device);
}

class _DeviceUpdateState extends State<DeviceUpdate> {
  late Device deviceupdate;
  _DeviceUpdateState({required this.deviceupdate});

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      appBar: AppBar(
        title: Text(
          'Update',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF149cf7),
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
              // Navigator.of(context).pushNamed('/googleMap');
            },
            icon: Icon(
              Icons.verified_rounded,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: buildUpdateForm(),
    ));
  }

  buildUpdateForm() {
    return Container(
      child: Text(deviceupdate.name.toString()),
    );
  }
}
