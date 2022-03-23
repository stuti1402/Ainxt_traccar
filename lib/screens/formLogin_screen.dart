import 'dart:async';
import 'dart:io';

import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/connectivity_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:emka_gps/widgets/picturesSlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'no_internet.dart';

//import 'HomePage.dart';

class LoginFormValidation extends StatefulWidget {
  static const router = "/login";
  @override
  _LoginFormValidationState createState() => _LoginFormValidationState();
}

class _LoginFormValidationState extends State<LoginFormValidation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  var _isLoading = false;
  final email = TextEditingController();
  //final password = TextEditingController();

  bool _obscureText = true;
  late String apiCookie = '';
  late String username = '';
  late String password = '';
  bool _rememberMe = false;
  late AppProvider _appProvider;
  bool _loading = false;
  var login = false;
  final passwordController = TextEditingController();
  late Device _deviceInfo;
  //List<Device> _devices = [];
  //List<Position> _positions = [];
  final String _emkaWebSiteUrl = 'https://www.ainxt.tech/home/';
  final String _ailink = 'https://www.linkedin.com/company/ai-nxt-tech/';
  //'https://demo.traccar.org/'; //'https://emkatech.tn/';

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "*Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } /*else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    }*/
    else
      return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordFocusNode.dispose();
    //password.dispose();
    email.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _login(body, ctx) async {
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      _isLoading = true;
    });
    /* Session data = await Provider.of<SessionProvider>(context, listen: false)
        .fetchAndSetProducts(body);
*
    print(data.toJson());
    Provider.of<SessionProvider>(context, listen: false).setSession(data);
    setState(() {
      _isLoading = false;
    });
    /*Navigator.of(ctx).pushReplacementNamed(
      Home.router,
    );*/*/
  }

  Future<void> _buttonSubmit() async {
    if (formkey.currentState!.validate()) {
      try {
        await _login({
          'email': email.text,
          "password": passwordController.text,
          "undefined": 'true'
        }, context);
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong.'),
                ));
      }
    }
  }

//////////////////////////////////////////////////////////////////////////

// new implementation login with the cookies:

//////////////////////////////////////////////////////////////////////////

  Future getSharedPrefrences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print('rem::${sharedPreferences.getBool('rememberMe')}');
    //print('rem::${sharedPreferences.getBool('loggedIn')}');
/*
    if (sharedPreferences.getBool('loggedIn') == true &&
        sharedPreferences.getBool('rememberMe') == true) {
      Navigator.of(context).pushNamed('/home');
    }*/
    if (sharedPreferences.getBool('loggedIn') == true &&
        sharedPreferences.getBool('rememberMe') != true) {
      username = '';
      password = '';
      _rememberMe = false;
    }

    return Future.value();
  }

  Language _language = Language();

  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    getSharedPrefrences().then((data) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        email.text = username;
        passwordController.text = password;
        Provider.of<AppProvider>(context, listen: false).getLoggedIn();

        //print(' isLogging ${Provider.of<AppProvider>(context, listen: false).getLoggedIn}');
        setState(() => _language.getLanguage());
        //  TraccarClientService(appProvider: _appProvider).getDevicePositionsStream();
      });
    });
  }

  _submitForm(context) async {
    if (email.text == 'admiin') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_language.tNoAdminAccess())));
    } else if (email.text.isNotEmpty || passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final username = email.text;
      final password = passwordController.text;

      print(username);
      print(password);

      await TraccarClientService(appProvider: _appProvider).login(
          username: username,
          password: password,
          rememberMe: _appProvider.rememberMe,
          context: context);
      if (_appProvider.getResLoggedIn()) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_language.tInvalidCredentials())));
    }
    // await _appProvider.setLoggedIn(status: true);
    //  Navigator.popAndPushNamed(context, '/home');
  }

  Widget pageUI() {
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      if (model.isOnline != null) {
        return model.isOnline
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      // Colors.purple,
                      //Color(0xFF59C2FF),
                      //Color(0xFF1270E3),
                      //Color(0xFF1270E3),
                      //Color(0xFF1270E3),
                      Color.fromRGBO(239, 136, 89, 1.0),
                      const Color.fromRGBO(238, 124, 71, 1.0),
                      Color.fromRGBO(232, 108, 31, 1.0),
                      Color.fromRGBO(237, 95, 30, 1),
                    ])),
                child: Column(
                  children: [
                    PicturesSlider(),
                    Expanded(
                      child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(top: 15),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formkey,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 15),
                                    child: Center(
                                      child: Container(
                                          width: 320,
                                          //height: 150,
                                          child: Image.asset(
                                              'assets/images/logoXl.png')),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: TextFormField(
                                      controller: email,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 1.0),
                                          ),
                                          labelText: _language.tEmail(),
                                          hintText: _language.tConfirmEmail()),
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                              errorText: _language.tRequired()),
                                          //  EmailValidator(errorText: "Enter valid email id"),
                                        ],
                                      ),
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_passwordFocusNode);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 20,
                                        bottom: 0),
                                    child: TextFormField(
                                      controller: passwordController,
                                      onFieldSubmitted: (_) => _buttonSubmit(),
                                      textInputAction: TextInputAction.done,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: const BorderSide(
                                              color: const Color.fromRGBO(
                                                  237, 95, 30, 1),
                                              width: 2.0),
                                        ),
                                        labelText: _language.tPassword(),
                                        hintText: _language.tConfirmPassword(),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: _toggle,
                                          color: const Color.fromRGBO(
                                              237, 95, 30, 1),
                                        ),
                                      ),
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                              errorText: _language.tRequired()),
                                          MinLengthValidator(6,
                                              errorText:
                                                  "Password should be atleast 6 characters"),
                                          /* MaxLengthValidator(15,
                          errorText:
                              "Password should not be greater than 15 characters")*/
                                        ],
                                      ),
                                      focusNode: _passwordFocusNode,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Checkbox(
                                        value: _rememberMe,
                                        checkColor: Colors.white,
                                        activeColor:
                                            Color.fromRGBO(237, 95, 30, 1),
                                        onChanged: (value) {
                                          // print('change: ' + value.toString());
                                          _appProvider.rememberMe =
                                              _rememberMe = value!;
                                          setState(() {});
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.values[1],
                                      ),
                                      Text(_language.tRememberme(),
                                          style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  237, 95, 30, 1),
                                              fontSize: 12)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async => _submitForm(context),
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.orange,
                                        shadowColor: Colors.orange,
                                        elevation: 18,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromRGBO(255, 145, 77, 1),
                                            const Color.fromRGBO(
                                                237, 95, 30, 1),
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(_language.tLogIn(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 2.2,
                                                    color: Colors.white)),
                                      ),
                                    ),
                                  ),
/*
                          SizedBox(height: 20,),
                                  Center(
                                    child: OutlineButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                              side: BorderSide(color: Colors.blue,)
                                              ),
                                      color: Colors.blue,
                                      onPressed: () async =>
                                          _submitForm(context),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                              ),
                                            )
                                          : Text(_language.tLogIn(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  letterSpacing: 2.2,
                                                  color: Colors.black)),
                                    ),
                                  ),
                                */

                                  Container(
                                      width: double.infinity,
                                      height: 70,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 24),
                                      child: Text(
                                        _language.tSubscribeSocialMedia(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /*GFIconButton(
                                        onPressed: () async {
                                          openFacebook();
                                        },
                                        icon: Icon(FontAwesomeIcons.facebook),
                                        shape: GFIconButtonShape.pills,
                                        type: GFButtonType.outline2x,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),*/
                                      GFIconButton(
                                        onPressed: () async {
                                          openLinkedin();
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.linkedin,
                                          color: Colors.blue,
                                        ),
                                        shape: GFIconButtonShape.pills,
                                        type: GFButtonType.outline2x,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GFIconButton(
                                          onPressed: () =>
                                              launch("tel://+919004209460"),
                                          icon: Icon(FontAwesomeIcons.phoneAlt,
                                              color: Colors.black54),
                                          shape: GFIconButtonShape.pills,
                                          type: GFButtonType.outline2x,
                                          color: Colors.black54),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GFIconButton(
                                          onPressed: () async {
                                            openwhatsapp();
                                          },
                                          icon: Icon(FontAwesomeIcons.whatsapp,
                                              color: Color(0xff25d366)),
                                          shape: GFIconButtonShape.pills,
                                          type: GFButtonType.outline2x,
                                          color: Color(0xff25d366)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GFIconButton(
                                        onPressed: () async {
                                          openWebBrowser();
                                        },
                                        icon: Icon(FontAwesomeIcons.chrome),
                                        shape: GFIconButtonShape.pills,
                                        type: GFButtonType.outline2x,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ))
            : NoInternt();
      }
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    //var _language = Provider.of<Language>(context, listen: false);

    // var loading = session.loading;
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          /*
        appBar: AppBar(
          title: Text("${_appProvider.getCookie()}"),
        ),*/
          backgroundColor: Colors.white,
          body: pageUI(),

          /// this is the streamBuilder;
/*
          Column(
              children: [
                StreamBuilder(
                  stream: TraccarClientService(appProvider: _appProvider)
                      .getDevicePositionsStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;

                      /*  data is Device
                              ? {}
                              : _appProvider.setPosition(position: data);
                          for (var item in _appProvider.positions) {
                            displayPosition(item);
                          }*/
                      return Text('lk');
                    } else {
                      return Text('no Data');
                    }
                  },
                ),
                Consumer<AppProvider>(builder: (context, appProvider, child) {
                  return Text("length ${_appProvider.positions.length}");
                }),
                Flexible(
                  child: Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                    /*-  return ListView.builder(
                        itemCount: _appProvider.positions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                '${_appProvider.positions[index].deviceId}'),
                            leading:
                                Text("${_appProvider.positions[index].id}"),
                          );
                        });*/
                    return Column(
                      children: [
                        ..._appProvider.positions.map((position) =>
                            Text('${position.deviceId}:: ${position.id}'))
                      ],
                    );
                  }),
                )
              ],
            ),
*/
          /*StreamBuilder(
              stream: TraccarClientService(appProvider: _appProvider)
                  .getDevicePositionsStream,
              builder: (BuildContext context, AsyncSnapshot snapShot) {
             //   if (snapShot.hasData) {
                  Device data = snapShot.data;
                  //    if (data.device.id == _deviceInfo.id) {
                  //  print(data.position.date.toString());
                  _devices.add(data);
                  //       _lastSpeed = data.position.geoPoint.speed;
                  // _lastPositionData = data;
                  // _deviceAttributes = _lastPositionData.attributes;
                  //   _setPolyLinePoints(_devices);
                  // _setMapMarker(data, _deviceInfo);
                  //   if (_mapController.isCompleted) {
                  return Column(
                    children: <Widget>[
                       Text('$data'),
                      //_renderMap(_deviceInfo),
                    ],
                  );
                  //    }
                  //}
                //}
              },
            )*/
        ));
  }

  openWebBrowser() async {
    if (await canLaunch(_emkaWebSiteUrl))
      await launch(_emkaWebSiteUrl);
    else
      // can't launch url, there is some error
      throw "Could not launch $_emkaWebSiteUrl";
  }

  openLinkedin() async {
    if (await canLaunch(_emkaWebSiteUrl))
      await launch(_ailink);
    else
      // can't launch url, there is some error
      throw "Could not launch $_emkaWebSiteUrl";
  }

  openwhatsapp() async {
    var whatsapp = "+919004209460";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  Widget displayPosition(Position position) {
    return Text(
        'position ${position.id} , location: ${position.latitude},${position.longitude}; device: ${position.deviceId}');
  }
}
