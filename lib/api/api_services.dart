import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:emka_gps/api/notifcationService.dart';
import 'package:emka_gps/models/chart.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/models/geoFence.dart';
import 'package:emka_gps/models/maintenance.dart';
import 'package:emka_gps/models/stops.dart';
import 'package:emka_gps/models/summary.dart';
import 'package:emka_gps/models/trips.dart';
import 'package:emka_gps/models/user.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
//import 'package:flutter_tracking_app/models/device.custom.dart';
//import 'package:flutter_tracking_app/models/user.model.dart';
//import 'package:flutter_tracking_app/providers/app_provider.dart';
//import 'package:flutter_tracking_app/traccar_client/src/models/position.dart';
//import 'package:flutter_tracking_app/utilities/constants.dart';
//import 'package:geopoint/src/models/geopoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

//import 'package:device/device.dart';
import '../../config/config.dart';
import '../config/config.dart';
import '../models/device.dart';
import '../models/position.dart';
//import '../traccar_client/traccar_client.dart';

class TraccarClientService {
  final AppProvider appProvider;
  final _dio = Dio();

  late Device device;
  late Position position;
  late Event event;
  TraccarClientService({required this.appProvider});
  /*
   * @description Login Api
   */

  Future login(
  {required String username,
  required String password,
  rememberMe,
  required,
  required BuildContext context}) async {
var url = serverProtocol + serverUrl + '/api/session';
var payLoad = Map<String, dynamic>();
payLoad['email'] = username;
payLoad['password'] = password;
print(jsonEncode(payLoad));
print("URL " + url);

var response = await http.post(
Uri.parse(
'https://demo.traccar.org/api/session',
//'https://tracking.emkatech.tn/api/session',
),
body: ({'email': username, 'password': password}),
headers: {
HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
},
);

if (response.statusCode == 200) {
await Provider.of<AppProvider>(context, listen: false)
    .setLoggedIn(status: true);

// print("this is my cookies ${response.headers["set-cookie"]![0]}");
String cookie = response.headers["set-cookie"]!;
print("cookie $cookie");

User data =
User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
SharedPreferences sharedPreferences =
await SharedPreferences.getInstance();
appProvider.rememberMe = rememberMe;
sharedPreferences.setString('kCookieKey', cookie);
sharedPreferences.setString('username', username);
sharedPreferences.setString('password', password);
sharedPreferences.setBool('rememberMe', rememberMe);
sharedPreferences.setBool('loggedIn', true);
appProvider.setCookie(apiCookie: cookie);
// Provider.of<AppProvider>(context, listen: false).rememberMe = rememberMe;
print('remember::$rememberMe');
Provider.of<AppProvider>(context, listen: false)
    .setLoggedIn(status: true);
Provider.of<AppProvider>(context, listen: false)
    .setResLoggedIn(res: true);
print("data $data");
/*
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Succefull")));
*/
Navigator.popAndPushNamed(context, '/home');
return data;
} else if (response.statusCode == 401) {
print('formerrorApi401');
Provider.of<AppProvider>(context, listen: false)
    .setResLoggedIn(res: true);
ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text('Not Allowed !!')));
//return jsonDecode(response.body);
}
}

Future closeSession(
    {required String? username,
      required String? password,
      BuildContext? context}) async {
  var url = serverProtocol + serverUrl + '/api/session';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  var response = await _dio.delete(url,
      options: Options(
        headers: {'authorization': basicAuth},
        contentType: "application/x-www-form-urlencoded",
        /*headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },*/
      ));
  if (response.statusCode == 204) {
    print('sessionClosed');
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    sharedPreferences.remove('username');
    sharedPreferences.remove('password');
    sharedPreferences.remove('kCookieKey');
    sharedPreferences.clear();

    Navigator.of(context!).pushNamed('/login');
    Provider.of<AppProvider>(context, listen: false)
        .setLoggedIn(status: false);
    Provider.of<AppProvider>(context, listen: false).setPositions([]);
    Provider.of<AppProvider>(context, listen: false).setDevices([]);
    Provider.of<AppProvider>(context, listen: false).setGeoFences([]);
    Provider.of<AppProvider>(context, listen: false).clearMarkerss();
    Provider.of<AppProvider>(context, listen: false)
        .setResLoggedOut(res: false);
    sharedPreferences.setBool('loggedIn', false);
    Provider.of<AppProvider>(context, listen: false)
        .setLoggedIn(status: false);
  }
}

// Logout //
logout({required BuildContext context}) async {
  appProvider.setLoggedIn(status: false);
  if (appProvider.rememberMe == false) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  prefs?.clear();
  }
  Navigator.popAndPushNamed(context, '/Login');
}

/*
   * @description Listen device-positions Stream emmitting by Websocket
   */

Future<Stream> get getDevicePositionsStream async {
  // String cookie = appProvider.getCookie();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? cookie = sharedPreferences.getString('kCookieKey');
  print('cookie1 $cookie');
  print('appapp::${appProvider.isLoggedIn}');

  final streamController = StreamController<dynamic>.broadcast();
  final channel = IOWebSocketChannel.connect("wss://$serverUrl/api/socket",
      headers: {"Cookie": cookie});
  final posStream = channel.stream;
  late StreamSubscription raw;

  raw = posStream.listen((dynamic data) {
    final dataMap = jsonDecode(data.toString()) as Map<String, dynamic>;
    if (appProvider.isLoggedIn) {
      if (dataMap.containsKey('devices')) {
        print('socketRESdevices::');

        for (var d in dataMap['devices']) {
          device = Device.fromJson(d);
          /*
            NotificationService().showNotification(
                device.id!, device.name.toString().toUpperCase(),"PositionId:"+device.positionId.toString(), 10);
       */
        }

        streamController.sink.add(device);
      }
      if (dataMap.containsKey('events')) {
        print('socketRESevents::');

        for (var d in dataMap['events']) {
          event = Event.fromJson(d);
          String deviceName = appProvider.getDeviceNameById(event.deviceId);
          String notifType = '';
          print('socketRESevents::${event.type}');

          switch (event.type.toString()) {
            case 'geofenceEnter':
              notifType = '';
              NotificationService().showNotification(
                  event.id, deviceName, "Entering the Virtual Perimeter", 10);
              return;

            case 'geofenceExit':
              notifType = '';

              NotificationService().showNotification(
                  event.id, deviceName, "Exiting the Virtual Perimeter", 10);
              return;
            case 'deviceOverspeed':
              NotificationService().showNotification(
                  event.id, deviceName, "Speed Limit Exceeded", 10);
              return;
            case 'deviceFuelDrop':
              NotificationService()
                  .showNotification(event.id, deviceName, "Fuel Loss", 10);
              return;
            case 'maintenance':
              NotificationService().showNotification(
                  event.id, deviceName, "Maintenance Required", 10);
              return;

            default:
            // If there is no such named route in the switch statement, e.g. /third
              return;
          }
        }

        streamController.sink.add(event);
      }
      if (dataMap.containsKey('positions')) {
        print('socketRESpositions::');

        for (var p in dataMap['positions']) {
          position = Position.fromJson(p);
          print('deviceID ${position.deviceId}');
          isPositionExist(position);

/*
          if( ! (appProvider.positions).contains(position) )
          appProvider.setPosition(position: position);
          else{
            final index = appProvider.positions.indexOf()
            
          }
*/

        }

        streamController.sink.add(position);
      }
    } else {
      channel.sink.close();
      print('channelClosed1');
    }
  });
  return streamController.stream;

  /* StreamSubscription<dynamic> rawPosSub;
    final streamController = StreamController<Device>.broadcast();
    rawPosSub = posStream.listen((dynamic data) {
      final dataMap = jsonDecode(data.toString()) as Map<String, dynamic>;
      print('socket $dataMap');
      if (dataMap.containsKey("positions")) {
        //DevicePosition pos;
        Device device;
        for (final posMap in dataMap["positions"]) {
          //  pos = DevicePosition.fromJson(posMap as Map<String, dynamic>);
          //device = Device.fromPosition(posMap as Map<String, dynamic>);
          device = Device.fromJson(posMap);
        }
        //  device.position = pos as GeoPoint ;
        // streamController.sink.add(device);
      }
    });
    return streamController.stream;*/
}

// Get All Devices of current User //
Future<List<Device>> getDevices() async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/devices";
  var response = await Dio().get(
    uri,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );

  if (response.statusCode == 200) {
    final devices = <Device>[];
    String devicesIds = '';
    int index = 0;
    for (final data in response.data) {
      var item = Device.fromJson(data as Map<String, dynamic>);
      devices.add(item);

      devicesIds += 'deviceId=' + item.id.toString() + '&';
    }
    String result = devicesIds.substring(0, devicesIds.length - 1);
    appProvider.setDevices(devices);
    print('devicesIds::$result');
    appProvider.setDevicesIds(result);
    return devices;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<GeoFence>> getGeoFences() async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/geofences";
  var response = await Dio().get(
    uri,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );

  if (response.statusCode == 200) {
    final geofence = <GeoFence>[];
    for (final data in response.data) {
      var item = GeoFence.fromJson(data as Map<String, dynamic>);
      geofence.add(item);
    }
    appProvider.setGeoFences(geofence);
    return geofence;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<Position> getPositionInfo({required int positionId}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/positions";
  final queryParameters = <String, dynamic>{"id": positionId};
  var response = await Dio().get(
    uri,
    queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    Position position = Position.fromJson(response.data[0]);
    print('positionPos::${response.data[0]}');
    return position;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

// Get All Devices of current User //
Future<List<Device>> getDeviceLatestPositions() async {
  String cookie = await getCookie();
  print('cookie $Cookie');

  String uri = "$serverProtocol$serverUrl/api/positions";
  var response = await Dio().get(
    uri,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    final devices = <Device>[];
    for (final data in response.data) {
      var item = Device.fromJson(data as Map<String, dynamic>);
      devices.add(item);
    }
    return devices;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

// Get Api Cookie //
static Future<String> getCookie() async {
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
String? cookie = sharedPreferences.getString('kCookieKey');
if (cookie == null) {
//  final trac = await getTraccarInstance();
// cookie = trac.query.cookie;
sharedPreferences.setString('kCookieKey', cookie!);
}
return cookie;
}

isPositionExist(Position position) {
  final data = appProvider.getPositions
      .indexWhere((row) => row.deviceId == position.deviceId);
  //print("data $data");
  if (data >= 0) {
    //    print("changed ");
    appProvider.replacePosition(index: data, position: position);
//      return true;
  } else {
    //    return false;
    appProvider.addPosition(position: position);
  }
}

/*
   * @description Get Traccar Instance
   */
/*
  static Future<Traccar> getTraccarInstance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userToken = sharedPreferences.getString(kTokenKey);
    final trac =
        Traccar(serverUrl: serverUrl, userToken: userToken, verbose: true);
    unawaited(trac.init());
    await trac.onReady;
    return trac;
  }
*/
/*
   * @description Get Device Routes
   */
Future<List<Device>> getDeviceRoutes(
    {required Device deviceInfo,
      required DateTime date,
      required Duration since}) async {
  String cookie = await getCookie();
  List<Device> _devicePositions = [];
  String uri = "$serverProtocol$serverUrl/api/reports/route";
  final deviceId = deviceInfo.id.toString();
  //date ??= DateTime.now();
  final fromDate = date.subtract(since);
  final queryParameters = <String, dynamic>{
    "deviceId": int.parse("$deviceId"),
    "from": _formatDate(fromDate),
    "to": _formatDate(date),
  };
  var response = await _dio.get(
    uri,
    queryParameters: queryParameters,
    options:
    Options(contentType: "application/json", headers: <String, dynamic>{
      "Accept": "application/json",
      "Cookie": cookie,
    }),
  );
  for (final data in response.data) {
    _devicePositions.add(Device.fromJson(data));
  }
  return _devicePositions;
}

// @description date conversion //
String _formatDate(DateTime date) {
  final d = date.toIso8601String().split(".")[0];
  final l = d.split(":");
  return "${l[0]}:${l[1]}:00Z";
}

// @description Get SinglePosition
static Future<Device> getPositionFromId({required int positionId}) async {
String cookie = await getCookie();
String uri = "$serverProtocol$serverUrl/api/positions";
final queryParameters = <String, dynamic>{"id": positionId};
var response = await Dio().get(
uri,
queryParameters: queryParameters,
options: Options(
contentType: "application/json",
headers: <String, dynamic>{
"Accept": "application/json",
"Content-Type": "application/json",
"Cookie": cookie,
},
),
);
if (response.statusCode == 200) {
Device devicePosition = Device.fromJson(response.data[0]);
return devicePosition;
} else {
throw Exception("Unexpected Happened !");
}
}

// @description Get Single Device Info
static Future<Device> getDeviceInfo({required int deviceId}) async {
String cookie = await getCookie();
String uri = "$serverProtocol$serverUrl/api/devices";
final queryParameters = <String, dynamic>{"id": deviceId};
var response = await Dio().get(
uri,
queryParameters: queryParameters,
options: Options(
contentType: "application/json",
headers: <String, dynamic>{
"Accept": "application/json",
"Content-Type": "application/json",
"Cookie": cookie,
},
),
);
if (response.statusCode == 200) {
Device deviceInfo = Device.fromJson(response.data[0]);
return deviceInfo;
} else {
throw Exception("Unexpected Happened !");
}
}

// @description Refresh session cookie of monarchtrack server
static Future<String> getMonarchTrackServerCookie() async {
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
String? rawCookie = sharedPreferences.getString("kMonarchTrackCookieKey");
if (rawCookie == null) {
var url = serverProtocol + serverUrl + '/api/session';
var payLoad = jsonEncode({
'username': sharedPreferences.getString('username'),
'password': sharedPreferences.getString('password'),
});
try {
var response = await http.post(
Uri.parse(url),
body: payLoad,
headers: {
HttpHeaders.contentTypeHeader: 'application/json',
HttpHeaders.acceptHeader: 'application/json',
},
);
String rawCookie = response.headers["set-cookie"] as String;
return rawCookie;
} catch (error) {
throw Exception(error);
}
}
return rawCookie;
}

// @description Generate Tracker Link
static Future<String> generateTrackerLink({required int deviceId}) async {
try {
String token = '';
String rawCookie = await getMonarchTrackServerCookie();
var payLoad = jsonEncode({'deviceId': deviceId});
var trackApiResponse = await http.post(
Uri.parse(serverProtocol + serverUrl + '/misc/token'),
headers: {
HttpHeaders.contentTypeHeader: 'application/json',
HttpHeaders.acceptHeader: 'application/json',
HttpHeaders.cookieHeader: rawCookie
},
body: payLoad,
);
if (trackApiResponse != null) {
token = jsonDecode(trackApiResponse.body)['token'];
}
return serverProtocol + serverUrl + '/track/$token';
} catch (error) {
throw Exception(error);
}
}

Future<List<Event>> getEvents(
    {required String from, required String to}) async {
  List eventType = [
    "geofenceExit",
    "geofenceEnter",
    "deviceOverspeed",
    "deviceFuelDrop",
    "maintenance"
  ];
  String cookie = await getCookie();
  String deviceIds = appProvider.getDevicesIds();
  String uri = "$serverProtocol$serverUrl/api/reports/events?from=" +
      from +
      '&to=' +
      to +
      "&" +
      deviceIds;
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": 17
  };
  var response = await Dio().get(
    uri,
    //queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    List<Event> events = [];
    String aux = '';
    for (var ev in response.data) {
      if (Event.fromJson(ev).type != aux &&
          eventType.contains(Event.fromJson(ev).type)) {
        events.add(Event.fromJson(ev));

        aux = Event.fromJson(ev).type;
      }
    }
    print(" events::1 $events");
    return events;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Stops>> getReportStops(
    {required String from, required String to}) async {
  String cookie = await getCookie();
  int selectedDeviceId = appProvider.selectedId;
  String uri = "$serverProtocol$serverUrl/api/reports/stops";
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": selectedDeviceId
  };
  var response = await Dio().get(
    uri,
    queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    List<Stops> stops = [];
    for (var ev in response.data) {
      stops.add(Stops.fromJson(ev));
    }

    return stops;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Trips>> getReportTrips(
    {required String from, required String to}) async {
  String cookie = await getCookie();
  int SelectedDeviceId = appProvider.selectedId;
  String uri = "$serverProtocol$serverUrl/api/reports/stops";
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": SelectedDeviceId
  };
  var response = await Dio().get(
    uri,
    queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print(" events:: ${response.data}");
    List<Trips> trips = [];
    for (var ev in response.data) {
      trips.add(Trips.fromJson(ev));
    }

    return trips;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Position>> getTodayTrip(
    {required String from, required String to}) async {
  String cookie = await getCookie();
  int SelectedDeviceId = appProvider.selectedId;
  String uri = "$serverProtocol$serverUrl/api/positions?from=" +
      from +
      "&to=" +
      to +
      "&deviceId=" +
      SelectedDeviceId.toString();
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": SelectedDeviceId
  };

  var response;
  await Dio()
      .get(
    uri,
    queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  )
      .then((value) => response = value);
  if (response.statusCode == 200) {
    print('todayTripLoadedApiRes200');

    Position? _pos = new Position(
      deviceId: 0,
      outdated: false,
      valid: false,
      latitude: 0,
      longitude: 0,
      altitude: 0,
      speed: 0,
      course: 0,
      id: 0,
      attributes: new PositionAttributes(),
    );
    print('todayTripPoly:::');
    List<Position> todayTrip = [];

    for (var ev in response.data) {
      if (Position.fromJson(ev) != _pos &&
          Position.fromJson(ev).latitude != 0) {
        todayTrip.add(Position.fromJson(ev));
        _pos = Position.fromJson(ev);
      }
    }

    return todayTrip;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<SummaryModel>> getReportSummary(
    {required String from, required String to}) async {
  String cookie = await getCookie();
  int SelectedDeviceId = appProvider.selectedId;
  String uri = "$serverProtocol$serverUrl/api/reports/summary";
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": SelectedDeviceId
  };
  var response = await Dio().get(
    uri,
    queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print(" events:: ${response.data}");
    List<SummaryModel> summary = [];
    for (var ev in response.data) {
      summary.add(SummaryModel.fromJson(ev));
    }

    return summary;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Maintenances>> getAllMaintenances(
    {required bool isDatetime}) async {
  String cookie = await getCookie();
  String deviceIds = appProvider.getDevicesIds();
  String uri = "$serverProtocol$serverUrl/api/maintenance";

  var response = await Dio().get(
    uri,
    //queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    //print(" maintenance:: ${response.data}");
    List<Maintenances> maintenance = [];

    for (var ev in response.data) {
      if (isDatetime == true) {
        if (Maintenances.fromJson(ev).type == 'Datetime') {
          maintenance.add(Maintenances.fromJson(ev));
        }
      } else if (isDatetime == false) {
        if (Maintenances.fromJson(ev).type != 'Datetime') {
          maintenance.add(Maintenances.fromJson(ev));
        }
      }
      // maintenance.add(Maintenances.fromJson(ev));
      print('maintenanceType::${(Maintenances.fromJson(ev)).type}');
    }
    return maintenance;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future DeleteMaintenance({required int maintenanceId}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/maintenance/$maintenanceId";
  // final queryParameters = <String, dynamic>{"id": maintenanceId};

  var response = await Dio().delete(
    uri,
    //  queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 204) {
    print(" maintenance Deleted");
  } else {
    print(" maintenance Deleted");
    print(" maintenance Del Status${response.statusCode}");

    throw Exception("Unexpected Happened !");
  }
}

Future UpdateEvent({required int eventId, required data}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/reports/events/$eventId";
  // final queryParameters = <String, dynamic>{"id": maintenanceId};

  var response = await Dio().put(
    uri,
    data: data,
    //  queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print('eventUpdateDataRes200');
  } else {
    print(" eventUpdateDataError");
    print(" eventUpdateDataStatusCode${response.statusCode}");

    throw Exception("Unexpected Happened !");
  }
}

Future UpdateMaintenance({required int maintenanceId, required data}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/maintenance/$maintenanceId";
  // final queryParameters = <String, dynamic>{"id": maintenanceId};

  var response = await Dio().put(
    uri,
    data: data,
    //  queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print('FormUpdateDateTimeUpdated');
  } else {
    print(" maintenance Updated");
    print(" FormUpdateDateTime Status${response.statusCode}");

    throw Exception("Unexpected Happened !");
  }
}

Future AddMaintenance({required data}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/maintenance";
  // final queryParameters = <String, dynamic>{"id": maintenanceId};

  var response = await Dio().post(
    uri,
    data: data,
    //  queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print('FormAddDateRes${response.data['id']}');
    print('FormAddDateRes${response.data['attributes']['deviceId']}');

    var maintenancePermission = {
      "deviceId": response.data['attributes']['deviceId'],
      "maintenanceId": response.data['id']
    };
    await setPermission(data: maintenancePermission);
  } else {
    print(" FormUpdateAdd Status${response.statusCode}");

    throw Exception("Unexpected Happened !");
  }
}

Future setPermission({required data}) async {
  String cookie = await getCookie();
  String uri = "$serverProtocol$serverUrl/api/permissions";
  // final queryParameters = <String, dynamic>{"id": maintenanceId};

  var response = await Dio().post(
    uri,
    data: data,
    //  queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 204) {
    print('SetPermission${response.statusCode}');

    //SET PERMISSION
  } else {
    print(" FormUpdateAdd Status${response.statusCode}");

    throw Exception("Unexpected Happened !");
  }
}

Future<List<Maintenances>> getMaintenancesById(
    {required id, required bool isDatetime}) async {
  String cookie = await getCookie();

  String uri = "$serverProtocol$serverUrl/api/maintenance?deviceId=" + id;

  var response = await Dio().get(
    uri,
    //queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    //print(" maintenance:: ${response.data}");
    List<Maintenances> maintenance = [];

    for (var ev in response.data) {
      if (isDatetime == true) {
        if (Maintenances.fromJson(ev).type == 'Datetime') {
          maintenance.add(Maintenances.fromJson(ev));
        }
      } else if (isDatetime == false) {
        if (Maintenances.fromJson(ev).type != 'Datetime') {
          maintenance.add(Maintenances.fromJson(ev));
        }
      }
      //print('maintenanceType::${(Maintenances.fromJson(ev)).type}');
    }
    return maintenance;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Maintenances>> getAlerteMaintenancesById({required id}) async {
  String cookie = await getCookie();

  String uri = "$serverProtocol$serverUrl/api/maintenance/$id";

  var response = await Dio().get(
    uri,
    //queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    //print(" maintenance:: ${response.data}");
    List<Maintenances> maintenance = [];
    maintenance.add(Maintenances.fromJson(response.data));
    //print('maintenanceType::${(Maintenances.fromJson(ev)).type}');

    return maintenance;
  } else {
    throw Exception("Unexpected Happened !");
  }
}

Future<List<Chart>> getCharts(
    {required String from, required String to}) async {
  String cookie = await getCookie();
  // String deviceIds = '9&deviceId=33';
  String uri =
      "https://tracking.emkatech.tn/api/reports/chart?deviceId=8&from=2021-08-01T01:00:00.000Z&to=2021-08-02T23:23:54.999Z";
  final queryParameters = <String, dynamic>{
    "from": from,
    "to": to,
    "deviceId": 8
  };
  var response = await Dio().get(
    uri,
    //queryParameters: queryParameters,
    options: Options(
      contentType: "application/json",
      headers: <String, dynamic>{
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": cookie,
      },
    ),
  );
  if (response.statusCode == 200) {
    print(" charts:: ${response.data}");
    // print(" charts:: ${response.data[0].fuel}");

    List<Chart> charts = [];
    double fuel = 0;
    for (var ev in response.data) {
      if (Chart.fromJson(ev).fuel != 0) {
        if (Chart.fromJson(ev).fuel - fuel > 10)
          fuel = Chart.fromJson(ev).fuel;

        if (Chart.fromJson(ev).fuel < fuel) {
          charts.add(Chart.fromJson(ev));
          fuel = Chart.fromJson(ev).fuel;
        }
      }
    }

    return charts;
  } else {
    throw Exception("Unexpected Happened !");
  }
}
}