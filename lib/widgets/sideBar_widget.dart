import '../models/session.dart';
import '../providers/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class sideBar extends StatelessWidget {
  const sideBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
             UserAccountsDrawerHeader(
              accountName: new Text(" this is the name of the account "),
              accountEmail: new Text("this is the email address"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "M",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
          
          Column(children: [
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
            ListTile(
              leading: new Icon(Icons.home),
              title: new Text("Home"),
              //  selected: i == _selectedDrawerIndex,
              onTap: () => {},
            ),
          ]),
        ],
      ),
    );
  }
}
