import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/position.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../helper/ui_helper.dart';

//Language _language = Language();

class ExploreContentWidget extends StatelessWidget {
  final double? currentExplorePercent;
  final String? deviceCategory;
  final int? selectedId;
  final Device? device;
  final Position? position;
  final Language? language;
  static ArabicNumbers arabicNumber = ArabicNumbers();

  final placeName = const [
    "Authentic\nrestaurant",
    "Famous\nmonuments",
    "Weekend\ngetaways"
  ];
  const ExploreContentWidget(
      {Key? key,
        this.currentExplorePercent,
        this.selectedId,
        this.device,
        this.position,
        this.language,
        this.deviceCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //_language = Provider.of<Language>(context);
    if (currentExplorePercent != 0) {
      return Positioned(
        top: realH(
            standardHeight + (162 - standardHeight) * currentExplorePercent!),
        width: screenWidth,
        child: Container(
            height: screenHeight,
            child: selectedId != 0
                ? ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Opacity(
                  opacity: currentExplorePercent!,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(
                              screenWidth! /
                                  3 *
                                  (1 - currentExplorePercent!),
                              screenWidth! /
                                  3 /
                                  2 *
                                  (1 - currentExplorePercent!)),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                device!.name.toString().toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ),

                      /*
                    Expanded(
                      child: Image.asset(
                        "assets/icon_2.png",
                        width: realH(133),
                        height: realH(133),
                      ),
                    ),
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(
                            -screenWidth! / 3 * (1 - currentExplorePercent!),
                            screenWidth! /
                                3 /
                                2 *
                                (1 - currentExplorePercent!)),
                        child: Image.asset(
                          "assets/icon_3.png",
                          width: realH(133),
                          height: realH(133),
                        ),
                      ),
                    ),*/
                    ],
                  ),
                ),
                Transform.translate(
                    offset: Offset(0,
                        realH(23 + 380 * (1 - currentExplorePercent!))),
                    child: Opacity(
                        opacity: currentExplorePercent!,
                        child: Container(
                          width: screenWidth,
                          height: realH(172 +
                              (172 * 4 * (1 - currentExplorePercent!))),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: realW(22)),
                              ),
                              buildListItem(0, "suivi", context),
                              buildListItem(0, "parking", context),
                              buildListItem(0, "trips", context),
                              buildListItem(0, "report", context),
                            ],
                          ),
                        ))),
                Transform.translate(
                    offset: Offset(
                        0, realH(8 + 570 * (1 - currentExplorePercent!))),
                    child: Opacity(
                      opacity: currentExplorePercent!,
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: realW(22)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: realW(22)),
                              child: Text(language!.tDeviceDetails(),
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Column(
                              children: <Widget>[
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.update_rounded,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        (position!.fixTime != null &&
                                            position!.fixTime != '')
                                            ? ((DateTime.parse(position!
                                            .fixTime
                                            .toString()))
                                            .add(new Duration(
                                            hours: 1))
                                            .toString())
                                            .substring(
                                            0,
                                            ((DateTime.parse(position!
                                                .fixTime
                                                .toString()))
                                                .add(new Duration(
                                                hours: 1))
                                                .toString())
                                                .indexOf('.'))
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[100]),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.speed_rounded,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tSpeed().toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.speed != null
                                            ? getkmh(
                                            (position!.speed * 1.852)
                                                .round())
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.speed_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'RPM',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes.rpm != null
                                            ? getRpm((position!
                                            .attributes.rpm)!
                                            .round())
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.local_gas_station_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tFuel().toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes.fuel != null
                                            ? getFuel(
                                            position!.attributes.fuel)
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.device_thermostat,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tDeviceTemp(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes
                                            .coolantTemp !=
                                            null
                                            ? getTemp((position!
                                            .attributes
                                            .coolantTemp)!
                                            .round())
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.car_rental,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tIgnition(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes.ignition !=
                                            null
                                            ? position!.attributes
                                            .ignition ==
                                            false
                                            ? language!.tNo()
                                            : language!.tYes()
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.vpn_key_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tDriver(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        language!.tUnknown(),
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                deviceCategory != 'crane'
                                    ? ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.car_repair_outlined,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tTotalDistance(),
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes
                                            .totalDistance !=
                                            null
                                            ? getdistance(((position!
                                            .attributes
                                            .totalDistance)! /
                                            1000)
                                            .round())
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )
                                    : ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.timer,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tCraneHours(),
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes
                                            .totalDistance !=
                                            null
                                            ? getCraneHours((((position!
                                            .attributes
                                            .hours)! /
                                            1000) /
                                            3600)
                                            .round())
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.car_rental,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tTrailerStatus(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes
                                            .trailerStatus !=
                                            null
                                            ? position!.attributes
                                            .trailerStatus! >
                                            2700
                                            ? language!.tOpen()
                                            : language!.tClose()
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: Icon(
                                    Icons.car_rental,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    language!.tTrailerCharge(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        position!.attributes
                                            .trailerStatus !=
                                            null
                                            ? position!.attributes
                                            .trailerStatus! >
                                            2400
                                            ? 'Vide'
                                            : 'Chargé'
                                            : '--',
                                        style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: realW(22)),
                              child: Text(language!.tAction(),
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Transform.translate(
                              offset: Offset(
                                  0,
                                  realH(50 -
                                      30 *
                                          (currentExplorePercent! -
                                              0.75) *
                                          4)),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (position!.protocol
                                            .toString() ==
                                            "teltonika") {
                                          // _sendSMS("RELAY,1#");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content:
                                              Text("Not yet")));
                                          //  print('sms_shut-down sended');
                                        } else if (position!.protocol
                                            .toString() ==
                                            "gt06") {
                                          _sendSMS("RELAY,1#");
                                          // print('sms_shut-down sended');
                                        } else {
                                          print('sms_protocol_inconnu');
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.25,
                                        height: realH(80),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFe52d27),
                                                Color(0xFFb31217),
                                              ]),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 10.0,
                                                spreadRadius: 1.0,
                                                offset: Offset(3.0, 3.0))
                                          ], /*
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/red-turn-off.png"),
                                              fit: BoxFit.cover),*/
                                        ),
                                        child: Icon(
                                          Icons.flash_off_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (position!.protocol
                                            .toString() ==
                                            "teltonika") {
                                          //  _sendSMS("RELAY,0#");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content:
                                              Text("Not yet")));
                                          // print('sms_shut-down sended');
                                        } else if (position!.protocol
                                            .toString() ==
                                            "gt06") {
                                          _sendSMS("RELAY,0#");
                                          print('sms_shut-down sended');
                                        } else {
                                          print('sms_protocol_inconnu');
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.25,
                                        height: realH(80),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFa8e063),
                                                Color(0xFF56ab2f),
                                              ]),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 10.0,
                                                spreadRadius: 1.0,
                                                offset: Offset(3.0, 3.0))
                                          ],
                                          /*
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/green-turn-on.png"),
                                              fit: BoxFit.cover),*/
                                        ),
                                        child: Icon(
                                          Icons.offline_bolt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: realH(262)),
                )
              ],
            )
                : Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        language!.tNoSelectedDevice(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                        MediaQuery.of(context).size.height * 0.08),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        language!.tHomeSelectDevice(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                        MediaQuery.of(context).size.height * 0.25),
                    Container(
                      child:
                      Image.asset('assets/images/truckExplore2.gif'),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1)
                  ],
                ),
              ],
            )),
      );
    } else {
      return const Padding(
        padding: const EdgeInsets.all(0),
      );
    }
  }

  void _sendSMS(String msg) async {
    List<String> recipents = [];
    String? phoneNumber = device!.phone;
    recipents.add(phoneNumber!);

    String _result = await sendSMS(message: msg, recipients: recipents)
        .catchError((onError) {
      print("sms_error" + onError);
    });
    print("sms_sended" + _result);
  }

  getTrailerCharge(int charge) {
    int axe10 = 3000;
    int axe1 = 300;
    if (charge < 1540) {
      double percentCharge = (1540 - charge) / 24;
      //10 Kg/ 1%
      int charged = (percentCharge.toInt() * axe1) + (axe10 * 4);
      return charged.toString() + " Kg";
    } else if (charge >= 1540 && charge < 1780) {
      double percentCharge = (charge - 1540) / 24;
      //10 Kg/ 1%
      int charged = (percentCharge.toInt() * axe1) + (axe10 * 3);
      return charged.toString() + " Kg";
    } else if (charge >= 1780 && charge < 2020) {
      double percentCharge = (charge - 1540) / 24;
      //10 Kg/ 1%
      int charged = (percentCharge.toInt() * axe1) + (axe10 * 2);
      return charged.toString() + " Kg";
    } else if (charge >= 2020 && charge < 2260) {
      double percentCharge = (charge - 1540) / 24;
      //10 Kg/ 1%
      int charged = (percentCharge.toInt() * axe1) + (axe10 * 1);
      return charged.toString() + " Kg";
    } else if (charge >= 2260 && charge < 2500) {
      double percentCharge = (charge - 1540) / 24;
      //10 Kg/ 1%
      int charged = percentCharge.toInt() * axe1;
      return charged.toString() + " Kg";
    } else
      return '0 Kg';
  }

  getListItemBtnName(name) {
    switch (name) {
      case 'suivi':
        return language!.tSuivi();

      case 'parking':
        return language!.tStops();
      case 'report':
        return language!.tGeneralReport();

      case 'trips':
        return language!.tParcours();

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return '';
    }
  }

  getkmh(speed) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(speed.toInt())} " + language!.tKmh();
    else
      return speed.toString() + language!.tKmh();
  }

  getFuel(fs) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(fs.toInt())} " + language!.tLitre();
    else
      return fs.toString() + ' L';
  }

  getRpm(rpm) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(rpm.toInt())} " + " tr/mn";
    else
      return rpm.toString() + ' tr/mn';
  }

  getTemp(tmp) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(tmp.toInt())} " + " °C";
    else
      return tmp.toString() + ' °C';
  }

  getdistance(dis) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(dis.toInt())} " + language!.tKm();
    else
      return dis.toString() + language!.tKm();
  }

  getCraneHours(dis) {
    if (language!.getLanguage() == 'AR')
      return "${arabicNumber.convert(dis.toInt())} " + language!.tHours();
    else
      return dis.toString() + language!.tHours();
  }

  buildListItem(int index, String name, BuildContext context) {
    return Transform.translate(
      offset: Offset(0, index * realH(100) * (1 - currentExplorePercent!)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: realH(70),
                  height: realH(70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                          offset: Offset(3.0, 3.0))
                    ],
                    image: DecorationImage(
                        image: AssetImage("assets/images/${name}.png"),
                        fit: BoxFit.cover),
                  )),
              onTap: () {
                print("you clicked me");
                switch (name) {
                  case 'suivi':
                    Navigator.of(context).pushNamed("/deviceMapTracking");

                    break;
                  case 'parking':
                    Navigator.of(context).pushNamed("/deviceMapStops");
                    break;
                  case 'report':
                    Navigator.of(context).pushNamed("/generalReport");
                    break;
                  case 'paper':
                    Navigator.of(context).pushNamed("/deviceMapTracking");
                    break;
                  case 'trips':
                    Navigator.of(context).pushNamed("/todayTrip");
                    break;

                  default:
                  // If there is no such named route in the switch statement, e.g. /third
                    return;
                }
              }),
          Text(
            getListItemBtnName(name).toUpperCase(),
            style:
            TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

Widget vehicleListTile(IconData icon, Color color, String deviceName,
    String title, double value, Color gradColor1, Color gradColor2) {
  return Container(
    margin: EdgeInsets.fromLTRB(4, 2, 4, 2),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                gradColor1,
                gradColor2,
              ]),
              //color:mvtColor ,
              borderRadius: BorderRadius.circular(8.0)),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              deviceName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    ),
  );
}