import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:sloff/pages/Challenges.dart';
import 'package:sloff/pages/Timer.dart';
import 'package:sloff/pages/Profile.dart';
import 'package:sloff/services/SloffApi.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.uuid, this.company, this.totalGroupFocus})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

  //final FirebaseAnalytics analytics;
  final String uuid;
  final String company;
  final int totalGroupFocus;
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool groupWritten = false;
  bool firstProfileTap = true;
  Future initialisation;
  String token;
  int groupFocusMinutes = 0;
  DateTime userCreated;

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  Future<bool> initialise() async {
    token = await FirebaseAuth.instance.currentUser.getIdToken();

    SloffApi.checkIfUserExists(uuid: widget.uuid, token: token)
        .then((exists) async {
      var user = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uuid)
          .get();

      userCreated = DateTime.fromMillisecondsSinceEpoch(user['created_date']);

      if (!exists) {
        SloffApi.createUser(
            token: token,
            uuid: widget.uuid,
            firstName: user["name"],
            lastName: user["surname"],
            email: user["email"],
            companyID: user["company"],
            profilePicture: user["profile_picture"],
            os: Platform.operatingSystem +
                " - " +
                Platform.operatingSystemVersion);

        SloffApi.createFocus(widget.uuid, 0, token);
      } else {
        SloffApi.updateUser(
            uuid: widget.uuid,
            token: token,
            body: jsonEncode({
              "last_app_usage": DateTime.now().toLocal().toString(),
              "profile_picture": user["profile_picture"],
              "os": Platform.operatingSystem +
                  " - " +
                  Platform.operatingSystemVersion,
            }));
      }

      var currentUser = await SloffApi.getFocus(widget.uuid, token);

      if (currentUser == "NULL") {
        await SloffApi.createFocus(widget.uuid, 0, token);
      }
    });

    var currentUser = await SloffApi.getFocus(widget.uuid, token);

    if (currentUser == "NULL") {
      await SloffApi.createFocus(widget.uuid, 0, token);
    }

    /* groupFocusMinutes =
        await SloffApi.getCompanyGroupFocus(companyID: widget.company); */

    await Provider.of<TimerNotifier>(context, listen: false)
        .getIndividualFocus(token);

    /* await Provider.of<TimerNotifier>(context, listen: false)
        .getGroupRequiredMinutes(); */

    var groupChallenge =
        await SloffMethods.isThereGroupChallenge(widget.company);

    if (groupChallenge) {
      var challenge = await FirebaseFirestore.instance
          .collection('users_company')
          .doc(widget.company)
          .collection('challenge')
          .where("visible", isEqualTo: true)
          .get();

      var usersFocusAdded = challenge.docs[0]['usersFocusAdded'];

      if (!usersFocusAdded.contains(widget.uuid)) {
        FirebaseFirestore.instance
            .collection('users_company')
            .doc(widget.company)
            .collection('challenge')
            .doc(challenge.docs[0].reference.id)
            .set({
          "groupFocusMinutes": FieldValue.increment(
              Provider.of<TimerNotifier>(context, listen: false)
                  .individualFocusMinutes)
        }, SetOptions(merge: true)).then((value) {
          FirebaseFirestore.instance
              .collection('users_company')
              .doc(widget.company)
              .collection('challenge')
              .doc(challenge.docs[0].reference.id)
              .set({
            "usersFocusAdded": FieldValue.arrayUnion([widget.uuid])
          }, SetOptions(merge: true));
        });
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    initialisation = initialise();
  }

  goToRewards() {
    setState(() {
      _currentIndex = 1;
    });
  }

  goToProfile() {
    firstProfileTap = false;

    Future.delayed(Duration(milliseconds: 500), () {
      SloffModals.congratsPopUp(context);
    });
  }

  navigateToProfile() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _currentIndex = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialise group challenge popups
    return Stack(
      children: [
        Container(
          color: new Color(0xFFFFF8ED),
        ),
        FutureBuilder(
            future: initialisation,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: new Color(0xFFFFF8ED),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  color: new Color(0xFFFFF8ED),
                );
              } else {
                return Consumer<TimerNotifier>(builder: (context, data, index) {
                  return WillPopScope(
                      onWillPop: () => Future.value(false),
                      child:
                          /* StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("user_uuid", isEqualTo: widget.uuid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          } else if (!snapshot.hasData) {
                            return Container();
                          } else {
                            bool popupShown = false;
                
                            if (!popupShown) {
                              if (snapshot.data.docs.length > 0) {
                                Future.delayed(Duration(seconds: 1), () {
                                  if (snapshot.data.docs[0]["popupShown"] != null) {
                                    if (!snapshot.data.docs[0]["popupShown"]) {
                                      SloffModals.unlockGroupReward(context,
                                          (goToProfile) {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.uuid)
                                            .update({"popupShown": true}).then(
                                                (value) => goToProfile
                                                    ? navigateToProfile()
                                                    : () {});
                
                                        popupShown = true;
                                      });
                                    }
                                  }
                                });
                              }
                            }
                          } 
                
                          return*/
                          /* StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("focus")
                                  .where("company", isEqualTo: widget.company)
                                  .snapshots(),
                              builder: (context, focusMintuesSnapshot) {
                                if (!focusMintuesSnapshot.hasData) {
                                  return Container(
                                    color: new Color(0xFFFFF8ED),
                                  );
                                } else if (focusMintuesSnapshot.hasError) {
                                  return Container(
                                    color: new Color(0xFFFFF8ED),
                                  );
                                } else {
                                  int groupFocusMinutes = 10;
                
                                  /* if (!focusMintuesSnapshot.hasData) {
                                  groupFocusMinutes = 0;
                                } else if (focusMintuesSnapshot.hasError) {
                                  groupFocusMinutes = 0;
                                } else {
                                  List docs = focusMintuesSnapshot.data.docs;
                
                                  Future.forEach(docs, (element) {
                                    groupFocusMinutes += element["available"];
                                  });
                                } */
                
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("users_company")
                                          .doc(widget.company)
                                          .collection("challenge")
                                          .where("visible", isEqualTo: true)
                                          .snapshots(),
                                      builder: (context, challengeTypeSnapshot) {
                                        bool isGroupChallenge;
                                        int totalChallengeFocus;
                
                                        if (!challengeTypeSnapshot.hasData) {
                                          isGroupChallenge = null;
                                          totalChallengeFocus = null;
                                        } else if (challengeTypeSnapshot.hasError) {
                                          isGroupChallenge = null;
                                          totalChallengeFocus = null;
                                        } else if (challengeTypeSnapshot
                                                .data.docs.length >
                                            0) {
                                          isGroupChallenge = challengeTypeSnapshot
                                                  .data.docs[0]["group"]
                                              ? true
                                              : false;
                
                                          totalChallengeFocus = challengeTypeSnapshot
                                                  .data.docs[0]["total_focus"] *
                                              60;
                
                                          if (isGroupChallenge &&
                                              groupFocusMinutes >=
                                                  totalChallengeFocus) {
                                            print("group challenge completed");
                
                                            if (!groupWritten) {
                                              SloffMethods.getCompanyUserIds(
                                                          widget.company)
                                                      .then((userIds) {
                                                Future.forEach(userIds, (user) {
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(user)
                                                      .update({"popupShown": false});
                                                });
                                              }).then((value) {
                                                SloffMethods
                                                        .getCurrentActiveChallenge(
                                                            widget.company)
                                                    .then((document) {
                                                  SloffMethods.writeGroupReward(
                                                      document,
                                                      widget.company,
                                                      widget.uuid);
                                                });
                                              }) /* .then((value) {
                                                SloffMethods.sendNotification(
                                                    "Well done! 🎉",
                                                    "You and your team have just earned a group reward. Tap to find out more!",
                                                    widget.company);
                                              }) */
                                                  ;
                
                                              groupWritten = true;
                                            }
                
                                            Future.delayed(Duration(seconds: 5), () {
                                              groupWritten = false;
                                            });
                                          }
                                        }
                                        
                                      });
                                }
                              })  */ /* ;
                        }), */

                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users_company")
                                  .doc(widget.company)
                                  .collection("challenge")
                                  .where("visible", isEqualTo: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return Container();
                                } else {
                                  print(userCreated);
                                  print(snapshot.data.docs[0]['created_at']
                                      .toDate());
                                  if (snapshot.data.size > 0 &&
                                      snapshot.data.docs[0]['group']) {
                                    if (snapshot.data.docs[0]
                                            ['groupFocusMinutes'] >=
                                        snapshot.data.docs[0]['total_focus'] *
                                            60) {
                                      if (!snapshot.data.docs[0]['written']) {
                                        FirebaseFirestore.instance
                                            .collection("users_company")
                                            .doc(widget.company)
                                            .collection("challenge")
                                            .doc(snapshot
                                                .data.docs[0].reference.id)
                                            .update({"written": true}).then(
                                                (value) => SloffMethods
                                                    .writeGroupReward(
                                                        snapshot.data.docs[0],
                                                        widget.company,
                                                        widget.uuid));

                                        Provider.of<TimerNotifier>(context,
                                                listen: false)
                                            .getIndividualFocus(token);
                                      }

                                      if (!snapshot.data.docs[0]['usersWarned']
                                              .contains(widget.uuid) &&
                                          userCreated.isBefore(snapshot
                                              .data.docs[0]['created_at']
                                              .toDate())) {
                                        FirebaseFirestore.instance
                                            .collection("users_company")
                                            .doc(widget.company)
                                            .collection("challenge")
                                            .doc(snapshot
                                                .data.docs[0].reference.id)
                                            .set({
                                          "usersWarned": FieldValue.arrayUnion(
                                              [widget.uuid])
                                        }, SetOptions(merge: true)).then(
                                                (value) {
                                          SloffModals.unlockGroupReward(context,
                                              (goToProfile) {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.uuid)
                                                .update({
                                              "popupShown": true
                                            }).then((value) => goToProfile
                                                    ? navigateToProfile()
                                                    : () {});
                                          });
                                        });
                                      }
                                    }
                                  }

                                  return Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: new Color(0xFFFFF8ED),
                                        child: SlideYFadeIn(
                                          3,
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                  color: new Color(0xFFFFF8ED)),
                                              Background(),
                                              BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 70, sigmaY: 70),
                                                child: Container(
                                                  child: Scaffold(
                                                      resizeToAvoidBottomInset:
                                                          true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      bottomNavigationBar:
                                                          BottomNavigationBar(
                                                        elevation: 0,
                                                        selectedItemColor:
                                                            new Color(
                                                                0xFFFF6926),
                                                        selectedFontSize: 12,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        onTap: (int index) =>
                                                            onBottomNavigationTap(
                                                                context, index),
                                                        currentIndex:
                                                            _currentIndex,
                                                        items: <
                                                            BottomNavigationBarItem>[
                                                          BottomNavigationBarItem(
                                                              icon: _currentIndex ==
                                                                      0
                                                                  ? new SvgPicture
                                                                          .asset(
                                                                      'assets/images/Tab_Bar/Home_icon_ON.svg')
                                                                  : SvgPicture
                                                                      .asset(
                                                                          'assets/images/Tab_Bar/Home_icon.svg'),
                                                              label: 'Home'),
                                                          BottomNavigationBarItem(
                                                            icon: _currentIndex ==
                                                                    1
                                                                ? new SvgPicture
                                                                        .asset(
                                                                    'assets/images/Tab_Bar/Reward_icon_ON.svg')
                                                                : SvgPicture.asset(
                                                                    'assets/images/Tab_Bar/Reward_icon.svg'),
                                                            label: 'Reward',
                                                          ),
                                                          BottomNavigationBarItem(
                                                            icon: _currentIndex ==
                                                                    2
                                                                ? SvgPicture.asset(
                                                                    'assets/images/Tab_Bar/Profile_icon_ON.svg')
                                                                : SvgPicture.asset(
                                                                    'assets/images/Tab_Bar/Profile_icon.svg'),
                                                            label: 'Profile',
                                                          ),
                                                        ],
                                                      ),
                                                      body: SafeArea(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: IndexedStack(
                                                            index:
                                                                _currentIndex,
                                                            children: <Widget>[
                                                              SloffTimer(
                                                                  goToRewards:
                                                                      goToRewards,
                                                                  uuid: widget
                                                                      .uuid,
                                                                  company: widget
                                                                      .company),
                                                              Challenge(
                                                                  goToProfile:
                                                                      goToProfile,
                                                                  uuid: widget
                                                                      .uuid,
                                                                  company: widget
                                                                      .company),
                                                              UserProfile(
                                                                  key: firstProfileTap
                                                                      ? UniqueKey()
                                                                      : null,
                                                                  uuid: widget
                                                                      .uuid,
                                                                  company: widget
                                                                      .company),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }));
                });
              }
            }),
      ],
    );
  }

  void onBottomNavigationTap(BuildContext context, int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }

    if (_currentIndex == 2) {
      firstProfileTap = false;
    }
  }
}
