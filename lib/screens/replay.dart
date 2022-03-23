import 'package:flutter/material.dart';

const d_grey = Color(0xFFEDECF2);

class ReplayPage extends StatefulWidget {
  const ReplayPage({Key? key}) : super(key: key);

  @override
  _ReplayPageState createState() => _ReplayPageState();
}

class _ReplayPageState extends State<ReplayPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      appBar: AppBar(
        title: Text(
          'Replay',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF149cf7),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
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
        centerTitle: true,
      ),
    ));
  }
}
