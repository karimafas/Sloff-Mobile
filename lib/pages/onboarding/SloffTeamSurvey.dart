import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/pages/homepage.dart';

class SloffTeamSurvey extends StatelessWidget {
  const SloffTeamSurvey(
      {Key key, this.company, this.uuid, this.surveyId, this.name})
      : super(key: key);

  final String company;
  final String uuid;
  final String surveyId;
  final String name;

  void writeDb(int answer, BuildContext context) {
    FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("sloff_surveys")
        .doc(surveyId)
        .collection("user_answers")
        .doc(uuid)
        .set({
      "answer": answer,
      "last_answer": DateFormat("dd-MM-yyy").format(DateTime.now())
    }).then((value) {
      pushReplacementWithFade(context, HomeInitialPage(), 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ID$uuid");

    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users_company")
                .doc(company)
                .collection("sloff_surveys")
                .where("active", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.hasError) {
                return Container();
              } else {
                return Stack(
                  children: [
                    Container(color: new Color(0xFF190E3B)),
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 600),
                        child: Background()),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                      child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: 1),
                                Column(
                                  children: [
                                    Text("A QUICK QUESTION",
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 20),
                                    Text(snapshot.data.docs[0]["question"],
                                        style: TextStyle(
                                            fontFamily: 'GrandSlang',
                                            fontSize: 24,
                                            color: Colors.white),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 20),
                                    Text(
                                        "This is an anonymous survey: your employer won't be able to know who answered.",
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                            color: Colors.white),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return RectangleButton(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            color: Colors.white,
                                            textColor: new Color(0xFF190E3B),
                                            text: snapshot.data.docs[0]
                                                ["answers"][index],
                                            onTap: () =>
                                                writeDb(index, context),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container();
                                        },
                                        itemCount: snapshot
                                            .data.docs[0]["answers"].length)),
                                InkWell(
                                  onTap: () {
                                    writeDb(-1, context);
                                  },
                                  child: Stack(
                                    children: [
                                      RectangleButton(
                                          text: "SKIP",
                                          color: Colors.transparent,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                width: 2, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1),
                              ],
                            )),
                      ),
                    )
                  ],
                );
              }
            }));
  }
}

class EmojiAnswer extends StatelessWidget {
  const EmojiAnswer({
    Key key,
    this.image,
    this.text,
    this.onTap,
  }) : super(key: key);
  final String image;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: Image.asset(image), height: 35, width: 35),
                  SizedBox(height: 5),
                  Text(text,
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular', fontSize: 12),
                      textAlign: TextAlign.center),
                ],
              )),
        ],
      ),
    );
  }
}
