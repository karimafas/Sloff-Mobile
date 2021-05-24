import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/main.dart';
import 'package:sloff/pages/SignUp.dart';
import 'package:sloff/pages/onboarding/Onboarding.dart';
import 'package:toast/toast.dart';
import 'package:sloff/pages/homepage.dart';
import 'package:sloff/pages/welcome/welcome.dart';

import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:sloff/components/rectangle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/pages/cambiocausa.dart';
import 'package:sloff/global.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sloff/pages/login.dart';

class PreLogin extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const PreLogin({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  _PreLogin createState() => _PreLogin();
}

class _PreLogin extends State<PreLogin> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected = Colors.blue;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  int _currentIndex = 0;
  CarouselController _carouselController = new CarouselController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _offsetFloat = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _offsetFloat.addListener(() {
      setState(() {});
    });
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  Future<GoogleSignInAccount> getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

/*  void _getSignedInAccount() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
        if (user != null) {
          QuerySnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .where("email", isEqualTo: user.user.email)
              .get();
          if (doc.docs.length == 0) {
            Toast.show(
                "Il tuo indirizzo email non è collegato a nessuna azienda",
                context);
          } else {
            if (doc.docs[0].get('last_login') == '') {
              String uuid = doc.docs[0].id;
              String company = doc.docs[0].get('company');
              print('TEST ENTER');
              FirebaseFirestore.instance.collection('users').doc(uuid).update({
                "last_login": DateTime.now().millisecondsSinceEpoch,
                "last_app_usage": DateTime.now().millisecondsSinceEpoch,
              }).then((value) async {
                FirebaseFirestore.instance.collection('focus').doc(uuid).set({
                  "total": 0,
                  "available": 0,
                }).then((value) async {
                  FirebaseFirestore.instance
                      .collection('users_company')
                      .doc(company)
                      .collection('focus')
                      .doc(uuid)
                      .set({
                    "total": 0,
                    "available": 0,
                  }).then((value) async {
                    FirebaseFirestore.instance
                        .collection('users_company')
                        .doc(company)
                        .collection('users')
                        .doc(uuid)
                        .update({
                      "last_login": DateTime.now().millisecondsSinceEpoch,
                      "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                      "uuid": uuid
                    }).then((value) async {
                      if (true) {
                        //sharedPref.setBool('isFirst', true);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('uuid', uuid);
                        await prefs.setString('company', company);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Welcome(
                                utente: user.user.displayName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      }
                    });
                  });
                });
              });
            } else {
              String uuid = doc.docs[0].id;
              String company = doc.docs[0].get('company');
              print('TEST ENTER');
              final DocumentReference postRef =
                  FirebaseFirestore.instance.collection('users').doc(uuid);
              if (postRef != null) {
                print("Getting post reference////// ${postRef.path}");
                postRef.update({
                  "last_login": DateTime.now().millisecondsSinceEpoch,
                  "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                  "version": Global.version,
                }).then((value) async {
                  FirebaseFirestore.instance
                      .collection('users_company')
                      .doc(company)
                      .collection('users')
                      .doc(uuid)
                      .update({
                    "last_login": DateTime.now().millisecondsSinceEpoch,
                    "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                  }).then((value) async {
                    final sharedPref = await setSharedPref();

                    ///sharedPref.setBool(
                    // AppStateModel.IS_AUDIO_BOOK_LOGIN, true);
                    //sharedPref.setString(
                    //  AppStateModel.LOGGED_IN_USER_ID, user.user.uid);
                    if (true) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('uuid', uuid);
                      await prefs.setString('company', company);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                HomeInitialPage(),
                          ),
                          (Route<dynamic> route) => false);
                    }
                  });
                });
              } else {}
            }
          }
        }
      });
    }
  }*/

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color(0xffbef00),
      Color(0xff10eb50),
      Color(0xff08b9ff),
      Color(0xff0f80ff),
      Color(0xff9e06db),
      Color(0xffff0f5f),
      Color(0xffFF7E05),
      Color(0xffFAFA19)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 250.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(color: new Color(0xFFFFF8ED)),
          Background(page: 1),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(height: 20)
                  ],
                ),
                SlideYFadeInBottom(
                  0.5, SizedBox(
                      height: 35,
                      child: SvgPicture.asset(
                          'assets/images/Home/SLOFF_logo.svg')),
                ),
                Container(height: 10),
                SlideYFadeIn(
                  1, SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            print(index);
                            _currentIndex = index;
                          });
                        },
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 16/9,
                      ),
                      items: [
                        InfoPage(title: "welcome-1".tr(), text: "welcome-1_2".tr()),
                        InfoPage(title: "welcome-2".tr(), text: "welcome-2_2".tr()),
                        InfoPage(title: "welcome-3".tr(), text: "welcome-3_2".tr()),
                        InfoPage(title: "welcome-4".tr(), text: "welcome-4_2".tr())
                      ],
                    ),
                  ),
                ),
                FadeIn(
                  1.5, DotsIndicator(
                    dotsCount: 4,
                    position: _currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      activeColor: new Color(0xFFFF6926),
                      color: new Color(0xFFFFDFAD),
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp1(email: "")));
                        },
                        child: RectangleButton(
                          color: new Color(0xFF694EFF),
                          width: 350,
                            text: ('registrati').tr().toUpperCase(),
                            mini: true,
                            type: 6)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Container(
                          height: 54,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.transparent,
                            border: Border.all(color: new Color(0xFF190E3B), width: 2),
                          ),
                          child: Center(
                            child: Text("accedi".tr().toUpperCase(), textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w600,
                                color: new Color(0xFF190E3B),
                                fontSize: 15,
                              ),),
                          ),
                        )),
                  ],
                ),
                GestureDetector(onTap: () {}, child: Container()),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({
    Key key, this.title, this.text,
  }) : super(key: key);
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontSize: 33,
                  fontFamily: 'GrandSlang'),
              textAlign: TextAlign.center),
          Container(height: 20),
          Text(text,
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontSize: 13,
                  fontFamily: 'Poppins-Light'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
