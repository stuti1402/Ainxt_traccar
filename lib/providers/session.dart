import 'dart:convert';

import 'package:emka_gps/models/session.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SessionProvider with ChangeNotifier {
  var isloading = true;
  late Session _session;
  var _login = false;

  Future<Session> fetchAndSetProducts(body) async {
    const url =
        'https://demo4.traccar.org/api/session'; //'https://tracking.emkatech.tn/api/session';
    try {
      final response = await http.post(Uri.parse(url), body: body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //  print('response');
      /*   if (extractedData == null) {
        return;
      }*/
      Session _session = Session.fromJson(extractedData);

      return _session;

      //  notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  setSession(Session session) {
    _session = session;
    _login = true;
    isloading = false;
    notifyListeners();
  }

  get loading {
    return isloading;
  }

  get getSession {
    return _session;
  }

  get logIn {
    return _login;
  }

  isLoaded() async {
    const url =
        'https://demo4.traccar.org/api/session'; //'https://tracking.emkatech.tn/api/session';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      Session _session = Session.fromJson(extractedData);
      return _session;
    } catch (error) {
      throw (error);
    }
  }
}
