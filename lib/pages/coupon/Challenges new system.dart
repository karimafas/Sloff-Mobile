import 'dart:core';
import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sloff/components/RectangleButton.dart';

class ChallengeNew extends StatefulWidget {
  const ChallengeNew({Key key, this.goToProfile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Challenge();
  }

  final Function goToProfile;
}

class _Challenge extends State<ChallengeNew>
    with SingleTickerProviderStateMixin {
  int focustime = 0;
  String uuidhere;
  String company = '';
  int focus = 0;
  String challengeTitle;
  String challengeStart;
  String challengeEnd;
  String challengeID;
  bool group;
  bool groupWritten = false;
  bool hours = false;
  int focusMinutes = 0;
  int focusHours = 0;

  Stream stream = FirebaseFirestore.instance.collection('coupon').snapshots();

  TabController _tabController;

  void initState() {
    super.initState();
    fetchInfo();
    didChangeDependencies();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Future<void> sendNotification(
      String title, String description, String topic) async {
    final results = await FirebaseFunctions.instance
        .httpsCallable("sendNotification")
        .call({"title": title, "description": description, "topic": topic});
    print(results.data);
  }

  void fetchInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cc = prefs.getString('company');
    String uuid = prefs.getString('uuid');

    setState(() {
      uuidhere = uuid;
      company = cc;
    });

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('focus').doc(uuid).get();

    setState(() {
      focustime = aa["available"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("GROUP$groupWritten");

    return Stack(
      children: [
        Container(color: new Color(0xFFFFF8ED)),
        Background(),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 30),
                  child: SlideYFadeInBottom(
                    1.2,
                    Row(
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
                                  company != ''
                                      ? Container(
                                          child: InkWell(
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                hours = !hours;
                                              });
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                    height: 56,
                                                    width: 56,
                                                    child: SvgPicture.asset(
                                                        "assets/images/Coupon/focus.svg")),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("focus")
                                                        .doc(uuidhere)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      focusMinutes = snapshot
                                                          .data["available"];
                                                      focusHours =
                                                          (focusMinutes / 60)
                                                              .round();

                                                      return hours
                                                          ? Text(
                                                              "$focusHours h",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                          : Text(
                                                              "$focusMinutes min",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      11));
                                                    })
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ])),
                      ],
                    ),
                  ),
                ),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users_company')
                        .doc(company)
                        .collection('challenge')
                        .where('visible', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else if (snapshot.data.docs.length == 0) {
                        return Container();
                      } else {
                        return SlideYFadeInBottom(
                          0.4,
                          Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: new Color(0xFFFFE9C1).withOpacity(.7)),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(challengeTitle,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: new Color(0xFF190E3B))),
                                        Text(
                                            snapshot.data.docs[0]["group"]
                                                ? "Group"
                                                : "Individual",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: new Color(0xFF190E3B))),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Starts: ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        new Color(0xFF190E3B))),
                                            Text(challengeStart,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        new Color(0xFF190E3B))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Ends: ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        new Color(0xFF190E3B))),
                                            Text(challengeEnd,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        new Color(0xFF190E3B))),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        );
                      }
                    }),

                // Reward
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users_company')
                        .doc(company)
                        .collection('challenge')
                        .where('visible', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else if (snapshot.data.docs.length == 0) {
                        return Container();
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
                          .format(
                              snapshot.data.docs[0]['elapsed_time'].toDate())
                          .toString();
                      {
                        // Individual reward
                        if (!snapshot.data.docs[0]['group']) {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users_company')
                                  .doc(company)
                                  .collection('challenge')
                                  .doc(snapshot.data.docs[0].id)
                                  .collection('coupon')
                                  .snapshots(),
                              builder: (context, rewardSnapshot) {
                                if (!rewardSnapshot.hasData) {
                                  return Container();
                                } else if (rewardSnapshot.data.docs.length ==
                                    0) {
                                  return Container();
                                } else {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => index <
                                                rewardSnapshot.data.docs.length
                                            ? SlideYFadeInBottom(
                                                0.2,
                                                buildItem(
                                                    false,
                                                    context,
                                                    rewardSnapshot
                                                        .data.docs[index],
                                                    focusHours,
                                                    focusMinutes,
                                                    focusMinutes,
                                                    snapshot.data.docs[0].id),
                                              )
                                            : SlideYFadeInBottom(
                                                0,
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 50,
                                                            vertical: 30),
                                                    child: Column(
                                                      children: [
                                                        Text('Finelista1'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: new TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                        SizedBox(height: 3),
                                                        Text('Finelista2'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: new TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    )),
                                              ),
                                        itemCount:
                                            rewardSnapshot.data.docs.length + 1,
                                      )
                                    ],
                                  );
                                }
                              });
                        } else {
                          // Group reward
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users_company')
                                  .doc(company)
                                  .collection('challenge')
                                  .doc(snapshot.data.docs[0].id)
                                  .collection('coupon')
                                  .snapshots(),
                              builder: (context, rewardSnapshot) {
                                return Column(
                                  children: [
                                    SlideYFadeInBottom(
                                      0,
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) => index <
                                                rewardSnapshot.data.docs.length
                                            ? buildItem(
                                                true,
                                                context,
                                                rewardSnapshot.data.docs[index],
                                                focusMinutes,
                                                focusMinutes,
                                                focusHours,
                                                snapshot.data.docs[0].id)
                                            : Center(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 50,
                                                            vertical: 30),
                                                    child: Column(
                                                      children: [
                                                        Text('Finelista1'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: new TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                        Text('Finelista2'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: new TextStyle(
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ))),
                                        itemCount:
                                            rewardSnapshot.data.docs.length + 1,
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  writeGroupReward(DocumentSnapshot document) async {
    final QuerySnapshot query1 = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('users')
        .get();
    var users = query1.docs;

    users.forEach((element) {
      print("UTENTE " + element.reference.id);
    });

/*     Map<String, dynamic> providerId = new Map();

    var now = DateTime.now();
    var validUntil = new DateTime(now.year, now.month, now.day + 14);
    Timestamp tsValidUntil = Timestamp.fromDate(validUntil);

    print("TIMEUNTIL$tsValidUntil company $company");

    List<String> codes = List.from(document['code']);
    providerId['brand'] = document['brand'];
    providerId['group'] = true;
    providerId['code'] = document['type'] != 'Libero' ? codes[0] : '';
    providerId['created_at'] = document['created_at'];
    providerId['description'] = document['description'];
    providerId['elapsed_time'] = document['elapsed_coupon_time'];
    providerId['logo'] = document['logo'];
    providerId['type'] = document['type'];
    providerId['title'] = document['title'];
    providerId['total_coupon'] = document['total_coupon'];
    providerId['total_focus'] = document['total_focus'];
    providerId['visible'] = true;
    providerId['value'] = document['value'] != null ? document['value'] : '';
    providerId['valid_until'] = tsValidUntil;
    providerId['redeemed_at'] = Timestamp.fromDate(DateTime.now());

    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('users_coupon');

    final QuerySnapshot userlist = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('users')
        .get();
    var utenti = userlist.docs;
    print("lengthhhh" + utenti.length.toString());

    /* utenti.forEach((element) async {
      print("utente" + element.reference.id);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(element.reference.id)
          .set({"popupShown": false});
    }); */

    print("STEP");

    utenti.forEach((element) async {
      print("UTENTE" + element.reference.id);
      await postsRef
          .doc(element.id)
          .collection(element.id)
          .doc()
          .set(providerId)
          .then((value) async {
        FirebaseFirestore.instance
            .collection('users_company')
            .doc(company)
            .collection('challenge')
            .doc(document.reference.id)
            .collection('focus')
            .doc(element.id)
            .update({
          "available": 0,
        }).then((value) {
          sendNotification(
              "Well done!",
              "You and your team have just earned a group reward. Tap to find out more!",
              company);

          print("SCRIVIGRUPPO");

          FirebaseFirestore.instance
              .collection('users_company')
              .doc(company)
              .collection('challenge')
              .doc(challengeID)
              .collection('coupon')
              .doc(document.reference.id)
              .update({
            'total_coupon': 0,
            "completed": true,
            "visible": false
          }).then((value) {
            print("CAMBIAORAVAR");
            groupWritten = false;
          });
        });
      });
    }); */
  }

  Widget buildItem(
      bool isGroup,
      BuildContext context,
      DocumentSnapshot document,
      int focushour,
      int focusdetail,
      int usertime,
      String couponid) {
    var usertimedivided = (usertime / 60).round();

    if (isGroup) {
      if (document['total_coupon'] != 0) {
        if (usertime * 60 >= document['total_focus'] * 60) {
          if (!groupWritten) {
            groupWritten = true;
            writeGroupReward(document);
          }
        }
      }
    }

    redeemCallback() async {
      int available;

      AlertDialog alert = AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          contentPadding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Image.asset(
                            'assets/images/Coupon/Unlock_prize.png'),
                        width: MediaQuery.of(context).size.width * 0.8),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("unlock-title".tr(),
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 23,
                              fontFamily: 'GrandSlang',
                              color: new Color(0xFF190E3B)),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "reward-cost".tr(namedArgs: {
                            "hours-spent": usertime.toString(),
                            "hours-left":
                                (usertime - (document['total_focus'] * 60))
                                    .round()
                                    .toString()
                          }),
                          style: TextStyle(
                              color: new Color(0xFF190E3B),
                              fontSize: 12,
                              fontFamily: 'Poppins-Regular'),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    RectangleButton(
                      onTap: () async {
                        final CollectionReference postsRef = FirebaseFirestore
                            .instance
                            .collection('users_coupon');
                        var postI = couponid;
                        var postID = document.id;
                        bool isGroup = false;

                        Map<String, dynamic> providerId = new Map();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String uuid = prefs.getString('uuid');
                        String company = prefs.getString('company');

                        final DocumentSnapshot coupon = await FirebaseFirestore
                            .instance
                            .collection('users_company')
                            .doc(company)
                            .collection('challenge')
                            .doc(postI)
                            .collection('coupon')
                            .doc(postID)
                            .get();

                        print('HELLO');

                        if (coupon.exists) {
                          List<String> codes = List.from(coupon['code']);
                          isGroup = coupon['group'];
                          providerId['brand'] = coupon['brand'];
                          providerId['group'] = coupon['group'];
                          providerId['code'] =
                              coupon['type'] != 'Libero' ? codes[0] : '';
                          providerId['created_at'] = coupon['created_at'];
                          providerId['description'] = coupon['description'];
                          providerId['elapsed_time'] =
                              coupon['elapsed_coupon_time'];
                          providerId['logo'] = coupon['logo'];
                          providerId['type'] = coupon['type'];
                          providerId['title'] = coupon['title'];
                          providerId['total_coupon'] = coupon['total_coupon'];
                          providerId['total_focus'] = coupon['total_focus'];
                          providerId['visible'] = true;
                          providerId['valid_until'] = null;
                          providerId['redeemed_at'] =
                              Timestamp.fromDate(DateTime.now());
                          providerId['value'] =
                              coupon['value'] != null ? coupon['value'] : '';
                          if (codes.isNotEmpty) {
                            codes.removeAt(0);
                          }
                          FirebaseFirestore.instance
                              .collection('users_company')
                              .doc(company)
                              .collection('challenge')
                              .doc(postI)
                              .collection('coupon')
                              .doc(postID)
                              .update({
                            "total_coupon":
                                !isGroup ? providerId['total_coupon'] - 1 : 0,
                            "completed": providerId['total_coupon'] - 1 > 0
                                ? false
                                : true,
                            "visible": providerId['total_coupon'] - 1 > 0
                                ? true
                                : false,
                            "code": codes,
                          }).then((value) async {
                            final DocumentSnapshot postRef1 =
                                await FirebaseFirestore.instance
                                    .collection('users_company')
                                    .doc(company)
                                    .collection('challenge')
                                    .doc(couponid)
                                    .collection('focus')
                                    .doc(uuid)
                                    .get();
                            if (postRef1.exists) {
                              available = postRef1['available'];
                              final DocumentSnapshot couponrisc =
                                  await FirebaseFirestore.instance
                                      .collection('users_company')
                                      .doc(company)
                                      .get();
                              if (couponrisc.exists) {
                                int used = couponrisc['coupon_used'];
                                FirebaseFirestore.instance
                                    .collection('users_company')
                                    .doc(company)
                                    .update({"coupon_used": used + 1}).then(
                                        (value) async {
                                  FirebaseFirestore.instance
                                      .collection('users_company')
                                      .doc(company)
                                      .collection('challenge')
                                      .doc(couponid)
                                      .collection('focus')
                                      .doc(uuid)
                                      .update({
                                    "available": available -
                                        (providerId['total_focus'] * 60)
                                  }).then((value) async {
                                    if (!isGroup) {
                                      await postsRef
                                          .doc(uuid)
                                          .collection(uuid)
                                          .doc()
                                          .set(providerId)
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    } else {
                                      final QuerySnapshot userlist =
                                          await FirebaseFirestore.instance
                                              .collection('users_company')
                                              .doc(company)
                                              .collection('users')
                                              .get();
                                      var utenti = userlist.docs;
                                      utenti.forEach((element) async {
                                        await postsRef
                                            .doc(element.id)
                                            .collection(element.id)
                                            .doc()
                                            .set(providerId);
                                        await FirebaseFirestore.instance
                                            .collection('users_company')
                                            .doc(company)
                                            .collection('challenge')
                                            .doc(couponid)
                                            .collection('focus')
                                            .doc(element.id)
                                            .update({"available": 0});
                                      });
                                    }
                                  }).then((value) {
                                    widget.goToProfile();
                                  });
                                });
                              }
                            }
                          });
                        } else {
                          print('NANI?');
                        }
                      },
                      text: "im-sure".tr().toUpperCase(),
                      color: new Color(0xFFFF6926),
                    ),
                    SizedBox(height: 10),
                    RectangleButton(
                      onTap: () => Navigator.pop(context),
                      text: "NO",
                      color: new Color(0xFFA4A0B2),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ));

      showDialog(
          context: context,
          builder: (context) {
            return alert;
          });
    }

    if (document['visible']) {
      if (document['total_coupon'] <= 0) {
        return Container();
      } else {
        return Coupon(
            redeemCallback: redeemCallback,
            challengeID: challengeID,
            status: document['total_focus'] * 60 <= usertime ? 1 : 3,
            title: document['title'],
            isGroup: document['group'],
            text: document['description'],
            brand: document['brand'],
            cardReward: document['type'] == 'Libero' ? false : true,
            endDate: document['elapsed_time'],
            value:
                document['value'] != null ? document['value'].toString() : '0',
            total: document['total_focus'],
            userfocus: usertimedivided,
            userfocusdetail: usertime,
            totalnumber: document['total_coupon'],
            id: document.id);
      }
    }
  }
}
