import 'package:emka_gps/api/api_services.dart';
import 'package:emka_gps/main.dart';
import 'package:emka_gps/providers/app_provider.dart';
import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Language _language = Language();
  List<String> _languages = ['AR', 'EN', 'FR'];
  late String _selectedLanguage = 'AR';
  bool _darkMode = false;
  bool _notification = false;

  @override
  void initState() {
    super.initState();
    setState(() => _language.getLanguage());
    SharedPreferences.getInstance().then((instance) {
      language = instance.getString('language');
      print('LN:::$language');
    });
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
return new WillPopScope(
    onWillPop: () async => false,
    child:
    new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:
            Text(_language.tSettings(), style: TextStyle(color: Colors.white)),
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            //Navigator.of(context).pushNamed('/home');
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange),
                SizedBox(
                  width: 8,
                ),
                Text(
                  _language.tAccount(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildLanguagesOptionRow(context),
            buildChangePasswordOptionRow(context),

            // buildAccountOptionRow(context, "Change password"),
            //  buildAccountOptionRow(context, "Content settings"),
            // buildAccountOptionRow(context, "Social"),
            //  buildAccountOptionRow(context, "Language"),
            //  buildAccountOptionRow(context, "Privacy and security"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  _language.tNotification(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow(_language.tGeoNotif(), true),
            buildNotificationOptionRow(_language.tSpeedLimitNotif(), true),
            buildNotificationOptionRow(_language.tConsumNotif(), false),
            SizedBox(
              height: 50,
            ),
            Center(
              child: OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  logoutFunction(context);
                },
                child: _appProvider.isResLoggedOut
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      )
                    : Text(_language.tLogOut(),
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    )
 ); }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.orange[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  late AppProvider _appProvider;
  logoutFunction(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('username');
    String? password = sharedPreferences.getString('password');
    _appProvider.setResLoggedOut(res: true);
    await TraccarClientService(appProvider: _appProvider)
        .closeSession(username: username, password: password, context: context);
  }

  buildLanguagesOptionRow(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(_language.tChangeLanguage()),
            leading: Icon(
              Icons.change_circle_outlined,
              color: Colors.orange,
            ),
            trailing: DropdownButton(
              hint: Text(_language.tLanguage()),
              value: _language.getLanguage(),
              onChanged: (newValue) async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('language', newValue as String);
                _language.setLanguage(newValue);
                language = newValue;
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  child: new Text(lang),
                  value: lang,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  buildChangePasswordOptionRow(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(_language.tChangePassword()),
            leading: Icon(
              Icons.change_circle_outlined,
              color: Colors.orange,
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
