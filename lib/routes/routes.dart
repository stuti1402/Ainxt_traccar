
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/screens/Reports/generalReport.dart';
import 'package:emka_gps/screens/alertes.dart';
import 'package:emka_gps/screens/deviceAccessoires.dart';
import 'package:emka_gps/screens/deviceMapTracking.dart';
import 'package:emka_gps/screens/devicePaper.dart';
import 'package:emka_gps/screens/device_update.dart';
import 'package:emka_gps/screens/devicesDetails.dart';
import 'package:emka_gps/screens/devicesReDesign.dart';
import 'package:emka_gps/screens/event_details.dart';
import 'package:emka_gps/screens/formLogin_screen.dart';
import 'package:emka_gps/screens/google_map_page.dart';
import 'package:emka_gps/screens/home_screen.dart';
import 'package:emka_gps/screens/mainScreen.dart';
import 'package:emka_gps/screens/maintenance.dart';
import 'package:emka_gps/screens/settings.dart';
import 'package:emka_gps/screens/stopsScreen.dart';
import 'package:emka_gps/screens/todayTrip.dart';
import 'package:emka_gps/widgets/spinnerLoading.dart';
import 'package:flutter/material.dart';

import 'package:emka_gps/screens/consommation.dart';
import 'package:emka_gps/screens/devices.dart';
import 'package:emka_gps/screens/driver.dart';
import 'package:emka_gps/screens/graphic.dart';
import 'package:emka_gps/screens/replay.dart';
import 'package:emka_gps/screens/report.dart';

class routeGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    final args = setting.arguments;
    switch (setting.name) {
       case '/loadingSpin':
        return MaterialPageRoute(builder: (_) => LoadingSpin());
         case '/mainScreen':
        return MaterialPageRoute(builder: (_) => NotifTestScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginFormValidation());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/devices':
        return MaterialPageRoute(builder: (_) => DevicesPage());
        case '/devicesReDes':
        return MaterialPageRoute(builder: (_) => DevicesRedesignPage());
      case '/driver':
        return MaterialPageRoute(builder: (_) => DriverPage());
      case '/googleMap':
        return MaterialPageRoute(builder: (_) => GoogleMapPage());
      case '/replay':
        return MaterialPageRoute(builder: (_) => ReplayPage());
      case '/graphic':
        return MaterialPageRoute(builder: (_) => GraphicPage());
      case '/consommation':
        return MaterialPageRoute(builder: (_) => ConsomPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/maintenance':
        return MaterialPageRoute(builder: (_) => Maintenance());
        case '/devicePaper':
        return MaterialPageRoute(builder: (_) => DevicePaper());
      case '/alerte':
        return MaterialPageRoute(builder: (_) => Alerte());
      case '/eventDetails':
       if (args is Event) {
          return MaterialPageRoute(
              builder: (_) => EventDetails(
                event: args,
                  ));
        }
        return _errorRoute();
         case '/deviceMapTracking':
        return MaterialPageRoute(builder: (_) => DeviceMapTracking());
         case '/deviceMapStops':
        return MaterialPageRoute(builder: (_) => StopsScreen());
         case '/generalReport':
        return MaterialPageRoute(builder: (_) => GeneralReport());
         case '/todayTrip':
        return MaterialPageRoute(builder: (_) => TodayTrip());
         case '/deviceAccessoires':
        return MaterialPageRoute(builder: (_) => DeviceAccessoires());
      case '/updateDevice':
        if (args is Device) {
          return MaterialPageRoute(
              builder: (_) => DeviceUpdate(
                    device: args,
                  ));
        }
        return _errorRoute();

      case '/report':
        return MaterialPageRoute(builder: (_) => ReportPage());

      case '/devicesDetails':
        if (args is Device) {
          // print('devicessss:::${args.name}');
          return MaterialPageRoute(
              builder: (_) => DevicesDetails(
                    device: args,
                  ));
        }
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

var routes = <String, WidgetBuilder>{
  '/login': (context) => LoginFormValidation(),
  '/home': (context) => Home(),
  '/devices': (context) => DevicesPage(),
  '/graphic': (context) => GraphicPage(),
  '/consommation': (context) => ConsomPage(),
  '/driver': (context) => DriverPage(),
  '/report': (context) => ReportPage(),
  '/replay': (context) => ReplayPage(),
  '/googleMap': (context) => GoogleMapPage(),
// '/devicesDetails': (context) => DevicesDetails()
};
