import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/components/Reward.dart';
import 'package:sloff/services/SloffApi.dart';
import 'package:sloff/components/SloffModals.dart';

class FocusSuccess extends StatefulWidget {
  const FocusSuccess({Key key, this.company, this.uuid, this.minutes})
      : super(key: key);

  final String company;
  final String uuid;
  final int minutes;

  @override
  _FocusSuccessState createState() => _FocusSuccessState();
}

class _FocusSuccessState extends State<FocusSuccess> {
  Future initialise;
  var challengeDetails = new Map();
  String name;

  Future<bool> initialisation() async {
    var token = await FirebaseAuth.instance.currentUser.getIdToken();
    var query = jsonDecode(await SloffApi.getUser(widget.uuid, token));

    name =
        '${query["first_name"][0].toUpperCase()}${query["first_name"].substring(1)}';

    var challenge = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(widget.company)
        .collection('challenge')
        .where('visible', isEqualTo: true)
        .get();

    var reward = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(widget.company)
        .collection('challenge')
        .doc(challenge.docs[0].id)
        .collection("coupon")
        .get();

    var time;
    if (!challenge.docs[0]["group"]) {
      var query = await FirebaseFirestore.instance
          .collection('focus')
          .doc(widget.uuid)
          .get();

      time = query["available"];
    } else {
      time = await SloffApi.getCompanyGroupFocus(companyID: widget.company);
    }

    challengeDetails = {
      "isGroup": challenge.docs[0]["group"],
      "document": challenge.docs[0],
      "challengeID": reward.docs[0].id,
      "time": time
    };

    return true;
  }

  @override
  void initState() {
    super.initState();

    initialise = initialisation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initialise,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return SlideYFadeIn(
                0.5,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                                "focus-success-1".tr(namedArgs: {"name": name}),
                                style: TextStyle(
                                    color: new Color(0xFF190E3B),
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23)),
                            Container(height: 5),
                            Text("focus-success-2".tr(),
                                style: TextStyle(
                                    color: new Color(0xFF190E3B),
                                    fontSize: 14)),
                            Container(height: 10),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Transform.scale(
                                  scale: 0.9,
                                  child: IgnorePointer(
                                    child: rewardBuilder(
                                        challengeDetails["isGroup"],
                                        context,
                                        challengeDetails["document"],
                                        challengeDetails["time"],
                                        challengeDetails["challengeID"]),
                                  ),
                                ),
                                Text("focus-success-3".tr(),
                                    style: TextStyle(
                                        color: new Color(0xFF190E3B),
                                        fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            OutlinedContentWrapper(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("FOCUS",
                                      style: TextStyle(
                                          color: new Color(0xFF190E3B),
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  Row(
                                    children: [
                                      Text(widget.minutes.toString() + " min",
                                          style: TextStyle(
                                              color: new Color(0xFF694EFF),
                                              fontFamily: 'Poppins-Regular',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Container(
                                        width: 5,
                                      ),
                                      Icon(Icons.arrow_drop_up_rounded,
                                          color: new Color(0xFF694EFF))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 25),
                            OutlinedContentWrapper(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("charts".tr().toUpperCase(),
                                      style: TextStyle(
                                          color: new Color(0xFF190E3B),
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  Row(
                                    children: [
                                      Text("5°",
                                          style: TextStyle(
                                              color: new Color(0xFFFF4E4E),
                                              fontFamily: 'Poppins-Regular',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Container(
                                        width: 5,
                                      ),
                                      Icon(Icons.arrow_drop_up_rounded,
                                          color: new Color(0xFF694EFF))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        RectangleButton(
                          width: MediaQuery.of(context).size.width * 0.9,
                          onTap: () => Navigator.of(context).pop(),
                          text: "continue".tr().toUpperCase(),
                          color: new Color(0xFFFF6926),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

class OutlinedContentWrapper extends StatelessWidget {
  const OutlinedContentWrapper({
    Key key,
    this.content,
  }) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: new Color(0xFF483F64).withOpacity(.3), width: 3),
        ),
        child: content);
  }
}

Widget rewardBuilder(bool isGroup, BuildContext context,
    DocumentSnapshot document, int focusHours, String challengeID) {
  var focusMinutes = (focusHours / 60).round();

  Widget coupon;

  if (document['visible']) {
    if (document['total_coupon'] <= 0) {
      return Container();
    } /* else if (document['total_focus'] * 60 <= focusHours) {
      coupon = Coupon(
          redeemCallback: () {},
          challengeID: challengeID,
          status: 3,
          title: document['title'],
          text: document['description'],
          brand: document['brand'],
          isGroup: document['group'],
          cardReward: document['type'] == 'Libero' ? false : true,
          endDate: document['elapsed_time'],
          value: document['value'] != null ? document['value'].toString() : '0',
          total: document['total_focus'],
          userfocus: focusMinutes,
          userfocusdetail: focusHours,
          id: document.id,
          totalnumber: document['total_coupon']);
    } */
    else {
      coupon = Coupon(
          redeemCallback: () {},
          challengeID: challengeID,
          status: 1,
          title: document['title'],
          isGroup: document['group'],
          text: document['description'],
          brand: document['brand'],
          cardReward: document['type'] == 'Libero' ? false : true,
          endDate: document['elapsed_time'],
          value: document['value'] != null ? document['value'].toString() : '0',
          total: document['total_focus'],
          userfocus: focusMinutes,
          userfocusdetail: focusHours,
          totalnumber: document['total_coupon'],
          id: document.id);
    }
  }

  return coupon;
}