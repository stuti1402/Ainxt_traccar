import 'package:emka_gps/api/notifcationService.dart';
import 'package:emka_gps/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotifTestScreen extends StatefulWidget {
  const NotifTestScreen({Key? key}) : super(key: key);

  @override
  _NotifTestScreenState createState() => _NotifTestScreenState();
}

class _NotifTestScreenState extends State<NotifTestScreen> {
  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                //NotificationService().showNotification(1, "Renault 9999 TU 999", "SURVITESSE", 10);

                NotificationService().showNotification(
                    1, "Device detected!", "All set for transmission", 3);
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    "Show Notification",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                NotificationService().cancelAllNotifications();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    border: Border.all(
                      color: Colors.deepOrange,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    "Cancel Notification",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}