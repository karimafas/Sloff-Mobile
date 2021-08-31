import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/ListFooterGroup.dart';
import 'package:sloff/components/ListFooterIndividual.dart';
import 'package:sloff/components/NoChallengeStatusBar.dart';
import 'package:sloff/components/RewardsTitle.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:sloff/components/StatusBarGroup.dart';
import 'package:sloff/components/StatusBarIndividual.dart';
import 'package:sloff/components/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge extends StatefulWidget {
  const Challenge(
      {Key key,
      this.goToProfile,
      this.uuid,
      this.company})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Challenge();
  }

  final Function goToProfile;
  final String uuid;
  final String company;
}

class _Challenge extends State<Challenge> with SingleTickerProviderStateMixin {
  int focusTime = 0;
  int focus = 0;
  String challengeTitle;
  String challengeStart;
  String challengeEnd;
  String challengeID;
  bool group;
  bool groupWritten = false;
  bool hours = false;
  int groupFocus = 0;
  SharedPreferences prefs;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    didChangeDependencies();

    loading = false;
  }

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void changeHoursMinutes() {
    setState(() {
      hours = !hours;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              RewardsTitle(
                  hours: hours, widget: widget, callback: changeHoursMinutes),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users_company')
                      .doc(widget.company)
                      .collection('challenge')
                      .where('visible', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else if (snapshot.data.docs.length == 0) {
                      return NoChallengeStatusBar();
                    } else if (!snapshot.data.docs[0]['visible']) {
                      return Container();
                    } else
                      challengeTitle = snapshot.data.docs[0]['title'];
                    challengeID = snapshot.data.docs[0].reference.id;
                    group = snapshot.data.docs[0]['group'];
                    challengeStart = DateFormat('dd/MM/yyyy')
                        .format(snapshot.data.docs[0]['created_at'].toDate())
                        .toString();
                    challengeEnd = DateFormat('dd/MM/yyyy')
                        .format(snapshot.data.docs[0]['elapsed_time'].toDate())
                        .toString();
                    {
                      // Individual challenge
                      if (!snapshot.data.docs[0]['group']) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("focus")
                                .doc(widget.uuid)
                                .snapshots(),
                            builder: (context, timeSnapshot) {
                              var time;

                              if (!timeSnapshot.hasData) {
                                time = 0;
                              } else if (!timeSnapshot.data.exists) {
                                time = 0;
                              } else {
                                time = timeSnapshot.data["available"];
                              }
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users_company')
                                      .doc(widget.company)
                                      .collection('challenge')
                                      .doc(snapshot.data.docs[0].id)
                                      .collection('coupon')
                                      .snapshots(),
                                  builder: (context, rewardsSnapshot) {
                                    if (!rewardsSnapshot.hasData) {
                                      return Container();
                                    } else if (rewardsSnapshot
                                            .data.docs.length ==
                                        0) {
                                      return Container();
                                    } else {
                                      return Column(
                                        children: [
                                          StatusBarIndividual(
                                              challengeTitle: challengeTitle,
                                              challengeStart: challengeStart,
                                              challengeEnd: challengeEnd),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.65,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) =>
                                                  index <
                                                          rewardsSnapshot
                                                              .data.docs.length
                                                      ? rewardBuilder(
                                                          false,
                                                          context,
                                                          rewardsSnapshot
                                                              .data.docs[index],
                                                          time,
                                                          snapshot
                                                              .data.docs[0].id)
                                                      : ListFooterIndividual(),
                                              itemCount: rewardsSnapshot
                                                      .data.docs.length +
                                                  1,
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  });
                            });
                      } else {
                        // Group challenge
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users_company")
                                .doc(widget.company)
                                .collection("challenge")
                                .doc(snapshot.data.docs[0].reference.id)
                                .collection("coupon")
                                .snapshots(),
                            builder: (context, completedSnapshot) {
                              if (!completedSnapshot.hasData) {
                                return Container();
                              } else if (completedSnapshot.hasError) {
                                return Container();
                              } else {
                                // If this reward has been completed
                                if (completedSnapshot.data.docs[0]
                                        ["total_coupon"] ==
                                    0) {
                                  return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 30),
                                      child: Column(
                                        children: [
                                          Text('groupcompleted'.tr(),
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: Colors.black)),
                                          SizedBox(height: 5),
                                          Text('groupcompleted1'.tr(),
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 10,
                                                  color: Colors.black)),
                                        ],
                                      ));
                                } else {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users_company')
                                          .doc(widget.company)
                                          .collection('challenge')
                                          .doc(snapshot.data.docs[0].id)
                                          .collection('coupon')
                                          .snapshots(),
                                      builder: (context, rewardsSnapshot) {
                                        if (!rewardsSnapshot.hasData) {
                                          return Container();
                                        } else if (rewardsSnapshot.hasError) {
                                          return Container();
                                        } else {
                                          return Column(
                                            children: [
                                              StatusBarGroup(
                                                  challengeTitle:
                                                      challengeTitle,
                                                  challengeStart:
                                                      challengeStart,
                                                  challengeEnd: challengeEnd),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) =>
                                                    index <
                                                            rewardsSnapshot.data
                                                                .docs.length
                                                        ? rewardBuilder(
                                                            true,
                                                            context,
                                                            rewardsSnapshot.data
                                                                .docs[index],
                                                            snapshot.data.docs[0]['groupFocusMinutes'],
                                                            snapshot.data
                                                                .docs[0].id)
                                                        : ListFooterGroup(),
                                                itemCount: rewardsSnapshot
                                                        .data.docs.length +
                                                    1,
                                              ),
                                            ],
                                          );
                                        }
                                      });
                                }
                              }
                            });
                      }
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget rewardBuilder(bool isGroup, BuildContext context,
      DocumentSnapshot document, int focusHours, String couponid) {
    var focusMinutes = (focusHours / 60).round();

    Widget coupon;

    if (document['visible']) {
      if (document['total_coupon'] <= 0) {
        return Container();
      } else if (document['total_focus'] * 60 <= focusHours) {
        coupon = Coupon(
            redeemCallback: () => SloffModals.unlockIndividualReward(
                context,
                couponid,
                focusHours,
                document,
                (aa, bb) => SloffMethods.saveIndividualReward(
                    couponid, document, widget.goToProfile)),
            challengeID: challengeID,
            status: 3,
            title: document['title'],
            text: document['description'],
            brand: document['brand'],
            isGroup: document['group'],
            cardReward: document['type'] == 'Libero' ? false : true,
            endDate: document['elapsed_time'],
            value:
                document['value'] != null ? document['value'].toString() : '0',
            total: document['total_focus'],
            userfocus: focusMinutes,
            userfocusdetail: focusHours,
            id: document.id,
            totalnumber: document['total_coupon']);
      } else {
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
            value:
                document['value'] != null ? document['value'].toString() : '0',
            total: document['total_focus'],
            userfocus: focusMinutes,
            userfocusdetail: focusHours,
            totalnumber: document['total_coupon'],
            id: document.id);
      }
    }

    return coupon;
  }
}
