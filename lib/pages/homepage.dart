import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/main.dart';
import 'package:sloff/pages/coupon/challenge.dart';
import 'package:sloff/pages/timer/TimerAndroid.dart';
import 'package:sloff/pages/timer/TimerIOS.dart';
import 'package:sloff/pages/profile/profile.dart';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({Key key, this.analytics}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeInitialPageState();
  }

  final FirebaseAnalytics analytics;
}

class JosKeys {
  static final josKeys1 = const Key('__JosKey1__');
  static final josKeys2 = const Key('__JosKey2__');
  static final josKeys3 = const Key('__JosKey3__');
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  final _scaffoldKeys = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  Future<String> _check() async {
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Coupon/Coupon_da_riscattare.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Coupon/Coupon_grigio.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Coupon/Riscatta_coupon.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Coupon/Sloff_Coupon_finiti.svg'),
      context,
    );

    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/Freccia_detox.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia.svg'),
      context,
    );
    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia_attivo.svg'), context,);
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/SLOFF_logo.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/Sloth_detox.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/Stop.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Home/Terra.svg'),
      context,
    );

    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/menu/Privacy_policy.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/On_boarding/Sloff_img1.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/On_boarding/Sloff_img2.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/On_boarding/Sloff_img3.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Torta.svg'),
      context,
    );

    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Profilo/Copia.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Profilo/Coupon_aperto.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Profilo/Coupon_aperto_linea.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Profilo/Coupon_da_utilizzare.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Home_icon.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Tab_Bar/Home_icon_ON.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Profilo_ON.svg'),
      context,
    );
  }

  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'id',
                'name',
                'description',
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    _check();
  }

  goToRewards() {
    setState(() {
      _currentIndex = 1;
    });
  }

  congratsPopUp() {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              //height: MediaQuery.of(context).size.height * 0.53,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child: Image.asset(
                          'assets/images/Coupon/Reward_compliment.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("congrats".tr(),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 23,
                            fontFamily: 'GrandSlang',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("use-card".tr(),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular'),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RectangleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "awesome".tr().toUpperCase(),
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ));

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  goToProfile() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _currentIndex = 2;
      });
    });

    Future.delayed(Duration(milliseconds: 500), () {
      congratsPopUp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: new Color(0xFFFFF8ED),
      child: SlideYFadeIn(
        1,
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          key: _scaffoldKeys,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedItemColor: Colors.black,
            backgroundColor: Colors.transparent,
            onTap: (int index) => onBottomNavigationTap(context, index),
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? new SvgPicture.asset(
                        'assets/images/Tab_Bar/Home_icon_ON.svg')
                    : SvgPicture.asset('assets/images/Tab_Bar/Home_icon.svg'),
                title: Text(
                  'Home',
                  style: TextStyle(
                      color: _currentIndex == 0
                          ? new Color(0xFFFF6926)
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
              ),
              BottomNavigationBarItem(
                //icon: Icon(Icons.zoom_out),
                icon: _currentIndex == 1
                    ? new SvgPicture.asset(
                        'assets/images/Tab_Bar/Reward_icon_ON.svg')
                    : SvgPicture.asset('assets/images/Tab_Bar/Reward_icon.svg'),

                title: Text(
                  'Reward',
                  style: TextStyle(
                    color: _currentIndex == 1
                        ? new Color(0xFFFF6926)
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                //icon: Icon(Icons.person_outline),
                icon: _currentIndex == 2
                    ? SvgPicture.asset(
                        'assets/images/Tab_Bar/Profile_icon_ON.svg')
                    : SvgPicture.asset(
                        'assets/images/Tab_Bar/Profile_icon.svg'),

                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: _currentIndex == 2
                        ? new Color(0xFFFF6926)
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  TimerIOS(callback: goToRewards),
                  /*Platform.isIOS
                      ? TimerIOS(callback: goToRewards)
                      : Platform.isAndroid
                          ? TimerAndroid(callback: goToRewards)
                          : Container(),*/
                  Challenge(goToProfile: goToProfile),
                  Profile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBottomNavigationTap(BuildContext context, int index) {
    /*if (index == 0) {
      widget.analytics.logEvent(name: 'nav_homePage');
      print("Sent");
    }
    if (index == 1) {
      widget.analytics.logEvent(name: 'nav_rewards');
    }
    if (index == 2) {
      widget.analytics.logEvent(name: 'nav_profile');
    }*/
      if (_currentIndex != index)
      {
        setState(() {
          _currentIndex = index;
        });
      }
  }
}
