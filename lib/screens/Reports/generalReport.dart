import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/stops.dart';
import 'package:emka_gps/models/summary.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

class GeneralReport extends StatefulWidget {
  const GeneralReport({Key? key}) : super(key: key);

  @override
  _GeneralReportState createState() => _GeneralReportState();
}

class _GeneralReportState extends State<GeneralReport> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<SummaryModel> _summary = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  late bool refreshed = false;

  late bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(GeneralReport oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    _summary = [];
    await _getSummary();
    _appProvider.setSummary(_summary);
    _refreshController.refreshCompleted();
    setState(() {
      refreshed = true;
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<SummaryModel>> _getSummary() async {
    var todayFrom = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 01);

    var todayTo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    String formattedDateFrom =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayFrom);

    String formattedDateTo = DateFormat('yyyy-MM-ddTHH:mm:ss').format(todayTo);
    String from = formattedDateFrom + '.000Z';
    String to = formattedDateTo + '.000Z';

    _summary = await TraccarClientService(appProvider: _appProvider)
        .getReportSummary(from: from, to: to);
    isLoading = true;
    return _summary;
  }

  transformtotime(ms) {
    var mins = Duration(milliseconds: ms).inMinutes;
    if (mins >= 60) {
      var hr = Duration(minutes: mins).inHours;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(hr)} " + _language.tHours();
      return hr.toString() + ' hr';
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(mins)} " + _language.tMinutes();
      else {
        return mins.toString() + ' mn';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _summary = _appProvider.getSummary();
    if (refreshed == false) _onRefresh();
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      backgroundColor: Color(0xFF59C2FF),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            Navigator.pop(context);
          }),
        ),
        title: Text(_appProvider
            .getDeviceNameById(_appProvider.selectedId)
            .toString()
            .toUpperCase()),
        backgroundColor: Color(0xFF149cf7),
        centerTitle: true,
      ),
      body: isLoading == true ? deviceGeneralReportUI(_summary) : loading(),
    )
     ); }

  getdistance(dis) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(dis.toInt())} " + _language.tKm();
    else
      return dis.toString() + _language.tKm();
  }

  getkmh(speed) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(speed.toInt())} " + _language.tKmh();
    else
      return speed.toString() + _language.tKmh();
  }

  getSpentFuel(fs) {
    if (_language.getLanguage() == 'AR')
      return "${arabicNumber.convert(fs.toInt())} " + _language.tLitre();
    else
      return fs.toString() + ' L';
  }

  Widget deviceGeneralReportUI(item) {
    return Consumer<AppProvider>(builder: (consumerContext, model, child) {
      if (model.stopsMarkers != null) {
        //  setMapCenter(model.centerFirstStop);
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              //child: Image(image: AssetImage('assets/images/logo.png'),fit: BoxFit.cover,),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/pdfdownload.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  color: Colors.white,
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _language.tDownloadPdf(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              //final pdfFile = await PdfApi.generate();
                              print('download button pressed');
                            },
                            icon: Icon(
                              Icons.download,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: FittedBox(
                  child: Text(
                _language.tGeneralReport(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              )),
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            Expanded(child: deviceSummaryDash())
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget loading() {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingFour(
                color: Colors.blue,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _language.tLoading(),
                style: TextStyle(color: Colors.blue),
              )
            ],
          )),
    );
  }

  Widget deviceSummaryDash() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color(0xFF1270E3),
              Color(0xFF59C2FF),
            ])),
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        child: ListView(
          children: [
            ListTile(
              minLeadingWidth: 10,
              leading: Icon(
                Icons.car_rental,
                color: Colors.white,
              ),
              title: Text(
                _language.tMaxSpeed(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getkmh(((_summary[0].maxSpeed.toInt()) * 1.852).toInt()),
                    style: TextStyle(color: Colors.grey[100], fontSize: 16),
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
                _language.tAverageSpeed(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getkmh(
                        ((_summary[0].averageSpeed.toInt()) * 1.852).toInt()),
                    style: TextStyle(color: Colors.grey[100], fontSize: 16),
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
                _language.tDistance(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getdistance(((_summary[0].distance) / 1000).toInt()),
                    style: TextStyle(color: Colors.grey[100], fontSize: 16),
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
                _language.tEngineHours(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transformtotime(_summary[0].engineHours),
                    style: TextStyle(color: Colors.grey[100], fontSize: 16),
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
                _language.tFuelSpent(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getSpentFuel(_summary[0].spentFuel),
                    style: TextStyle(color: Colors.grey[100], fontSize: 16),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  //ListView element widget
}
