import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/global/app_colors.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const d_grey = Color(0xFFEDECF2);

class DevicesRedesignPage extends StatefulWidget {
  const DevicesRedesignPage({Key? key}) : super(key: key);

  @override
  _DevicesRedesignPageState createState() => _DevicesRedesignPageState();
}

class _DevicesRedesignPageState extends State<DevicesRedesignPage> {
  final arabicNumber = ArabicNumbers();
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Device> _devices = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  List<Device> _searchResults = [];
  Language _language = Language();

  @override
  void initState() {
    super.initState();
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(DevicesRedesignPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    await _getDevices();
    _appProvider.setDevices(_devices);
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Device>> _getDevices() async {
    _devices =
    await TraccarClientService(appProvider: _appProvider).getDevices();
    return _devices;
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _devices = _appProvider.getDevices();
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: !_searchClicked
              ? AppBar(
            backgroundColor: AppColors.appBarBackground,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(_language.tDevices()),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => setState(() => _searchClicked = true),
              )
            ],
          )
              : AppBar(
            backgroundColor: AppColors.appBarBackground,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setState(() => _searchClicked = false),
            ),
            title: TextField(
              autofocus: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: 20),
              controller: _searchController,
              //decoration: InputDecoration(
              //labelText: _language.tSearch(),
              //labelStyle: TextStyle(fontSize: 20, color: Colors.white),
              //),
              onChanged: (value) {
                _searchResults.clear();
                _devices.forEach((item) {
                  if (item.name!
                      .toLowerCase()
                      .contains(value.toLowerCase())) {
                    _searchResults.add(item);
                  }
                });
                setState(() {});
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: _searchResults.isNotEmpty && _searchController.text != ''
                  ? ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return _listViewElementWidget(_searchResults[index]);
                },
              )
                  : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return _listViewElementWidget(_devices[index]);
                },
              ),
            ),
          ),
        ));
  }

  //ListView element widget
  Widget _listViewElementWidget(Device item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _searchClicked = false;
            _searchController.clear();
          },
          child: Column(children: [
            Container(
              decoration: cardDecoration(_appProvider.getMotionId(item.id!)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration:
                                    getIcon(_appProvider.getMotionId(item.id!)),
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
                                        item.name!,
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[100],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 22,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(30),
                                              color:
                                              _appProvider.getMotionId(item.id!)
                                                  ? Colors.blue
                                                  : Colors.red,
                                            ),
                                            child: Center(
                                              child: Text(
                                                _appProvider.getMotionId(item.id!)
                                                    ? _language.tMoving()
                                                    : _language.tStopped(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          // height: 10,
                          padding: const EdgeInsets.only(right: 5),

                          child: lastupdate(item.lastUpdate),
                        ),
                      ),
                      /*  Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: _appProvider.getMotionId(item.id!)
                                  ? Colors.blue
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                  */
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            _appProvider.setSelectedId(id: item.id);
                            Navigator.of(context).pushNamed("/todayTrip");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.trip_origin,
                                color: Colors.grey[350],
                              ),
                              Text(_language.tParcours(),
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
                          onPressed: () {
                            _appProvider.setSelectedId(id: item.id);
                            Navigator.of(context).pushNamed("/deviceMapStops");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.map,
                                color: Colors.grey[350],
                              ),
                              Text(_language.tStops(),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/devicesDetails',
                                arguments: item);
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
                ],
              ),
            ),
          ]),
        ),
        Divider(
          color: Colors.grey[800],
        )
      ],
    );
  }

  lastupdate(String date) {
    DateTime newdate = DateTime.parse(date);
    final date2 = DateTime.now();
    final difference = date2.difference(newdate).inDays;
    var diff = calculTime(newdate, date2);
    return Text(diff.toString(), style: TextStyle(color: Colors.grey[200]));
  }

  calculTime(DateTime from, DateTime to) {
    // ffrom = DateTime(from.year, from.month, from.day);
    // fto = DateTime(to.year, to.month, to.day);

    if (to.difference(from).inMinutes < 60) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(to.difference(from).inMinutes)} " +
            _language.tMinutes();
      else
        return "${(to.difference(from).inMinutes)} " + _language.tMinutes();
    }

    if (to.difference(from).inHours < 24 && to.difference(from).inHours > 0) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((to.difference(from).inHours).round())} " +
            _language.tHours();
      else
        return "${(to.difference(from).inHours).round()} " + _language.tHours();
    }
    if (to.difference(from).inDays >= 1) {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(to.difference(from).inDays)} " +
            _language.tDays();
      else
        return "${(to.difference(from).inDays).round()} " + _language.tDays();
    }
  }

  getIcon(bool st) {
    final String image;
    if (st == false)
      image = 'assets/images/redTruck.png';
    else
      image = 'assets/images/truck.png';
    return BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill,
        ));
  }

  cardDecoration(motion) {
    if (motion == true)
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Color(0xFFFFFFFF),
            ],
          ));
    else
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red,
              Color(0xFFFFFFFF),
            ],
          ));
  }
}