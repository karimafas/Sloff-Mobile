import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sloff/pages/Challenges.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';

class RewardsTitle extends StatelessWidget {
  const RewardsTitle({
    Key key,
    @required this.hours,
    @required this.widget,
    this.callback,
  }) : super(key: key);

  final bool hours;
  final Challenge widget;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Reward",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontFamily: "GrandSlang",
                  fontSize: 24,
                  color: new Color(0xFF190E3B))),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: callback,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                    height: 56,
                                    width: 56,
                                    child: SvgPicture.asset(
                                        "assets/images/Coupon/focus.svg")),
                                Consumer<TimerNotifier>(
                                    builder: (context, data, index) {
                                      return Text(
                                          !hours
                                              ? data.individualAvailableFocusMinutes.toString() + " min"
                                              : (data.individualAvailableFocusMinutes / 60).round().toString() + " h",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold));
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ])),
        ],
      ),
    );
  }
}
