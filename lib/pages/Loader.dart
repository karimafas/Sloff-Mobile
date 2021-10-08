import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/pages/HomePage.dart';
import 'package:sloff/services/SloffApi.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';

List loadingPhrases = [
  "Squeezing focus...",
  "Fixing timers...",
  "Swapping seconds for minutes...",
  "Requesting rewards...",
  "Pointing loose hands...",
  "Randomising odds...",
  "Tuning bells..."
];

class Loader extends StatefulWidget {
  const Loader({Key key, this.uuid, this.company}) : super(key: key);

  final String uuid;
  final String company;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  int loadingIndex = 0;
  Timer timer;

  Future<void> initialisation() async {
    Provider.of<TimerNotifier>(context, listen: false)
        .setUserCompany(u: widget.uuid, c: widget.company);

    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    Provider.of<TimerNotifier>(context, listen: false).initialise();

    SloffApi.checkIfUserExists(uuid: widget.uuid, token: token)
        .then((exists) async {
      var user = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uuid)
          .get();

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
                  .individualAvailableFocusMinutes)
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

    Provider.of<TimerNotifier>(context, listen: false)
        .getInitialRanking(widget.uuid);

    await Future.delayed(Duration(seconds: 3));

    pushReplacementWithFade(
        context, HomePage(uuid: widget.uuid, company: widget.company), 500);
  }

  @override
  void initState() {
    super.initState();

    loadingIndex = new Random().nextInt(loadingPhrases.length);

    timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        loadingIndex = new Random().nextInt(loadingPhrases.length);
      });
    });

    initialisation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color(0xFFFFF8ED),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitRotatingCircle(
            color: new Color(0xFF190E3B),
            size: 50.0,
          ),
          Container(height: 50),
          Text(loadingPhrases[loadingIndex],
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
