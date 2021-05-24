import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sloff/components/rectangle_button.dart';

class Challenge extends StatefulWidget {
  const Challenge({Key key, this.goToProfile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Challenge();
  }

  final Function goToProfile;
}

class _Challenge extends State<Challenge> with SingleTickerProviderStateMixin {
  final tabs = [
    'Challenge'
    /* , 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'*/
  ];
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

  Stream stream = FirebaseFirestore.instance.collection('coupon').snapshots();

  TabController _tabController;

  void initState() {
    super.initState();
    fetchname();
    didChangeDependencies();
    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void fetchname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cc = await prefs.getString('company');

    String uuid = await prefs.getString('uuid');
    setState(() {
      uuidhere = uuid;
      company = cc;
    });
    print('fetchname');

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('focus').doc(uuid).get();
    print('doc ' + aa.toString());

    setState(() {
      if (aa['available'] == null) {
        focustime = 0;
      } else {
        focustime = aa['available'];
      }
      print('ilname' + focustime.toString());
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
                    1.2, Row(
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
                                          child: Row(
                                            children: [
                                              InkWell(
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
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
                                                            .collection(
                                                                'users_company')
                                                            .doc(company)
                                                            .collection(
                                                                'challenge')
                                                            .where('elapsed_time',
                                                                isGreaterThan:
                                                                    DateTime
                                                                        .now())
                                                            .snapshots(),
                                                        builder:
                                                            (context, snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return Text(
                                                                !hours
                                                                    ? (0).toString() +
                                                                        " min"
                                                                    : (0).toString() +
                                                                        " h",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold));
                                                          } else if (snapshot.data
                                                                  .docs.length ==
                                                              0) {
                                                            return Text(
                                                                !hours
                                                                    ? (0).toString() +
                                                                        " min"
                                                                    : (0).toString() +
                                                                        " h",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold));
                                                          } else {
                                                            return StreamBuilder(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users_company')
                                                                    .doc(company)
                                                                    .collection(
                                                                        'challenge')
                                                                    .doc(snapshot
                                                                        .data
                                                                        .docs[0]
                                                                        .id)
                                                                    .collection(
                                                                        'focus')
                                                                    .doc(uuidhere)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshots) {
                                                                  if (!snapshots
                                                                      .hasData) {
                                                                    return Text(
                                                                        !hours
                                                                            ? (0).toString() +
                                                                                " min"
                                                                            : (0).toString() +
                                                                                " h",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold));
                                                                  } else {
                                                                    if (!snapshots
                                                                        .data
                                                                        .exists) {
                                                                      return Text(
                                                                          !hours
                                                                              ? (0).toString() +
                                                                                  " min"
                                                                              : (0).toString() +
                                                                                  " h",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight.bold));
                                                                    } else {
                                                                      return Text(
                                                                          !hours
                                                                              ? (snapshots.data['available'].toString() +
                                                                                  " min")
                                                                              : (snapshots.data['available'] / 60).round().toString() +
                                                                                  " h",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight.bold));
                                                                    }
                                                                  }
                                                                });
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                        .collection('focus')
                        .doc(uuidhere)
                        .snapshots(),
                    builder: (context, firstsnap) {
                      print('ENTRANDO');

                      if (!firstsnap.hasData) {
                        print('ENTRANDO1');

                        return Container();
                      } else {
                        print('ENTRANDO2');

                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users_company')
                                .doc(company)
                                .collection('challenge')
                                .where('elapsed_time',
                                    isGreaterThan: DateTime.now())
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
                                  .format(snapshot.data.docs[0]['created_at']
                                      .toDate())
                                  .toString();
                              challengeEnd = DateFormat('dd/MM/yyyy')
                                  .format(snapshot.data.docs[0]['elapsed_time']
                                      .toDate())
                                  .toString();
                              {
                                print("CIAOOOO");
                                if (!snapshot.data.docs[0]['group']) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users_company')
                                          .doc(company)
                                          .collection('challenge')
                                          .doc(snapshot.data.docs[0].id)
                                          .collection('focus')
                                          .doc(uuidhere)
                                          .snapshots(),
                                      builder: (context, thirdsnap) {
                                        var lalist = snapshot.data;
                                        var time;

                                        if (!thirdsnap.hasData) {
                                          time = 0;
                                        } else if (!thirdsnap.data.exists) {
                                          time = 0;
                                        } else {
                                          time = thirdsnap.data['available'];
                                        }
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users_company')
                                                .doc(company)
                                                .collection('challenge')
                                                .doc(snapshot.data.docs[0].id)
                                                .collection('coupon')
                                                .snapshots(),
                                            builder: (context, couponsnap) {
                                              if (!couponsnap.hasData) {
                                                return Container();
                                              } else if (couponsnap
                                                      .data.docs.length ==
                                                  0) {
                                                return Container();
                                              } else {
                                                int div = 0;
                                                if (time > 0) {
                                                  div = (time / 60).toInt();
                                                } else {
                                                  div = 0;
                                                }
                                                return Column(
                                                  children: [
                                                    SlideYFadeInBottom(
                                                      0.4, Container(
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: new Color(
                                                                      0xFFFFE9C1)
                                                                  .withOpacity(
                                                                      .7)),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 20),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        challengeTitle,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color:
                                                                                new Color(0xFF190E3B))),
                                                                    Text(
                                                                        "Individual",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                new Color(0xFF190E3B))),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            'Starts: ',
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: new Color(0xFF190E3B))),
                                                                        Text(
                                                                            challengeStart,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: new Color(0xFF190E3B))),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            'Ends: ',
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: new Color(0xFF190E3B))),
                                                                        Text(
                                                                            challengeEnd,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: new Color(0xFF190E3B))),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    ListView.builder(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) => index <
                                                              couponsnap.data
                                                                  .docs.length
                                                          ? SlideYFadeInBottom(
                                                            0.2, buildItem(
                                                                false,
                                                                context,
                                                                couponsnap.data
                                                                    .docs[index],
                                                                div,
                                                                time,
                                                                time,
                                                                snapshot.data
                                                                    .docs[0].id),
                                                          )
                                                          : SlideYFadeInBottom(
                                                            0, Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            50,
                                                                        vertical:
                                                                            30),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        'Finelista1'
                                                                            .tr(),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: new TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black)),
                                                                    SizedBox(
                                                                        height:
                                                                            3),
                                                                    Text(
                                                                        'Finelista2'
                                                                            .tr(),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: new TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                            fontWeight: FontWeight
                                                                                .normal,
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black)),
                                                                  ],
                                                                )),
                                                          ),
                                                      itemCount: couponsnap.data
                                                              .docs.length +
                                                          1,
                                                    )
                                                  ],
                                                );
                                              }
                                            });
                                      });
                                } else {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users_company')
                                          .doc(company)
                                          .collection('challenge')
                                          .doc(snapshot.data.docs[0].id)
                                          .collection('focus')
                                          .snapshots(),
                                      builder: (context, fourthsnap) {
                                        var lalist = fourthsnap.data;
                                        var time = 0;
                                        for (var u = 0;
                                            u < lalist.docs.length;
                                            u++) {
                                          time = time +
                                              lalist.docs[u]['available'];
                                        }
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users_company')
                                                .doc(company)
                                                .collection('challenge')
                                                .doc(snapshot.data.docs[0].id)
                                                .collection('coupon')
                                                .snapshots(),
                                            builder: (context, couponsnap) {
                                              int div = 0;
                                              if (time > 0) {
                                                div = (time / 60).toInt();
                                              } else {
                                                div = 0;
                                              }
                                              return Column(
                                                children: [
                                                  Container(
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: new Color(
                                                                  0xFFFFE9C1)
                                                              .withOpacity(.7)),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SlideYFadeInBottom(
                                                              0.4, Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      challengeTitle,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          color: new Color(
                                                                              0xFF190E3B))),
                                                                  Text("Group",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: new Color(
                                                                              0xFF190E3B))),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Starts: ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                new Color(0xFF190E3B))),
                                                                    Text(
                                                                        challengeStart,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: new Color(0xFF190E3B))),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Ends: ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                new Color(0xFF190E3B))),
                                                                    Text(
                                                                        challengeEnd,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: new Color(0xFF190E3B))),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                  SlideYFadeInBottom(
                                                    0, ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder: (context, index) => index <
                                                              couponsnap.data.docs
                                                                  .length
                                                          ? buildItem(
                                                              true,
                                                              context,
                                                              couponsnap.data
                                                                  .docs[index],
                                                              div,
                                                              time.toInt(),
                                                              time,
                                                              snapshot.data
                                                                  .docs[0].id)
                                                          : Center(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              50,
                                                                          vertical:
                                                                              30),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                          'Finelista1'
                                                                              .tr(),
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: new TextStyle(
                                                                              fontFamily:
                                                                                  'Poppins-Regular',
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize:
                                                                                  10,
                                                                              color:
                                                                                  Colors.black)),
                                                                      Text(
                                                                          'Finelista2'
                                                                              .tr(),
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: new TextStyle(
                                                                              fontFamily:
                                                                                  'Poppins-Regular',
                                                                              fontWeight: FontWeight
                                                                                  .normal,
                                                                              fontSize:
                                                                                  10,
                                                                              color:
                                                                                  Colors.black)),
                                                                    ],
                                                                  )) /**/),
                                                      itemCount: couponsnap
                                                              .data.docs.length +
                                                          1,
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      });
                                }
                              }
                            });
                      }
                    }),
              ],
            ),

            //])
          ),
        ),
      ],
    );
  }

  writeGroupReward(DocumentSnapshot document) async {
    Map<String, dynamic> providerId = new Map();

    var now = DateTime.now();
    var validUntil = new DateTime(now.year, now.month, now.day + 14);
    Timestamp tsValidUntil = Timestamp.fromDate(validUntil);

    print("TIMEUNTIL$tsValidUntil");

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
    print(utenti.length);

    utenti.forEach((element) async {
      print(element);
      await postsRef
              .doc(element.id)
              .collection(element.id)
              .doc()
              .set(providerId)
              .then((value) async {
        await FirebaseFirestore.instance
            .collection('users_company')
            .doc(company)
            .collection('challenge')
            .doc(challengeID)
            .collection('focus')
            .doc(element.id)
            .update({
          "available": 0,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users_company')
              .doc(company)
              .collection('challenge')
              .doc(challengeID)
              .collection('coupon')
              .doc(document.id)
              .update({
            'total_coupon': 0,
            "completed": true,
            "visible": false
          }).then((value) => groupWritten = false);
        });
      }) /*.then((value) async => {
      await FirebaseFirestore.instance
          .collection('users_company')
          .doc(company)
          .collection('challenge')
          .doc(challengeID)
          .update({
      "visible":
      providerId['total_coupon'] - 1 > 0
      ? true
          : false,
      "completed":
      providerId['total_coupon'] - 1 > 0
      ? false
          : true
      })
      })*/
          ;
    });
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
        print("TOTAL" + document['total_coupon'].toString());
        if (usertime >= document['total_focus'] * 60) {
          if (!groupWritten) {
            groupWritten = true;
            writeGroupReward(document);
          }
        }
      }
    }

    redeemCallback() async {
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
                //height: MediaQuery.of(context).size.height * 0.53,
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
                              int available = postRef1['available'];
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
                                    //Navigator.pop(context);
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
      } else if (document['total_focus'] * 60 <= usertime) {
        return Coupon(
            redeemCallback: redeemCallback,
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
            userfocus: usertimedivided,
            userfocusdetail: usertime,
            id: document.id,
            totalnumber: document['total_coupon'],
            couponid: couponid);
      } else {
        return Coupon(
            redeemCallback: redeemCallback,
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
            userfocus: usertimedivided,
            userfocusdetail: usertime,
            totalnumber: document['total_coupon'],
            id: document.id,
            couponid: couponid);
      }
      //}
    }
  }
}
