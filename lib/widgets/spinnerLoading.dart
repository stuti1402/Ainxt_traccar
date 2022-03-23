import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingSpin extends StatefulWidget {
  const LoadingSpin({Key? key}) : super(key: key);

  @override
  _LoadingSpinState createState() => _LoadingSpinState();
}

class _LoadingSpinState extends State<LoadingSpin> {
  late AppProvider _appProvider;
  @override
  void initState() {
    super.initState();
    getSharedPrefrences().then((data) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Provider.of<AppProvider>(context, listen: false).getLoggedIn();

        //print(' isLogging ${Provider.of<AppProvider>(context, listen: false).getLoggedIn}');

        //  TraccarClientService(appProvider: _appProvider).getDevicePositionsStream();
      });
    });
  }

  Future getSharedPrefrences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print('rem::${sharedPreferences.getBool('rememberMe')}');
    //print('rem::${sharedPreferences.getBool('loggedIn')}');

    if (sharedPreferences.getBool('loggedIn') == true &&
        sharedPreferences.getBool('rememberMe') == true) {
      String username = sharedPreferences.getString('username')!;
      String password = sharedPreferences.getString('password')!;

      await TraccarClientService(appProvider: _appProvider).login(
          username: username,
          password: password,
          rememberMe: _appProvider.rememberMe,
          context: context);

      // Navigator.of(context).pushNamed('/home');
    } else {
      Navigator.of(context).pushNamed('/login');
    }

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SpinKitFadingFour(
              color: Colors.orange,
              size: 50.0,
            ),
          ),
        ));
  }
}
