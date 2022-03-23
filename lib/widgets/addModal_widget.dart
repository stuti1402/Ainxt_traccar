import 'package:flutter/material.dart';
class AddModal extends StatelessWidget {
  const AddModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.account_box_rounded),
          title: new Text('User'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: new Icon(Icons.directions_car_filled_rounded),
          title: new Text('Vehicle'),
          onTap: () {
            Navigator.pop(context);
          },
        ),


      ],
    );
  }
}
