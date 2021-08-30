import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/pages/FocusSuccess.dart';
import 'package:sloff/pages/HomePage.dart';
import 'package:sloff/pages/EmojiSurvey.dart';
import 'package:sloff/pages/RegularSurvey.dart';
import 'package:sloff/pages/SloffTeamSurvey.dart';
import 'package:sloff/pages/PreLogin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key,
    this.uuid,
    this.company,
    this.analytics,
  }) : super(key: key);

  final FirebaseAnalytics analytics;

  @override
  _SplashScreenState createState() => _SplashScreenState();
  final String uuid;
  final String company;
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  Future<String> checkSurvey;
  String name;
  bool dailySurvey = false;
  bool sloffSurvey = false;

  Future<String> needSurvey() async {
    bool thereIsSurvey = false;
    String surveyId;

    var query = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(widget.company)
        .collection('surveys')
        .where('active', isEqualTo: true)
        .get();

    var sloffquery = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(widget.company)
        .collection('sloff_surveys')
        .where('active', isEqualTo: true)
        .get();

    List surveys = query.docs;
    List sloffSurveys = sloffquery.docs;

    if (surveys.length > 0) {
      thereIsSurvey = true;
    }

    if (surveys[0]["type"] == 0) {
      print("EMOJI SURVEY");
      setState(() {
        dailySurvey = true;
      });
      surveyId = surveys[0].reference.id;
    } else {
      print("REGULAR SURVEY");
      dailySurvey = false;
      surveyId = surveys[0].reference.id;
    }

    String outcome;

    if (widget.uuid != null) {
      if (thereIsSurvey != false) {
        if (dailySurvey) {
          var check = await FirebaseFirestore.instance
              .collection("users_company")
              .doc(widget.company)
              .collection("surveys")
              .doc(surveyId)
              .collection("user_answers")
              .doc(widget.uuid)
              .get();

          if (check.exists) {
            if (check["last_answer"] !=
                DateFormat("dd-MM-yyyy").format(DateTime.now())) {
              outcome = surveyId;
            } else {
              outcome = null;
            }
          } else {
            sloffSurvey = false;
            outcome = surveyId;
          }
        } else {
          print("surveyID$surveyId");
          var check1 = await FirebaseFirestore.instance
              .collection("users_company")
              .doc(widget.company)
              .collection("surveys")
              .doc(surveyId)
              .collection("user_answers")
              .doc(widget.uuid)
              .get();

          if (!check1.exists) {
            outcome = surveyId;
          } else {
            if (sloffSurveys.length > 0) {
              var query = await FirebaseFirestore.instance
                  .collection("users_company")
                  .doc(widget.company)
                  .collection("sloff_surveys")
                  .where("active", isEqualTo: true)
                  .get();

              surveyId = query.docs[0].reference.id;

              var check1 = await FirebaseFirestore.instance
                  .collection("users_company")
                  .doc(widget.company)
                  .collection("sloff_surveys")
                  .doc(surveyId)
                  .collection("user_answers")
                  .doc(widget.uuid)
                  .get();

              if (!check1.exists) {
                sloffSurvey = true;
                outcome = surveyId;
              } else {
                outcome = null;
              }
            } else {
              outcome = null;
            }
          }
        }
      } else {
        outcome = null;
      }
    }

    DocumentSnapshot aa = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uuid)
        .get();

    name = aa["name"];

    return outcome;
  }

  @override
  void initState() {
    super.initState();

    checkSurvey = needSurvey();

    Future.delayed(Duration(milliseconds: 1800), () {
      setState(() {
        animate = true;
      });
    });

    Future.delayed(Duration(milliseconds: 5000), () {
      setState(() {
        pushWithFade(
            context,
            widget.uuid == null
                ? PreLogin()
                : FutureBuilder(
                    future: checkSurvey,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return HomePage(
                            uuid: widget.uuid,
                            company: widget.company);
                      }
                      if (snapshot.hasError) {
                        return Container(color: Colors.red);
                      } else {
                        if (snapshot.data != null) {
                          if (dailySurvey) {
                            return EmojiSurvey(
                              uuid: widget.uuid,
                              company: widget.company,
                              name: name,
                              surveyId: snapshot.data,
                            );
                          } else {
                            return sloffSurvey == false
                                ? RegularSurvey(
                                    uuid: widget.uuid,
                                    company: widget.company,
                                    surveyId: snapshot.data,
                                    name: name)
                                : SloffTeamSurvey(
                                    uuid: widget.uuid,
                                    company: widget.company,
                                    surveyId: snapshot.data,
                                    name: name);
                          }
                        } else {
                          return HomePage(
                              uuid: widget.uuid, company: widget.company);
                        }
                      }
                    }),
            800);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: new Color(0xFF190E3B),
        child: Stack(
          children: [
            FadeIn(
              3,
              Container(
                child: Transform.scale(
                  scale: 1.5,
                  child: Opacity(
                    opacity: 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SlideFadeIn(
                          3,
                          Column(
                            children: [
                              AnimatedContainer(
                                curve: Curves.easeInOutQuart,
                                height: !animate
                                    ? MediaQuery.of(context).size.height * 0.6
                                    : MediaQuery.of(context).size.height * 0.20,
                                duration: Duration(milliseconds: 1200),
                              ),
                              SvgPicture.asset(
                                  'assets/images/Splash_screen/blurred_violet.svg',
                                  fit: BoxFit.contain,
                                  width: 230),
                            ],
                          ),
                        ),
                        SlideFadeInRTL(
                          3,
                          Column(
                            children: [
                              AnimatedContainer(
                                curve: Curves.easeInOutQuart,
                                height: !animate
                                    ? MediaQuery.of(context).size.height * 0.20
                                    : MediaQuery.of(context).size.height * 0.6,
                                duration: Duration(milliseconds: 1200),
                              ),
                              SvgPicture.asset(
                                  'assets/images/Home/orange_blurred.svg',
                                  fit: BoxFit.contain,
                                  width: 150),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  child: FadeInSlow(
                      0.5,
                      SvgPicture.asset('assets/images/Home/SLOFF_logo.svg',
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ));
  }
}
