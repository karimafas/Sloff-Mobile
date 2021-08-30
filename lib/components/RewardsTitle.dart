import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/pages/Challenges.dart';

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
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("focus")
                                      .doc(widget.uuid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    } else {
                                      int userMinutes =
                                          snapshot.data["available"];

                                      int userHours =
                                          (snapshot.data["available"] / 60)
                                              .round();

                                      
                                      return Text(
                                          !hours
                                              ? userMinutes.toString() + " min"
                                              : userHours.toString() + " h",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold));
                                    }
                                  },
                                ),
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
