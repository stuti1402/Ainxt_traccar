import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/chart.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/widget/line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const d_grey = Color(0xFFEDECF2);

class ConsomPage extends StatefulWidget {
  const ConsomPage({Key? key}) : super(key: key);

  @override
  _ConsomPageState createState() => _ConsomPageState();
}

class _ConsomPageState extends State<ConsomPage> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Chart> _charts = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  List<Chart> _searchResults = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ConsomPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // onRefresh //
  void _onRefresh() async {
    await _getCharts();
    _appProvider.setCharts(_charts);
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Chart>> _getCharts() async {
    _charts = await TraccarClientService(appProvider: _appProvider).getCharts(
        from: '2021-08-01T01:00:00.000Z', to: '2021-08-02T23:00:00.000Z');
    return _charts;
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _charts = _appProvider.getCharts();
    return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      appBar: !_searchClicked
          ? AppBar(
              backgroundColor: Color(0xFF149cf7),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text('Chart'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() => _searchClicked = true),
                )
              ],
            )
          : AppBar(
              backgroundColor: Color(0xFF149cf7),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() => _searchClicked = false),
              ),
              title: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 20),
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onChanged: (value) {
                  _searchResults.clear();
                  _charts.forEach((item) {
                    if (item.deviceId
                        .toString()
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
                  itemCount: _charts.length,
                  itemBuilder: (context, index) {
                    return _listViewElementWidget(_charts[index]);
                  },
                ),
        ),
      ),
    ));
  }

  //ListView element widget
  Widget _listViewElementWidget(Chart item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _searchClicked = false;
            _searchController.clear();
            Navigator.pushNamed(context, '/devicesDetails', arguments: item);
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
                        // decoration: getIcon(item.fuel.toString()),
                        // height: 40,
                        //  width: 40,
                        child: Center(
                          child: Text(
                            'Fuel::' + item.fuel.toInt().toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  lastupdate(String date) {
    DateTime newdate = DateTime.parse(date);
    final date2 = DateTime.now();
    final difference = date2.difference(newdate).inDays;
    var diff = calculTime(newdate, date2);
    return Text(diff.toString(), style: TextStyle(color: Colors.grey[600]));
  }

  calculTime(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    if (to.difference(from).inMinutes < 60)
      return "${(to.difference(from).inMinutes)} min";
    if (to.difference(from).inHours < 24 && to.difference(from).inHours > 0)
      return "${(to.difference(from).inHours)} h";
    if (to.difference(from).inDays > 1)
      return "${(to.difference(from).inDays)} j";
  }

  getIcon(String st) {
    final String image;
    if (st == 'offline')
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
}
