import 'package:flutter/material.dart';

class DeviceAccessoires extends StatefulWidget {
  const DeviceAccessoires({Key? key}) : super(key: key);

  @override
  _DeviceAccessoiresState createState() => _DeviceAccessoiresState();
}

class _DeviceAccessoiresState extends State<DeviceAccessoires> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            title: Text(
              'Accessoires',
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
            centerTitle: true,
          ),
        ));
  }
}
