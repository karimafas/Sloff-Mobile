import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/pages/prelogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

const _mailto = 'mailto:<karim.afas@sloff.app>?subject=<Problema%20Sloff (app)>&body=<Descrivi%20il%20bug%20riscontrato.>';

class DrawerUiWidget extends StatelessWidget {
  const DrawerUiWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      child: Drawer(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: new Color(0xFFFFF8ED),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
                  child: Row(
                    children: [
                      Text("Menu", style: TextStyle(fontSize: 22, color: new Color(0xFF190E3B), fontWeight: FontWeight.bold, fontFamily: 'Poppins-Regular')),
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
                                await canLaunch(_mailto) ? await launch(_mailto) : throw 'Could not launch $_mailto';
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
                                          'assets/images/Menu/Problem.svg'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            //2
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
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
                                  final GoogleSignIn googleSignIn =
                                      await GoogleSignIn();
                                  googleSignIn.signOut();

                                  pushReplacementWithFade(context, PreLogin(), 500);
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
