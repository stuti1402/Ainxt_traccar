import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/models/maintenance.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const d_grey = Color(0xFFEDECF2);

class Alerte extends StatefulWidget {
  const Alerte({Key? key}) : super(key: key);

  @override
  _AlerteState createState() => _AlerteState();
}

class _AlerteState extends State<Alerte> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Event> _events = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  List<Event> _searchResults = [];
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  late bool isLoading = false;
  late bool isEventDetailLoading = false;

  List<Maintenances> _maintenances = [];

  @override
  void initState() {
    super.initState();
    isLoading = false;
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(Alerte oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    await _getEvents();
    _appProvider.setEvents(_events);
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  Future _updateEvent(int eventId, data) async {
    await TraccarClientService(appProvider: _appProvider)
        .UpdateEvent(eventId: eventId, data: data);
  }

  Future<List<Maintenances>> _getMaintenancesById(id) async {
    _maintenances = await TraccarClientService(appProvider: _appProvider)
        .getAlerteMaintenancesById(id: id);
    isLoading = true;
    return _maintenances;
  }

  Future<List<Event>> _getEvents() async {
    var todayFrom = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 01);

    var todayTo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    String formattedDateFrom =
    DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayFrom);

    String formattedDateTo = DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayTo);
    String from = formattedDateFrom + '.000Z';
    String to = formattedDateTo + '.000Z';
    _events = await TraccarClientService(appProvider: _appProvider)
        .getEvents(from: from, to: to);

    isLoading = true;
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _events = _appProvider.getEvents();
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pushNamed('/home'),
            ),
            title: Text(_language.tAllEvents()),
          ),
          body: isEventDetailLoading == false
              ? Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: (_events.length == 0 && isLoading == true)
                  ? Container(
                child: Center(
                  child: Text(
                    _language.tNoNotif(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  int indexx = (_events.length - 1) - index;
                  // print("_eventIndex::$indexx");
                  return _listViewElementWidget(
                      _events[(_events.length - 1) - index]);
                },
              ),
            ),
          )
              : loading(),
        ));
  }

  //ListView element widget
  Widget _listViewElementWidget(Event item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onTap: () {
              _searchClicked = false;
              _searchController.clear();
              // Navigator.pushNamed(context, '/eventDetails');
            },
            child: Column(
              children: [
                Container(
                    decoration: notifDecoration(item.attributes.seen),
                    child: GestureDetector(
                      onTap: () async {
                        isEventDetailLoading = true;
                        var eventUpdateData = {
                          "id": item.id,
                          "attributes": {"seen": "true"},
                          "deviceId": item.deviceId,
                          "type": item.type,
                          "serverTime": item.serverTime,
                          "positionId": item.positionId,
                          "geofenceId": item.geofenceId,
                          "maintenanceId": item.maintenanceId
                        };
                        print("eventUpdateData:$eventUpdateData");

                        await _updateEvent(item.id, eventUpdateData);
                        if (item.maintenanceId != 0) {
                          await _getMaintenancesById(item.maintenanceId);
                          _appProvider.setMaintenance(_maintenances);
                        }

                        _appProvider.setEventMarker(item.deviceId);
                        isEventDetailLoading = false;

                        Navigator.of(context)
                            .pushNamed('/eventDetails', arguments: item);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Theme.of(context).primaryColor,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/notif_icon.png'),
                                              fit: BoxFit.fill,
                                            )),
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                          child: Text(
                                            //item.id.toString(),
                                            '',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            _appProvider
                                                .getDeviceById(item.deviceId)
                                                .name
                                                .toString(),
                                            style: GoogleFonts.nunito(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Text(
                                                getEventType(item.type.toString()),
                                                style: GoogleFonts.nunito(
                                                    color: Colors.orange[900],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Container(
                              // child: IconButton(icon: Icon(Icons.check_box_outline_blank),onPressed: (){},),
                                child: lastupdate(item.serverTime.toString(),
                                    item.attributes.seen)),
                          ),
                        ],
                      ),
                      /*    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.map,
                              color: Colors.grey[350],
                            ),
                            Text(_language.tSuivi(),
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/eventDetails',
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.details,
                              color: Colors.grey[350],
                            ),
                            Text(_language.tDetails(),
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            */
                    )),
              ],
            )),
        Divider(
          color: Colors.orange[900],
        )
      ],
    );
  }

  Widget loading() {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingFour(
                color: Colors.orange,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoading(),
                style: TextStyle(color: Colors.orange),
              ),
            ],
          )),
    );
  }

  notifDecoration(seen) {
    print("seen::$seen");
    if (seen == "true") {
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 189, 89, 1),
              Color.fromRGBO(255, 145, 77, 1),

              //Color(0xFFFFFFFF),
              // Color(0xFFDCDCDC),
            ],
          ));
    } else
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 189, 89, 1),
              Color.fromRGBO(255, 145, 77, 1),

              //Color(0xFFFFFFFF),
              //Color(0xFF0091ea),
            ],
          ));
  }

  lastupdate(String date, seen) {
    DateTime newdate = DateTime.parse(date);
    // print("eventDate:$newdate");
    String sn = "false";
    if (seen != null) {
      sn = "true";
    }
    final date2 = DateTime.now();
    final difference = date2.difference(newdate).inDays;
    var diff = calculTime(newdate, date2);
    return Text(diff.toString(),
        style:
        TextStyle(color: sn == "true" ? Colors.black : Colors.grey[100]));
  }

  calculTime(DateTime from, DateTime to) {
    if (to.difference(from).inMinutes < 60) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(to.difference(from).inMinutes)} " +
            _language.tMinutes();
      else
        return "${(to.difference(from).inMinutes)} " + _language.tMinutes();
    }

    if (to.difference(from).inHours < 24 && to.difference(from).inHours > 0) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(to.difference(from).inHours)} " +
            _language.tHours();
      else
        return "${(to.difference(from).inHours)} " + _language.tHours();
    }
    if (to.difference(from).inDays > 1) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(to.difference(from).inDays)} " +
            _language.tDays();
      else
        return "${(to.difference(from).inDays)} " + _language.tDays();
    }
  }

  getEventType(String type) {
    switch (type) {
      case 'deviceOnline':
        return _language.tOnline();
      case 'deviceOffline':
        return _language.tOffline();
      case 'deviceUnknown':
        return _language.tDeviceUnknown();
      case 'deviceInactive':
        return _language.tDeviceInactive();
      case 'deviceMoving':
        return _language.tMoving();

      case 'deviceStopped':
        return _language.tStopped();
      case 'deviceOverspeed':
        return _language.tDeviceOverSpeed();
      case 'deviceFuelDrop':
        return _language.tDeviceFuelDrop();
      case 'geofenceEnter':
        return _language.tGeoFenceEnter();
      case 'geofenceExit':
        return _language.tGeoFenceExit();

      case 'ignitionOn':
        return _language.tIgnitionOn();
      case 'ignitionOff':
        return _language.tIgnitionOn();
      case 'maintenance':
        return _language.tMaintenance();

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return 'inconnu';
    }
  }
}