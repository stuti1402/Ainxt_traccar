import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/device.dart';
import 'package:emka_gps/models/maintenance.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:emka_gps/widgets/spinnerLoading.dart';
import 'package:emka_gps/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:focused_menu/modals.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:select_form_field/select_form_field.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Maintenances> _maintenances = [];
  List<Device> _devices = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  List<Maintenances> _searchResults = [];
  Language _language = Language();
  final arabicNumber = ArabicNumbers();
  List ddItems = ['All', 'all', 'one', 'two'];
  late String? _maintenanceTypeChoose = _language.tAllDevices();
  late bool loaded = false;
  final updateFormKey = GlobalKey<FormState>();
  final updateFormName = TextEditingController();

  final updateFormStart = TextEditingController();
  final updateFormPeriod = TextEditingController();

  final addFormKey = GlobalKey<FormState>();
  final addFormDeviceId = TextEditingController();
  final addFormName = TextEditingController();
  final addFormStart = TextEditingController();
  final addFormPeriod = TextEditingController();

  final List<Map<String, dynamic>> _addFormSelectItemsDevice = [];
  final List<Map<String, dynamic>> _addFormSelectItemsMaintenanceType = [];

  String _idValueChanged = '';
  String _idValueToValidate = '';
  String _idValueSaved = '';

  final _selectedDeviceController = TextEditingController();
  String _typeValueChanged = '';
  String _typeValueToValidate = '';
  String _typeValueSaved = '';
  final _selectedMaintenanceTypeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLoading = false;
    setState(() => _language.getLanguage());
  }

  @override
  void didUpdateWidget(Maintenance oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    await _getMaintenances();
    _appProvider.setMaintenance(_maintenances);
    loaded = true;
    _maintenanceTypeChoose = _language.tAllDevices();
    _refreshController.refreshCompleted();
    loaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Maintenances>> _getMaintenances() async {
    _maintenances = await TraccarClientService(appProvider: _appProvider)
        .getAllMaintenances(isDatetime: false);
    isLoading = true;

    return _maintenances;
  }

  Future _deleteMaintenances(int maintenanceId) async {
    await TraccarClientService(appProvider: _appProvider)
        .DeleteMaintenance(maintenanceId: maintenanceId);
  }

  Future _updateMaintenances(int maintenanceId, data) async {
    await TraccarClientService(appProvider: _appProvider)
        .UpdateMaintenance(maintenanceId: maintenanceId, data: data);
  }

  Future _addMaintenances(data) async {
    await TraccarClientService(appProvider: _appProvider)
        .AddMaintenance(data: data);
  }

  late bool isLoading = false;
  Future<List<Maintenances>> _getMaintenancesById(id) async {
    _maintenances = await TraccarClientService(appProvider: _appProvider)
        .getMaintenancesById(id: id, isDatetime: false);
    isLoading = true;
    return _maintenances;
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _maintenances = _appProvider.getMaintenances();
    _devices = _appProvider.getDevices();
    ddItems = [_language.tAllDevices()];
    _addFormSelectItemsDevice.clear();
    _addFormSelectItemsMaintenanceType.clear();
    _addFormSelectItemsMaintenanceType.add({
      'value': 'hours',
      'label': _language.tCraneHours(),
      'icon': Icon(Icons.menu),
      'textStyle': TextStyle(color: Colors.black),
    });
    _addFormSelectItemsMaintenanceType.add({
      'value': 'totalDistance',
      'label': _language.tTotalDistance(),
      'icon': Icon(Icons.menu),
      'textStyle': TextStyle(color: Colors.black),
    });

    for (var e in _devices) {
      ddItems.add(e.name);
      _addFormSelectItemsDevice.add(
        {
          'value': e.id,
          'label': e.name,
          'icon': Icon(Icons.car_rental),
          'textStyle': TextStyle(color: Colors.black),
        },
      );
    }
    loaded = true;

    print('dditems:$ddItems');
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            title: Text(
              _language.tMaintenanceMaintenance(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(_language.tAdd()),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Form(
                                      key: addFormKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SelectFormField(
                                            type: SelectFormFieldType.dialog,
                                            controller:
                                                _selectedDeviceController,
                                            //initialValue: _initialValue,
                                            icon: Icon(Icons.car_rental),
                                            labelText:
                                                _language.tChooseDevice(),
                                            changeIcon: true,
                                            dialogTitle: _language.tDevices(),
                                            dialogCancelBtn:
                                                _language.tCancel(),
                                            enableSearch: true,
                                            dialogSearchHint:
                                                _language.tSearch(),
                                            items: _addFormSelectItemsDevice,
                                            onChanged: (val) => setState(
                                                () => _idValueChanged = val),
                                            validator: (val) {
                                              setState(() =>
                                                  _idValueToValidate =
                                                      val ?? '');
                                              return null;
                                            },
                                            onSaved: (val) => setState(() =>
                                                _idValueSaved = val ?? ''),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SelectFormField(
                                            type: SelectFormFieldType.dialog,
                                            controller:
                                                _selectedMaintenanceTypeController,
                                            //initialValue: _initialValue,
                                            icon: Icon(Icons.menu),
                                            labelText: _language
                                                .tChooseMaintenanceType(),
                                            changeIcon: true,
                                            dialogTitle:
                                                _language.tMaintenance(),
                                            dialogCancelBtn:
                                                _language.tCancel(),
                                            enableSearch: true,
                                            dialogSearchHint:
                                                _language.tSearch(),
                                            items:
                                                _addFormSelectItemsMaintenanceType,
                                            onChanged: (val) => setState(
                                                () => _typeValueChanged = val),
                                            validator: (val) {
                                              setState(() =>
                                                  _typeValueToValidate =
                                                      val ?? '');
                                              return null;
                                            },
                                            onSaved: (val) => setState(() =>
                                                _typeValueSaved = val ?? ''),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: TextFormField(
                                              //autovalidate: true,
                                              controller: addFormName,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: _language
                                                      .tMaintenanceName(),
                                                  hintText: ''),
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                      errorText: _language
                                                          .tRequired()),
                                                  //  EmailValidator(errorText: "Enter valid email id"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: TextFormField(
                                              //automated: true,
                                              controller: addFormStart,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              /*inputFormatters: <TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly,
                                              ],*/

                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      _language.tLastVidange(),
                                                  hintText: ''),
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                      errorText: _language
                                                          .tRequired()),
                                                  //  EmailValidator(errorText: "Enter valid email id"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: TextFormField(
                                              //autovalidate: true,
                                              controller: addFormPeriod,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              /*inputFormatters: <TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly,
                                              ],*/
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      _language.tPeriod(),
                                                  hintText: ''),
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                      errorText: _language
                                                          .tRequired()),
                                                  //  EmailValidator(errorText: "Enter valid email id"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  _language.tCancel(),
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                )),
                            FlatButton(
                                onPressed: () {
                                  if (addFormName.text.isEmpty ||
                                      _selectedDeviceController.text.isEmpty ||
                                      _selectedMaintenanceTypeController
                                          .text.isEmpty ||
                                      addFormStart.text.isEmpty ||
                                      addFormPeriod.text.isEmpty) {
                                    print('FormUpdateIsEmpty');
                                  } else {
                                    var startmain = 0;
                                    var periodMain = 0;
                                    if (_selectedMaintenanceTypeController
                                            .text ==
                                        'hours') {
                                      startmain =
                                          (int.parse(addFormStart.text) *
                                                  1000) *
                                              3600;
                                      periodMain =
                                          (int.parse(addFormPeriod.text) *
                                                  1000) *
                                              3600;
                                    } else {
                                      startmain =
                                          (int.parse(addFormStart.text) * 1000);
                                      periodMain =
                                          (int.parse(addFormPeriod.text) *
                                              1000);
                                    }
                                    var maintenanceAddData = {
                                      "attributes": {
                                        "deviceId": int.parse(_idValueChanged)
                                      },
                                      "name": addFormName.text,
                                      "type": _selectedMaintenanceTypeController
                                          .text,
                                      "start": startmain,
                                      "period": periodMain
                                    };
                                    print(
                                        'maintenanceUpdateData$maintenanceAddData');
                                    _addMaintenances(maintenanceAddData);
                                    _onRefresh();
                                    Navigator.of(context).pop();

                                    _selectedDeviceController.clear();
                                    addFormName.clear();
                                    _idValueChanged = '';
                                    _idValueToValidate = '';
                                    _idValueSaved = '';
                                    _selectedMaintenanceTypeController.clear();
                                    _typeValueChanged = '';
                                    _typeValueToValidate = '';
                                    _typeValueSaved = '';
                                    addFormStart.clear();
                                    addFormPeriod.clear();
                                  }
                                },
                                child: Text(
                                  _language.tConfirm(),
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                )),
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
            centerTitle: true,
          ),
          body: loaded == false
              ? loading()
              : Column(
                  children: [
                    Container(
                      child: DropdownButton(
                        hint: Text('choose device'),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        isExpanded: true,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        dropdownColor: Colors.grey[100],
                        value: _maintenanceTypeChoose,
                        onChanged: (newValue) {
                          setState(() {
                            _maintenanceTypeChoose = newValue as String?;
                          });
                        },
                        items: ddItems.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString().toUpperCase(),
                              style:
                                  TextStyle(letterSpacing: 0.6, fontSize: 18),
                            ),
                            onTap: () async {
                              loaded = false;

                              print('choose::$e');
                              _maintenances = [];
                              if (e == _language.tAllDevices()) {
                                _onRefresh();
                              } else {
                                int? id = _appProvider.getDeviceIdByName(e);
                                _maintenances = await TraccarClientService(
                                        appProvider: _appProvider)
                                    .getMaintenancesById(
                                        id: id.toString(), isDatetime: false);
                                _appProvider.setMaintenance(_maintenances);
                                loaded = true;
                              }
                            },
                          );
                        }).toList(),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          onRefresh: _onRefresh,
                          child:
                              (_maintenances.length == 0 && isLoading == true)
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          _language.tNoMaintenanceOrPaper(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _maintenances.length,
                                      itemBuilder: (context, index) {
                                        return buildCard(
                                            context, _maintenances[index]);
                                      },
                                    ),
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }

  getActualtotalDistanceOrWorkingHours(deviceId, type) {
    if (type == 'hours') {
      int totalWorkigHours =
          _appProvider.getDeviceTotalWorkingHoursById(deviceId)!;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(((totalWorkigHours / 1000) / 3600).round())} " +
            _language.tHours();
      else
        return ((totalWorkigHours / 1000) / 3600).round().toString() +
            _language.tHours();
    } else {
      double totalDis = _appProvider.getDeviceTotalDistanceById(deviceId)!;
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((totalDis / 1000).round())} " +
            _language.tKm();
      else
        return (totalDis / 1000).round().toString() + _language.tKm();
    }
  }

  getNextMaintenance(int start, int period, type) {
    int nextMaintenance = start + period;

    if (type == 'hours') {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((nextMaintenance / 3600).round())} " +
            _language.tHours();
      else
        return (nextMaintenance / 3600).round().toString() + _language.tHours();
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((nextMaintenance).round())} " +
            _language.tKm();
      else
        return (nextMaintenance).round().toString() + _language.tKm();
    }
  }

  translateLastVidangePeriod(int lv, type) {
    if (type == 'hours') {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert((lv / 3600).toInt())} " +
            _language.tHours();
      else
        return (lv / 3600).toInt().toString() + _language.tHours();
    } else {
      if (_language.getLanguage() == 'AR')
        return "${arabicNumber.convert(lv)} " + _language.tKm();
      else
        return lv.toString() + _language.tKm();
    }
  }

  Widget buildCard(BuildContext context, Maintenances item) {
    return FocusedMenuHolder(
        menuItems: [
          FocusedMenuItem(
            title: Text(_language.tDetails()),
            trailingIcon: Icon(Icons.bookmark_border),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(_language.tDetails()),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(_language.tLastVidange(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text((translateLastVidangePeriod(
                                  ((item.start) / 1000).toInt(), item.type))),
                            ),
                            ListTile(
                              title: Text(_language.tPeriod(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text(translateLastVidangePeriod(
                                  ((item.period) / 1000).toInt(), item.type)),
                            ),
                            ListTile(
                              title: Text(_language.tNextVidange(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text(getNextMaintenance(
                                  ((item.period) / 1000).toInt(),
                                  ((item.start) / 1000).toInt(),
                                  item.type)),
                            ),
                            ListTile(
                              title: Text(
                                  item.type == 'hours'
                                      ? _language.tCraneHours()
                                      : _language.tTotalDistance(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text(
                                  getActualtotalDistanceOrWorkingHours(
                                      item.attributes.deviceId, item.type)),
                            ),
                            // Text(item.start.toString()),
                            // Text(item.period.toString())
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              _language.tOkay(),
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 18),
                            )),
                      ],
                    );
                  });
            },
          ),
          FocusedMenuItem(
            title: Text(_language.tUpdate()),
            trailingIcon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(_language.tUpdate()),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Form(
                                  key: updateFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          //autovalidate: true,
                                          controller: updateFormName,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  _language.tMaintenanceName(),
                                              hintText: item.name),
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                  errorText:
                                                      _language.tRequired()),
                                              //  EmailValidator(errorText: "Enter valid email id"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          //autovalidate: true,
                                          controller: updateFormStart,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          /*inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                          ],*/
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  _language.tLastVidange(),
                                              hintText: item.type == 'hours'
                                                  ? (((item.start) / 1000) /
                                                          3600)
                                                      .toInt()
                                                      .toString()
                                                  : ((item.start) / 1000)
                                                      .toInt()
                                                      .toString()),
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                  errorText:
                                                      _language.tRequired()),
                                              //  EmailValidator(errorText: "Enter valid email id"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          //autovalidate: true,
                                          controller: updateFormPeriod,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          /*inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                          ],*/
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: _language.tPeriod(),
                                              hintText: item.type == 'hours'
                                                  ? (((item.period) / 1000) /
                                                          3600)
                                                      .toInt()
                                                      .toString()
                                                  : ((item.period) / 1000)
                                                      .toInt()
                                                      .toString()),
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                  errorText:
                                                      _language.tRequired()),
                                              //  EmailValidator(errorText: "Enter valid email id"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              _language.tCancel(),
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 18),
                            )),
                        FlatButton(
                            onPressed: () {
                              if (updateFormStart.text.isEmpty ||
                                  updateFormPeriod.text.isEmpty ||
                                  updateFormName.text.isEmpty) {
                                print('FormUpdateIsEmpty');
                              } else {
                                var maintenanceStart = 0;
                                var maintenancePeriod = 0;

                                if (item.type == 'hours') {
                                  maintenanceStart =
                                      (int.parse(updateFormStart.text) * 1000) *
                                          3600;
                                  maintenancePeriod =
                                      (int.parse(updateFormPeriod.text) *
                                              1000) *
                                          3600;
                                } else {
                                  maintenanceStart =
                                      int.parse(updateFormStart.text) * 1000;
                                  maintenancePeriod =
                                      int.parse(updateFormPeriod.text) * 1000;
                                }
                                var maintenanceUpdateData = {
                                  "id": item.id,
                                  "attributes": {
                                    "deviceId": item.attributes.deviceId
                                  },
                                  "name": updateFormName.text,
                                  "type": item.type,
                                  "start": maintenanceStart,
                                  "period": maintenancePeriod
                                };
                                print(
                                    'maintenanceUpdateData$maintenanceUpdateData');
                                _updateMaintenances(
                                    item.id, maintenanceUpdateData);
                                _onRefresh();
                                Navigator.of(context).pop();
                                updateFormName.clear();
                                updateFormPeriod.clear();
                                updateFormStart.clear();
                              }
                            },
                            child: Text(
                              _language.tConfirm(),
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 18),
                            )),
                      ],
                    );
                  });
            },
          ),
          FocusedMenuItem(
            title: Text(_language.tDelete(),
                style: TextStyle(color: Colors.white)),
            trailingIcon: Icon(Icons.delete_forever, color: Colors.white),
            backgroundColor: Colors.red,
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(_language.tDeleting()),
                      content: Text(_language.tDeletingConfirmMsg()),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              _language.tCancel(),
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 18),
                            )),
                        FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              await _deleteMaintenances(item.id);
                              _onRefresh();
                            },
                            child: Text(
                              _language.tConfirm(),
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ))
                      ],
                    );
                  });
            },
          ),
        ],
        blurSize: 8,
        blurBackgroundColor: Colors.white,
        menuWidth: MediaQuery.of(context).size.width - 30,
        menuItemExtent: 50,
        duration: Duration(seconds: 0),
        animateMenuItems: false,
        menuOffset: 12,
        openWithTap: true,
        onPressed: () {
          print('buildCard::${item.attributes.deviceId}');
        },
        child: _listViewElementWidget(item));
  }

  Widget loading() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            //Color(0xFF59C2FF),
            //Color(0xFF1270E3),
                Color.fromRGBO(255, 189, 89, 1),
                Color.fromRGBO(255, 145, 77, 1),
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingFour(
                color: Colors.white,
                size: 50.0,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "loading",
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
          child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
  //ListView element widget

  Widget _listViewElementWidget(Maintenances item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (_appProvider.checkIsIdExist(item.attributes.deviceId) == true)
          ? <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFECE9E6),
                          ],
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  //padding: EdgeInsets.only(left: 5),
                                  margin: EdgeInsets.only(left: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: getIcon(item.type),
                                        fit: BoxFit.fill,
                                      )),
                                  height: 30,
                                  width: 30,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      item.name,
                                      style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 18,
                                        // fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 30,
                                          width: 150,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 2, 0),
                                          decoration: cardDecoration(item),
                                          child: Center(
                                            child: Text(
                                              (item.attributes!.deviceId) ==
                                                      null
                                                  ? 'Not Affected'
                                                  : _appProvider
                                                      .getDeviceById(item
                                                          .attributes!.deviceId)
                                                      .name!
                                                      .toUpperCase()
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Container(
                            // height: 10,
                            //width: 10,
                            child: Text(
                              calculTimeSpend(item),
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4, left: 1),
                          child: Container(
                              height: 10,
                              width: 10,
                              decoration: cardDecoration(item)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.blue[900],
              )
            ]
          : [
              SizedBox(
                height: 0,
              )
            ],
    );
  }

  getIcon(type) {
    if (type == 'Datetime')
      return AssetImage("assets/images/maintenancePaper.png");
    else
      return AssetImage("assets/images/maintenance.png");
  }

  calculTimeSpend(item) {
    switch (item.type) {
      case 'Datetime':
        DateTime date = DateTime.fromMillisecondsSinceEpoch(item.start.toInt());
        print('datetime::$date');
        int dd = date.difference(DateTime.now()).inDays;
        if (dd < 0) dd = dd * -1;
        if (_language.getLanguage() == 'AR') {
          return "${arabicNumber.convert(dd)} " + _language.tDays();
        } else
          return "${(dd)} " + _language.tDays();

      case 'totalDistance':
        double? totaleDistance = (_appProvider
            .getDeviceTotalDistanceById(item.attributes!.deviceId));
        var rest = (totaleDistance! - (item.start + item.period));
        var finalResult = (rest / 1000).round();
        if (finalResult < 0) finalResult = finalResult * -1;

        if (_language.getLanguage() == 'AR') {
          return "${arabicNumber.convert(finalResult)} " + _language.tKm();
        } else
          return "${(finalResult)} " + _language.tKm();
      case 'Odomètre':
        double? totaleDistance = (_appProvider
            .getDeviceTotalDistanceById(item.attributes!.deviceId));
        // print('totalDiso::$totaleDistance');
        //print('totalDiso::${item.start}');
        //print('totalDiso::${item.period}');
        var rest = (totaleDistance! - (item.start + item.period));
        var finalResult = (rest / 1000).round();
        if (finalResult < 0) finalResult = finalResult * -1;

        if (_language.getLanguage() == 'AR') {
          return "${arabicNumber.convert(finalResult)} " + _language.tKm();
        } else
          return "${(finalResult)} " + _language.tKm();
      case 'hours':
        int? totaleHours =
            (_appProvider.getDeviceHoursById(item.attributes!.deviceId));
        // print('totalDiso::$totaleDistance');
        //print('totalDiso::${item.start}');
        //print('totalDiso::${item.period}');
        var rest = (totaleHours! - (item.start + item.period));

        var finalResult = ((rest / 3600) / 1000);

        if (finalResult < 0) finalResult = finalResult * -1;
        if (_language.getLanguage() == 'AR') {
          return "${arabicNumber.convert(finalResult.round())} " +
              _language.tHours();
        } else
          return "${(finalResult.round())} " + _language.tHours();
      default:
        return '***';
    }
  }

  cardDecoration(
    item,
  ) {
    var greenBox = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF59C2FF),
            Color(0xFF1270E3),
          ],
        ));
    var warningBox = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFB75E),
            Color(0xFFED8F03),
          ],
        ));
    var dangerBox = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFff9068),
            Color(0xFFff4b1f),
          ],
        ));
    switch (item.type) {
      case 'Datetime':
        DateTime date = DateTime.fromMillisecondsSinceEpoch(item.start.toInt());
        print('datetime::$date');
        int dd = date.difference(DateTime.now()).inDays;
        print('datetime::$dd');
        if (dd > 15) return greenBox;
        if (dd < 15 && dd > 0)
          return warningBox;
        else
          return dangerBox;
      case 'totalDistance':
        double? totaleDistance = (_appProvider
            .getDeviceTotalDistanceById(item.attributes!.deviceId));
        print('totalDisoOdo::$totaleDistance');
        var rest = (totaleDistance! - (item.start + item.period));
        //  print('rest$rest');
        if (rest >= 0) return dangerBox;
        if (rest < 0 && rest > -2000000)
          return warningBox;
        else
          return greenBox;
      case 'Odomètre':
        double? totaleDistance = (_appProvider
            .getDeviceTotalDistanceById(item.attributes!.deviceId));
        //  print('totalDiso::$totaleDistance');
        //  print('totalDiso::${item.start}');
        // print('totalDiso::${item.period}');
        var rest = (totaleDistance! - (item.start + item.period));
        //  print('rest$rest');
        if (rest >= 0) return dangerBox;
        if (rest < 0 && rest > -2000000)
          return warningBox;
        else
          return greenBox;
      case 'hours':
        int? totaleHours =
            (_appProvider.getDeviceHoursById(item.attributes!.deviceId));
        // print('totalDiso::$totaleDistance');
        //print('totalDiso::${item.start}');
        //print('totalDiso::${item.period}');
        var rest = (totaleHours! - (item.start + item.period));

        var finalResult = ((rest / 3600) / 1000);
        print('finalHours:$finalResult');

        if (finalResult >= 0) return dangerBox;
        if (finalResult < 0 && finalResult > -50)
          return warningBox;
        else
          return greenBox;

      default:
        return;
    }
  }

  calculTime(DateTime from, DateTime to) {
    //from = DateTime(from.year, from.month, from.day);
    //to = DateTime(to.year, to.month, to.day);

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
}
