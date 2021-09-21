import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:sloff/pages/Challenges.dart';
import 'package:sloff/pages/Timer.dart';
import 'package:sloff/pages/Profile.dart';
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

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  @override
  void initState() {
    super.initState();
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
        Consumer<TimerNotifier>(builder: (context, data, index) {
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child: StreamBuilder<QuerySnapshot>(
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
                      if (snapshot.data.size > 0 &&
                          snapshot.data.docs[0]['group']) {
                        if (snapshot.data.docs[0]['groupFocusMinutes'] >=
                            snapshot.data.docs[0]['total_focus'] * 60) {
                          if (!snapshot.data.docs[0]['written']) {
                            FirebaseFirestore.instance
                                .collection("users_company")
                                .doc(widget.company)
                                .collection("challenge")
                                .doc(snapshot.data.docs[0].reference.id)
                                .update({"written": true})
                                .then((value) => SloffMethods.writeGroupReward(
                                    snapshot.data.docs[0],
                                    widget.company,
                                    widget.uuid))
                                .then((value) {
                                  Provider.of<TimerNotifier>(context,
                                          listen: false)
                                      .getIndividualFocus()
                                      .then((value) {
                                    Provider.of<TimerNotifier>(context,
                                            listen: false)
                                        .loadRedeemedRewards();
                                  });
                                });
                          }

                          if (!snapshot.data.docs[0]['usersWarned']
                                  .contains(widget.uuid) &&
                              Provider.of<TimerNotifier>(context, listen: false)
                                  .userCreationDt
                                  .isBefore(snapshot.data.docs[0]['created_at']
                                      .toDate())) {
                            FirebaseFirestore.instance
                                .collection("users_company")
                                .doc(widget.company)
                                .collection("challenge")
                                .doc(snapshot.data.docs[0].reference.id)
                                .set({
                              "usersWarned":
                                  FieldValue.arrayUnion([widget.uuid])
                            }, SetOptions(merge: true)).then((value) {
                              SloffModals.unlockGroupReward(context,
                                  (goToProfile) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.uuid)
                                    .update({"popupShown": true}).then(
                                        (value) => goToProfile
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
                            width: MediaQuery.of(context).size.width,
                            color: new Color(0xFFFFF8ED),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(color: new Color(0xFFFFF8ED)),
                                Background(),
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                                  child: Container(
                                    child: Scaffold(
                                        resizeToAvoidBottomInset: true,
                                        backgroundColor: Colors.transparent,
                                        bottomNavigationBar:
                                            BottomNavigationBar(
                                          elevation: 0,
                                          selectedItemColor:
                                              new Color(0xFFFF6926),
                                          selectedFontSize: 12,
                                          backgroundColor: Colors.transparent,
                                          onTap: (int index) =>
                                              onBottomNavigationTap(
                                                  context, index),
                                          currentIndex: _currentIndex,
                                          items: <BottomNavigationBarItem>[
                                            BottomNavigationBarItem(
                                                icon: _currentIndex == 0
                                                    ? new SvgPicture.asset(
                                                        'assets/images/Tab_Bar/Home_icon_ON.svg')
                                                    : SvgPicture.asset(
                                                        'assets/images/Tab_Bar/Home_icon.svg'),
                                                label: 'Home'),
                                            BottomNavigationBarItem(
                                              icon: _currentIndex == 1
                                                  ? new SvgPicture.asset(
                                                      'assets/images/Tab_Bar/Reward_icon_ON.svg')
                                                  : SvgPicture.asset(
                                                      'assets/images/Tab_Bar/Reward_icon.svg'),
                                              label: 'Reward',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: _currentIndex == 2
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
                                                const EdgeInsets.only(top: 10),
                                            child: IndexedStack(
                                              index: _currentIndex,
                                              children: <Widget>[
                                                SloffTimer(
                                                    goToRewards: goToRewards,
                                                    uuid: widget.uuid,
                                                    company: widget.company),
                                                Challenge(
                                                    goToProfile: navigateToProfile,
                                                    uuid: widget.uuid,
                                                    company: widget.company),
                                                UserProfile(
                                                    key: firstProfileTap
                                                        ? UniqueKey()
                                                        : null,
                                                    uuid: widget.uuid,
                                                    company: widget.company),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }));
        })
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
