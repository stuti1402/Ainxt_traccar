import 'dart:io';

import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/connectivity_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:emka_gps/providers/leafletMap_Provider.dart';
import 'package:emka_gps/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/notifcationService.dart';
import 'screens/formLogin_screen.dart';

late String? language = 'EN';
void main() {
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences.getInstance().then((instance) {
    language = instance.getString('language');
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    runApp(MyApp());
    HttpOverrides.global = MyHttpOverrides();
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Language(),
          child: LoginFormValidation(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppProvider(),
          child: LoginFormValidation(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: LoginFormValidation(),
        ),
        ChangeNotifierProvider(
          create: (context) => LeafletMapProvider(),
          child: LoginFormValidation(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI_Nxt',
        theme: ThemeData(
          // This is the theme of your application.
          // Try running your application with "flutter run". You'll see th
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepOrange,
        ),
        //initialRoute: '/googleMap',
        initialRoute: '/loadingSpin',
        //   initialRoute: Provider.of<SessionProvider>(context, listen: false).loading ? '/home' : '/',
        onGenerateRoute: routeGenerator.generateRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
