import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternt extends StatefulWidget {
  const NoInternt({Key? key}) : super(key: key);

  @override
  _NoInterntState createState() => _NoInterntState();
}

class _NoInterntState extends State<NoInternt> {
  Language _language = Language();
  void initState() {
    super.initState();
    setState(() => _language.getLanguage());
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/no_internet_check.png'))),
              ),
              Text(
                _language.tNoInternetConnection(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  _language.tNoInternetConnectionMsg(),
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange),
                ),
              )
            ],
          ),
        ));
  }
}
