import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/connectivity_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:emka_gps/screens/google_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'no_internet.dart';

//class needs to extend StatefulWidget since we need to make changes to the bottom app bar according to the user clicks
class Home extends StatefulWidget {
  static const router = "/home";

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  Language _language = Language();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    Provider.of<AppProvider>(context, listen: false).initialization();
    setState(() => _language.getLanguage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: sideBar(),
        body: //GoogleMapPage()
        pageUI());
  }

  Widget checkloading() {
    return Consumer<AppProvider>(builder: (context, model, child) {
      if (model.getDevices().isEmpty && model.getPositionsList().isEmpty) {
        return loading();
      } else if (model.getDevices().isNotEmpty &&
          model.getPositionsList().isNotEmpty) {
        return GoogleMapPage();
      }

      return loading();
    });
  }

  Widget loading() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(255, 189, 89, 1),
                Color.fromRGBO(255, 145, 77, 1),
              ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingFour(
                color: Colors.white,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tDevicesLoading(),
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }

  Widget pageUI() {
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      return model.isOnline ? checkloading() : NoInternt();
    });
  }
}