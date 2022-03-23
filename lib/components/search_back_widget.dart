import 'package:emka_gps/providers/language.dart';
import 'package:flutter/material.dart';
import '../helper/ui_helper.dart';

class SearchBackWidget extends StatelessWidget {
  final double? currentSearchPercent;
  final Language? language;

  final Function(bool)? animateSearch;

  const SearchBackWidget(
      {Key? key, this.currentSearchPercent, this.animateSearch,this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: realH(73),
      right: realW(27),
      child: Opacity(
        opacity: currentSearchPercent!,
        child: Container(
          width: realW(320),
          height: realH(71),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: realW(17)),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  animateSearch!(false);
                },
                child: Transform.scale(
                  scale: currentSearchPercent!,
                  child: Icon(
                    Icons.arrow_back,
                    size: realW(34),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: realW(30.0)),
                  child: TextField(
                    enabled: currentSearchPercent == 1.0,
                    cursorColor: Color(0xFF707070),
                    decoration: InputDecoration(
                      hintText: language!.tSearch(),
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: realW(22)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
