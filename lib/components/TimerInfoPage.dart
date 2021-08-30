import 'package:flutter/material.dart';
import 'package:sloff/components/Animations.dart';

class TimerInfoPage extends StatelessWidget {
  const TimerInfoPage({
    Key key,
    this.text1,
    this.text2,
  }) : super(key: key);
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInRTL(
      0,
      Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(text1,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: new Color(0xFF190E3B)))),
          Container(
            height: 2,
          ),
          Container(
              child: Text(text2,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: new Color(0xFF190E3B)))),
        ],
      ),
    );
  }
}