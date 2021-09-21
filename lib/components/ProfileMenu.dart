import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/pages/PreLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerUiWidget extends StatelessWidget {
  const DrawerUiWidget({
    Key key,
    this.company,
  }) : super(key: key);

  final String company;

  @override
  Widget build(BuildContext context) {
    Future<void> sendEmail() async {
      final Email email = Email(
        body: "",
        subject: "bug-subject".tr(),
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(platformResponse),
        ),
      );
    }

    return SizedBox(
      child: Drawer(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: new Color(0xFFFFF8ED),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
                  child: Row(
                    children: [
                      Text("Menu",
                          style: TextStyle(
                              fontSize: 22,
                              color: new Color(0xFF190E3B),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-Regular')),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.only(right: 30.0, left: 40.0, top: 10),
                        child: ListView(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                String subject = "bug-subject".tr();
                                final Uri params = Uri(
                                  scheme: 'mailto',
                                  path: 'karim.afas@sloff.app',
                                  query: 'subject=$subject&body=',
                                );

                                var url = params.toString();
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SvgPicture.asset(
                                          'assets/images/Menu/Problem.svg'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Segnala'.tr() + ' ',
                                        style: TextStyle(
                                            color: new Color(0xFF190E3B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  var query = await FirebaseFirestore.instance
                                      .collection("privacy")
                                      .doc("privacy")
                                      .get();

                                  String url = query["url"];

                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    throw "Could not launch $url";
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.asset(
                                            'assets/images/Menu/Privacy_policy.svg'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Privacy'.tr() + ' ',
                                          style: TextStyle(
                                              color: new Color(0xFF190E3B),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                                  ],
                                )),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('uuid');
                                  FirebaseAuth.instance.signOut();

                                  FirebaseMessaging.instance
                                      .unsubscribeFromTopic(company);

                                  pushReplacementWithFade(
                                      context, PreLogin(), 500);
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: SvgPicture.asset(
                                            'assets/images/Menu/Log_out.svg'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Esci'.tr() + ' ',
                                          style: TextStyle(
                                              color: new Color(0xFF190E3B),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                                  ],
                                )),
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
