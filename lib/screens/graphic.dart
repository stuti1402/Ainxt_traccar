import 'package:flutter/material.dart';

const d_grey = Color(0xFFEDECF2);

class GraphicPage extends StatefulWidget {
  const GraphicPage({Key? key}) : super(key: key);

  @override
  _GraphicPageState createState() => _GraphicPageState();
}

class _GraphicPageState extends State<GraphicPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      appBar: AppBar(
        title: Text(
          'Graphic',
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
