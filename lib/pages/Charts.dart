import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:sloff/services/SloffApi.dart';

class Charts extends StatefulWidget {
  const Charts({Key key, this.name, this.focusTime, this.uuid, this.surname})
      : super(key: key);

  final String name;
  final String surname;
  final int focusTime;
  final String uuid;

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  String profilePictureUrl = "";
  int focusTime = 0;
  Future initialisation;
  List chartUsers = [];
  int userRanking = 0;
  bool loading = false;
  List loadingPhrases = [
    "Squeezing focus...",
    "Fixing timers...",
    "Calculating minutes...",
    "Predicting rewards..."
  ];

  Future<bool> initialise() async {
    var loadingTimer = Timer.periodic(Duration(seconds: 8), (timer) {
      Navigator.pop(context);
    });

    setState(() {
      loading = true;
    });

    // Get the user's profile picture
    var query1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uuid)
        .get();

    profilePictureUrl = query1["profile_picture"];

    // Get the user's currently accrued focus time
    var query2 = await FirebaseFirestore.instance
        .collection("focus")
        .doc(widget.uuid)
        .get();

    focusTime = query2["available"];

    /* var query3 = await FirebaseFirestore.instance
        .collection("focus")
        .orderBy("available", descending: true)
        .limit(10)
        .get(); 
    var users = query3.docs; */

    // Get all users' currently accrued focus time
    var token = await FirebaseAuth.instance.currentUser.getIdToken();
    var query3 = await SloffApi.getAllFocus(token);
    List focus = jsonDecode(query3);

    // Define logged user's ranking
    for (int i = 0; i < focus.length; i++) {
      if (focus[i]['uuid'] == widget.uuid) {
        userRanking = i + 1;
      }
    }

    List usersLimited = focus.length >= 9
        ? focus.sublist(0, 9)
        : focus.sublist(0, focus.length);

    await Future.forEach(usersLimited, (element) async {
      var currentUser = await SloffApi.getUser(element['uuid'], token);

      if (currentUser != "NULL") {
        currentUser = jsonDecode(currentUser);

        chartUsers.add({
          "id": element['uuid'] != null ? element['uuid'] : "null",
          "focusTime": element["total"] != null ? element["total"] : "null",
          "name": currentUser["first_name"],
          "surname": currentUser["last_name"],
          "profile_picture": currentUser["profile_picture"] != null
              ? currentUser["profile_picture"]
              : ""
        });
      } else {
        chartUsers.add({
          "id": "null",
          "focusTime": "null",
          "name": "null",
          "surname": "null",
          "profile_picture": ""
        });
      }
    });

    setState(() {
      loading = false;
    });

    loadingTimer.cancel();
    return true;
  }

  @override
  void initState() {
    super.initState();

    initialisation = initialise();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: loading
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitRotatingCircle(
                      color: new Color(0xFF190E3B),
                      size: 50.0,
                    ),
                    Container(height: 50),
                    Text(loadingPhrases[new Random().nextInt(4)],
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            : Container(
                color: new Color(0xFFFFF8ED),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top menu
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(height: 50),
                          // Header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                            color: new Color(0xFFE9E1DB),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(child: Icon(Icons.close)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 23,
                                            width: 23,
                                            child: SvgPicture.asset(
                                                "assets/images/Charts/time.svg")),
                                        Container(width: 10),
                                        Text("15 gg",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  ],
                                ),
                                Text("charts".tr(),
                                    style: TextStyle(
                                        color: new Color(0xFF190E3B),
                                        fontSize: 24,
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),

                          /*                   // Charts & prizes menu
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Row(
                        children: [
                          Text("charts".tr(),
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: new Color(0xFF694EFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Container(width: 40),
                          Text("prizes".tr(),
                              style: TextStyle(
                                  color: new Color(0xFF190E3B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ), */

                          // Separator
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            height: 1.5,
                            color: new Color(0xFFE9E1DB),
                          ),

                          // Alert box
                          Container(
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        color: new Color(0xFFD9F8E7),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("chart-alert-1".tr(),
                                            style: TextStyle(
                                                color: new Color(0xFF190E3B),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        Text("chart-alert-2".tr(),
                                            style: TextStyle(
                                                color: new Color(0xFF190E3B),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chart ListView
                    FutureBuilder(
                        future: initialisation,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return SlideFadeIn(
                              0,
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    child: ListView.builder(
                                      itemCount: chartUsers.length,
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 180),
                                      itemBuilder: (context, index) {
                                        return ChartUserCard(
                                            profilePictureUrl: chartUsers[index]
                                                ["profile_picture"],
                                            name: chartUsers[index]["name"],
                                            surname: chartUsers[index]
                                                ["surname"],
                                            widget: widget,
                                            index: index);
                                      },
                                    ),
                                  ),

                                  // Footer with user info
                                  GestureDetector(
                                    child: Container(
                                      height: 160,
                                      decoration: BoxDecoration(
                                          color: new Color(0xFFE4D4F4),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30, bottom: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                // Ranking position
                                                Text("$userRanking°",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Poppins-Regular",
                                                        color: new Color(
                                                            0xFF694EFF),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),

                                                // Profile picture
                                                FutureBuilder(
                                                    future: initialisation,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Container();
                                                      } else {
                                                        return AnimatedOpacity(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  400),
                                                          opacity:
                                                              snapshot.data ==
                                                                      true
                                                                  ? 1
                                                                  : 0,
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 20,
                                                                      left: 35),
                                                              height: 80,
                                                              width: 80,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: NetworkImage(
                                                                          profilePictureUrl)))),
                                                        );
                                                      }
                                                    }),

                                                // User name
                                                Text(
                                                    widget.name +
                                                        " " +
                                                        widget.surname,
                                                    style: TextStyle(
                                                        color: new Color(
                                                            0xFF190E3B),
                                                        fontFamily:
                                                            "Poppins-Regular",
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),

                                            // User focus
                                            FutureBuilder(
                                                future: initialisation,
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Container();
                                                  } else {
                                                    return AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      opacity:
                                                          snapshot.data == true
                                                              ? 1
                                                              : 0,
                                                      child: Text(
                                                          focusTime < 60
                                                              ? focusTime
                                                                      .toString() +
                                                                  " min"
                                                              : (focusTime / 60)
                                                                      .round()
                                                                      .toString() +
                                                                  " hr",
                                                          style: TextStyle(
                                                              color: new Color(
                                                                  0xFF190E3B),
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "Poppins-Regular",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        })
                  ],
                ),
              ),
      ),
    );
  }
}

class ChartUserCard extends StatelessWidget {
  const ChartUserCard({
    Key key,
    @required this.profilePictureUrl,
    @required this.widget,
    this.index,
    this.name,
    this.surname,
  }) : super(key: key);

  final String profilePictureUrl;
  final Charts widget;
  final int index;
  final String name;
  final String surname;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 90,
        color: index == 0
            ? new Color(0xFFFFE9C1)
            : index == 1
                ? new Color(0xFFEBF0F5)
                : index == 2
                    ? new Color(0xFFF5E5D6)
                    : Colors.transparent,
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Ranking
                Container(
                  height: 35,
                  width: 35,
                  child: index <= 2
                      ? SvgPicture.asset(index == 0
                          ? "assets/images/Charts/first.svg"
                          : index == 1
                              ? "assets/images/Charts/second.svg"
                              : index == 2
                                  ? "assets/images/Charts/third.svg"
                                  : "")
                      : Text((index + 1).toString() + "°",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: new Color(0xFFF2610C),
                              fontSize: 18,
                              fontFamily: "Poppins-Regular",
                              fontWeight: FontWeight.bold)),
                ),

                // Profile picture
                Container(
                    margin: EdgeInsets.only(right: 20, left: 25),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: new Color(0xFF483F64).withOpacity(.4),
                        image: profilePictureUrl.trim() != ""
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(profilePictureUrl))
                            : null),
                    child: profilePictureUrl.trim() == ""
                        ? Icon(Icons.person, color: new Color(0xFF483F64))
                        : Container()),

                // User details
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.capitalize() + " " + surname.capitalize(),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 18,
                            fontFamily: "Poppins-Regular",
                            fontWeight: FontWeight.bold)),
                    index == 0
                        ? Text("Best Employee of the month 🎉",
                            style: TextStyle(
                                color: new Color(0xFF190E3B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13))
                        : Container(),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
