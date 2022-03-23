import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/models/events.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const d_grey = Color(0xFFEDECF2);

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _searchClicked = false;
  TextEditingController _searchController = new TextEditingController();
  List<Event> _events = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  late AppProvider _appProvider;
  List<Event> _searchResults = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ReportPage oldWidget) {
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

  Future<List<Event>> _getEvents() async {
    _events = await TraccarClientService(appProvider: _appProvider).getEvents(
        from: '2021-09-01T01:00:00.000Z', to: '2021-09-02T01:00:00.000Z');
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _events = _appProvider.getEvents();
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
              title: Text('Events'),
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
                  _events.forEach((item) {
                    if (item.type.toLowerCase().contains(value.toLowerCase())) {
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
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    return _listViewElementWidget(_events[index]);
                  },
                ),
        ),
      ),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: AssetImage('assets/images/notif_icon.png'),
                              fit: BoxFit.fill,
                            )),
                        height: 40,
                        width: 40,
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
                            item.deviceId.toString(),
                            style: GoogleFonts.nunito(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          subtitle: Row(
                            children: <Widget>[
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
                padding: const EdgeInsets.only(left: 10),
                child: Container(

                    // child: IconButton(icon: Icon(Icons.check_box_outline_blank),onPressed: (){},),
                    ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
