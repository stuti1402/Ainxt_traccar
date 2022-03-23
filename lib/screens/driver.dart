import 'package:flutter/material.dart';

const d_grey = Color(0xFFEDECF2);

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            title: Text(
              'Owners', //'Drivers',
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
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
                icon: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              )
            ],
            //centerTitle: true,
          ),
        ));
  }
}