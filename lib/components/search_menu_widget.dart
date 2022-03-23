import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';

import '../helper/ui_helper.dart';

class SearchMenuWidget extends StatelessWidget {
  final double? currentSearchPercent;
  final Language? language;

  const SearchMenuWidget({Key? key, this.currentSearchPercent, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentSearchPercent != 0
        ? Positioned(
      bottom: realH(58 + (144 - 58) * currentSearchPercent!),
      left: realW((standardWidth - 320) / 2),
      width: realW(320),
      height: realH(60),
      child: Opacity(
          opacity: currentSearchPercent!,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: realW(20.0)),
            child: Row(
              children: <Widget>[
                _buildSearchMenuItem(
                    Icons.car_rental, language!.tDevices()),
                Padding(
                  padding: EdgeInsets.only(left: realW(16)),
                ),
              ],
            ),
          )),
    )
        : const Padding(
      padding: const EdgeInsets.all(0),
    );
  }

  _buildSearchMenuItem(IconData icon, String text) {
    return Expanded(
        child: Container(
          width: realW(130),
          height: realH(60),
          padding: EdgeInsets.only(left: realW(17)),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: realW(30),
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: realW(12)),
              ),
              Text(
                text,
                style: TextStyle(color: Colors.orange, fontSize: realW(18)),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(realW(30))),
          ),
        ));
  }
}