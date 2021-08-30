import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/pages/HomePage.dart';

class EmojiSurvey extends StatelessWidget {
  const EmojiSurvey({Key key, this.company, this.uuid, this.name, this.surveyId})
      : super(key: key);

  final String company;
  final String uuid;
  final String name;
  final String surveyId;

  void writeDb(int answer, BuildContext context) {
    FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("surveys")
        .doc(surveyId)
        .collection("user_answers")
        .doc(uuid)
        .set({
      DateFormat("dd-MM-yyy").format(DateTime.now()): answer,
      "last_answer": DateFormat("dd-MM-yyy").format(DateTime.now())
    });

    pushReplacementWithFade(context, HomePage(uuid: uuid, company: company), 500);
  }

  @override
  Widget build(BuildContext context) {
    print("ID$uuid");

    return Scaffold(
        body: Stack(
      children: [
        Container(color: new Color(0xFFFFF8ED)),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 600), child: Background()),
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
                      Text("Good morning $name, how are you feeling today?",
                          style:
                              TextStyle(fontFamily: 'GrandSlang', fontSize: 24),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Text(
                          "This is an anonymous survey: your employer won't be able to know who answered.",
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular', fontSize: 12),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: GridView.count(
                      padding: EdgeInsets.all(40),
                      crossAxisCount: 3,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      children: <Widget>[
                        EmojiAnswer(
                            text: "Happy",
                            image: "assets/images/Emoji/happy.png",
                            onTap: () => writeDb(0, context)),
                        EmojiAnswer(
                            text: "Excited",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(1, context)),
                        EmojiAnswer(
                            text: "Grateful",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(2, context)),
                        EmojiAnswer(
                            text: "Relaxed",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(3, context)),
                        EmojiAnswer(
                            text: "Content",
                            image: "assets/images/Emoji/smiley.png",
                            onTap: () => writeDb(4, context)),
                        EmojiAnswer(
                            text: "Tired",
                            image: "assets/images/Emoji/sleepy.png",
                            onTap: () => writeDb(5, context)),
                        EmojiAnswer(
                            text: "Unsure",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(6, context)),
                        EmojiAnswer(
                            text: "Bored",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(7, context)),
                        EmojiAnswer(
                            text: "Anxious",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(8, context)),
                        EmojiAnswer(
                            text: "Angry",
                            image: "assets/images/Emoji/angry.png",
                            onTap: () => writeDb(9, context)),
                        EmojiAnswer(
                            text: "Stressed",
                            image: "assets/images/Emoji/winky.png",
                            onTap: () => writeDb(10, context)),
                        EmojiAnswer(
                            text: "Sad",
                            image: "assets/images/Emoji/disappointed.png",
                            onTap: () => writeDb(11, context)),
                      ],
                    ),
                  ),
                  RectangleButton(
                    text: "SKIP",
                    color: new Color(0xFFA4A0B2),
                    width: MediaQuery.of(context).size.width * 0.8,
                    onTap: () => writeDb(-1, context),
                  ),
                  SizedBox(height: 1),
                ],
              ),
            ),
          ),
        )
      ],
    ));
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
