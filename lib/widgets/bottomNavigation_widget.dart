import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final updateTabSelection;
  const BottomNavigation(
      {required this.selectedIndex, this.updateTabSelection});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          //update the bottom app bar view each time an item is clicked
          onPressed: () {
            updateTabSelection(0, "Home");
          },
          iconSize: 27.0,
          icon: Icon(
            Icons.home,
            //darken the icon if it is selected or else give it a different color
            color: selectedIndex == 0
                ? Colors.blue.shade900
                : Colors.grey.shade400,
          ),
        ),

        IconButton(
          onPressed: () {
            updateTabSelection(1, "Outgoing");
          },
          iconSize: 27.0,
          icon: Icon(
            Icons.directions_car_filled,
            color: selectedIndex == 1
                ? Colors.blue.shade900
                : Colors.grey.shade400,
          ),
        ),
        //to leave space in between the bottom app bar items and below the FAB
        /* 
        
    // this is for admin     
        SizedBox(
          width: 50.0,
        ),*/
        IconButton(
          onPressed: () {
            updateTabSelection(2, "Incoming");
          },
          iconSize: 27.0,
          icon: Icon(
            Icons.notifications,
            color: selectedIndex == 2
                ? Colors.blue.shade900
                : Colors.grey.shade400,
          ),
        ),
        IconButton(
          onPressed: () {
            updateTabSelection(3, "Settings");
          },
          iconSize: 27.0,
          icon: Icon(
            Icons.settings,
            color: selectedIndex == 3
                ? Colors.blue.shade900
                : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
