import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/pages/timer/drawer.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:sloff/components/TimerInfoPage.dart';

int click = 0;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class TimerIOS2 extends StatefulWidget {
  const TimerIOS2({Key key, this.callback, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Timer();
  }

  final Function callback;
  final String name;
}

class _Timer extends State<TimerIOS2>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool animate = false;
  PageController _pageController = new PageController();
  int _currentIndex = 0;
  int timeMinutes = 0;
  int timeSeconds = 0;
  bool isRunning = false;
  String company = '';
  String challenge = '';
  SharedPreferences prefs;
  bool showFocusSaved = false;
  bool showFocusLost = false;
  bool lost = false;
  int focusSavedTime = 0;
  bool swiftTimerStop = false;
  static const platform = const MethodChannel("swiftTimer");
  DateTime swiftStopTime;
  bool focusCompletedSched = false;
  String timerFormattedTime = "";
  String name = '';
  DateTime startTime;
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  Future<void> sendSwiftNotification() async {
    String value = "";
    try {
      value = await platform.invokeMethod("swift-sendNotification");
    } catch (error) {
      print(error);
    }

    if (value == "EXIT-NOTIFICATION") {
      swiftStopTime = DateTime.now();
      print("SWIFTSTOP $swiftStopTime");
      _lostFocusNotificationS(DateTime.now().add(Duration(seconds: 16)));
      flutterLocalNotificationsPlugin.cancel(1);
    }

    print(value);
  }

  bool canWrite() {
    DateTime now = DateTime.now();
    int difference = now.difference(startTime).inSeconds;

    print("difference $difference" +
        ", " +
        (prefs.getInt("timeToRecord") * 60).toString());

    if (difference >= prefs.getInt("timeToRecord") * 60) {
      return true;
    } else {
      return false;
    }
  }

  void _updateLabels(int init, int end, int thirdUnknown) {
    setState(() {
      //inBedTime = init;
      timeSeconds = end * 60;
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fetchInfo();

    company = '6uzGun2h76ULCLJKqO7C6xVQf9';

    WidgetsBinding.instance?.addObserver(this);

    rootBundle.load('assets/images/Home/Bolla_timer.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  fetchInfo() async {
    prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid');

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();

    setState(() {
      if (aa['name'].toString() == '') {
        name = '     ';
      } else {
        name = aa['name'].toString();
        company = aa['company'].toString();
      }
    });
  }

  bool hasBeenInactive = false;

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await flutterLocalNotificationsPlugin.cancel(1);
        await flutterLocalNotificationsPlugin.cancel(2);
        await flutterLocalNotificationsPlugin.cancel(3);

        hasBeenInactive = false;
        focusCompletedSched = false;

        if (Platform.isIOS) {
          if (swiftStopTime != null) {
            if (DateTime.now().difference(swiftStopTime).inSeconds > 15) {
              //stop();
              setState(() {
                showFocusLost = true;
                lost = true;
              });

              swiftStopTime = null;
            }
          }
        }

        int timeToWrite = prefs.getInt("timeToRecord");

        if (prefs.getBool("record") &&
            prefs.getBool("lockscreen") &&
            canWrite()) {
          writeDb(timeToWrite);

          setState(() {
            showFocusSaved = true;
            lost = false;
            focusSavedTime = prefs.getInt("timeToRecord");
          });

          Future.delayed(Duration(seconds: 4), () {
            setState(() {
              showFocusSaved = false;
            });
          });
        }

        if (showFocusLost) {
          setState(() {
            showFocusSaved = true;
            lost = true;
            focusSavedTime = prefs.getInt("timeToRecord");
          });

          Future.delayed(Duration(seconds: 4), () {
            setState(() {
              showFocusSaved = false;
            });
          });
        }

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");

        if (!hasBeenInactive) {
          if (await isLockScreen()) {
            if (isRunning) {
              _instructionsNotification();
            }
          }
          /*  else {
            if (istarted) {
              _warningNotification();
              _lostFocusNotificationS(
                  DateTime.now().add(Duration(seconds: 10)));
              timeExited = DateTime.now();
            }
          }  */

          setState(() async {
            if (!await isLockScreen()) {
              prefs.setBool("lockscreen", false);
            } else {
              prefs.setBool("lockscreen", true);
            }
          });

          hasBeenInactive = true;
        }
        break;
      case AppLifecycleState.paused:
        print("app in paused");

        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  Future _warningNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        "I see you! 👀",
        "Return to Sloff, or your focus will be lost.",
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _instructionsNotification() async {
    int minutes = (timeSeconds / 60).round();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        "Enjoy your $minutes minutes off the screen!",
        "Remember not to use apps, or your focus will be lost. Unlock the screen at any time to see how long you've got left!",
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _saveFocusNotification() async {
    int time = prefs.getInt("timeToRecord");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        "Don't lose your focus!",
        "Return to Sloff and save the $time minutes you spent away from your phone.",
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _showNotificationWithDefaultSound() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Hey ' + name.capitalize() + "!",
        'Go back to Sloff or you will lose your focus.',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _focusCompletedNotificationS(DateTime time) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        "Congrats " + name.capitalize() + "! 🎉",
        "You have completed your focus.",
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _warningNotificationS(DateTime time) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        3,
        "No cheating allowed... 🧐",
        "Return to Sloff, or your focus will be lost.",
        time,
        platformChannelSpecifics,
        payload: 'item x');

    print("SCHEDULED BACKGROUND");
  }

  Future _lostFocusNotificationS(DateTime time) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        2,
        "Sorry! 😕",
        "You've lost your focus. Return to Sloff and start over!",
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }

  void writeDb(int result) async {
    print("Writedb");
    String uuid = prefs.getString('uuid');
    final DocumentSnapshot postRef =
        await FirebaseFirestore.instance.collection('focus').doc(uuid).get();

    final DocumentSnapshot postRef1 = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('challenge')
        .doc(challenge)
        .collection('focus')
        .doc(uuid)
        .get();

    if (postRef.exists) {
      print('1');
      int total = postRef['total'];
      int available = postRef['available'];

      FirebaseFirestore.instance.collection('focus').doc(uuid).update({
        "total": result + total,
        "available": result + available
      }).then((value) async {});
    } else {
      print('2');

      FirebaseFirestore.instance
          .collection('focus')
          .doc(uuid)
          .set({"total": result, "available": result}).then((value) async {});
    }
    if (postRef1.exists) {
      print('3');

      int total = postRef1['total'];
      int available = postRef1['available'];
      print(uuid);
      print(total);
      print(available);

      FirebaseFirestore.instance
          .collection('users_company')
          .doc(company)
          .collection('challenge')
          .doc(challenge)
          .collection('focus')
          .doc(uuid)
          .update({
        "total": result + total,
        "available": result + available
      }).then((value) async {
        prefs.setInt("timeToRecord", 0);
        prefs.setBool("record", false);
      });
    } else {
      print('4');

      FirebaseFirestore.instance
          .collection('users_company')
          .doc(company)
          .collection('challenge')
          .doc(challenge)
          .collection('focus')
          .doc(uuid)
          .set({"total": result, "available": result}).then((value) async {});
    }

    DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    var query = await FirebaseFirestore.instance
        .collection('focus')
        .doc(uuid)
        .collection('daily')
        .doc(dateFormat.format(DateTime.now()))
        .get();

    int focusToday = 0;

    if (query.exists) {
      focusToday = query['focus'];
    }

    FirebaseFirestore.instance
        .collection('focus')
        .doc(uuid)
        .collection('daily')
        .doc(dateFormat.format(DateTime.now()))
        .set({'focus': focusToday + result});
  }

  completedPopup(int result) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                children: [
                  SizedBox(
                      child: Image.asset(
                          'assets/images/Coupon/Thank_you_image.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Text("Completo1".tr(namedArgs: {'name': name.capitalize()}),
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 20,
                          fontFamily: 'GrandSlang',
                          color: new Color(0xFF190E3B)),
                      textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Completo2"
                            .tr(namedArgs: {'minutes': result.toString()}),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 13,
                            fontFamily: 'Poppins-Light',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RectangleButton(
                    onTap: () {
                      Navigator.pop(context);
                      widget.callback();
                    },
                    text: "go-to-rewards".tr(),
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RectangleButton(
                    onTap: () => Navigator.pop(context),
                    text: "skip".tr(),
                    color: new Color(0xFFA4A0B2),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ],
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLifecycleState state;
    return Stack(
      children: [
        Container(color: new Color(0xFFFFF8ED)),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            child:
                /*  animate
                ? AnimatedBackground(
                    animate: animate,
                    duration: toWrite * 60,
                    halfDuration: ((toWrite * 60) / 2).round())
                :  */
                FadeIn(10, Background())),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users_company')
                  .doc(company)
                  .collection('challenge')
                  .where('visible', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                double _dStartTime;
                double _dEndTime;
                double _dStartTime2;
                double _dEndTime2;
                double _dNowTime;

                if (snapshot.data == null) return Container();

                if (snapshot.data.docs.length > 0) {
                  if (snapshot.data.docs[0]['start_time'] != null) {
                    _dStartTime = stringToTimeOfDay(
                                snapshot.data.docs[0]['start_time'])
                            .hour
                            .toDouble() +
                        (stringToTimeOfDay(snapshot.data.docs[0]['start_time'])
                                .minute
                                .toDouble() /
                            60);

                    _dEndTime = stringToTimeOfDay(
                                snapshot.data.docs[0]['end_time'])
                            .hour
                            .toDouble() +
                        (stringToTimeOfDay(snapshot.data.docs[0]['end_time'])
                                .minute
                                .toDouble() /
                            60);

                    _dNowTime = TimeOfDay.now().hour.toDouble() +
                        (TimeOfDay.now().minute.toDouble() / 60);
                  } else {
                    _dStartTime = null;
                    _dEndTime = null;
                  }

                  if (snapshot.data.docs[0]['start_time2'] != null) {
                    _dStartTime2 = stringToTimeOfDay(
                                snapshot.data.docs[0]['start_time2'])
                            .hour
                            .toDouble() +
                        (stringToTimeOfDay(snapshot.data.docs[0]['start_time2'])
                                .minute
                                .toDouble() /
                            60);

                    _dEndTime2 = stringToTimeOfDay(
                                snapshot.data.docs[0]['end_time2'])
                            .hour
                            .toDouble() +
                        (stringToTimeOfDay(snapshot.data.docs[0]['end_time2'])
                                .minute
                                .toDouble() /
                            60);
                  }
                }

                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.data.docs.length > 0 && _dStartTime2 != null
                    ? (DateTime.now().weekday != 6 &&
                            DateTime.now().weekday != 7) &&
                        (_dNowTime != null && _dNowTime > _dEndTime ||
                            _dNowTime != null && _dNowTime < _dStartTime) &&
                        (_dNowTime != null && _dNowTime > _dEndTime2 ||
                            _dNowTime != null && _dNowTime < _dStartTime2)
                    : (DateTime.now().weekday != 6 &&
                            DateTime.now().weekday != 7) &&
                        (_dNowTime != null && _dNowTime > _dEndTime ||
                            _dNowTime != null && _dNowTime < _dStartTime)) {
                  challenge = '';
                  return idleTimer(context, _dStartTime, snapshot);
                } else {
                  if (snapshot.data.docs.length > 0 &&
                      snapshot.data.docs[0]['visible']) {
                    challenge = snapshot.data.docs[0].id;
                  } else {
                    challenge = '';
                  }
                  return Scaffold(
                      endDrawer: DrawerUiWidget(),
                      backgroundColor: Colors.transparent,
                      body: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SlideYFadeInBottom(
                                      0.8,
                                      SizedBox(
                                          child: SvgPicture.asset(
                                              'assets/images/Home/SLOFF_logo.svg'),
                                          height: 50,
                                          width: 125),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 20),
                              SlideYFadeInBottom(
                                0.4,
                                Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    onPageChanged: (index) =>
                                        _currentIndex = index,
                                    controller: _pageController,
                                    children: [
                                      TimerInfoPage(
                                          text1: "Selezionatempo".tr(),
                                          text2: "trascinandobradipo".tr()),
                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: 600),
                                        opacity: _currentIndex == 1 ? 1 : 0,
                                        child: TimerInfoPage(
                                            text1: "Selezionatempo2".tr(),
                                            text2: "trascinandobradipo2".tr()),
                                      ),
                                      TimerInfoPage(
                                          text1: "Selezionatempo3".tr(),
                                          text2: "trascinandobradipo3".tr()),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 20),
                              SlideYFadeInBottom(
                                0.2,
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                        child: Center(
                                      child: SingleCircularSlider(
                                        60,
                                        1,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        baseColor:
                                            Color.fromARGB(100, 219, 219, 219),
                                        selectionColor: new Color(0xFFFF6926),
                                        handlerColor: new Color(0xFFFF6926),
                                        handlerOutterRadius: 13,
                                        onSelectionChange: (a, b, c) => _updateLabels,
                                        sliderStrokeWidth: 12.0,
                                      ),
                                    )),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.55,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Rive(
                                        artboard: _riveArtboard,
                                      ),
                                    ),
                                    SlideYFadeInBottom(
                                      0,
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: CountdownTimer(
                                            endTime: timeSeconds,
                                            widgetBuilder:
                                                (_, CurrentRemainingTime time) {
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Text(
                                                        timeSeconds.toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-Light',
                                                            letterSpacing: 3,
                                                            fontSize: 48,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 80,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOutQuad,
                                  opacity: showFocusSaved ? 1 : 0,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            lost
                                                ? "Your $focusSavedTime minutes of focus weren't saved.\nStart over!"
                                                : "Your $focusSavedTime minutes of focus were saved!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: lost
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.w300)),
                                      ]),
                                ),
                              ),
                              SlideYFadeInBottom(
                                0,
                                challenge != ''
                                    ? !isRunning && timeSeconds > 0
                                        ? GestureDetector(
                                            onTap: () {
                                              //shouldStop = false;
                                              setState(() {
                                                isRunning = true;
                                              });
                                              _pageController.animateToPage(2,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                            },
                                            child: RectangleButton(
                                                color: new Color(0xFFFF6926),
                                                text: ('Inizia')
                                                    .tr()
                                                    .toUpperCase(),
                                                mini: true,
                                                type: 7))
                                        : !isRunning && timeSeconds == 0
                                            ? RectangleButton(
                                                color: Colors.grey,
                                                text: ('Inizia')
                                                    .tr()
                                                    .toUpperCase(),
                                                type: 7,
                                                mini: true)
                                            : GestureDetector(
                                                onTap: () {
                                                  _pageController.animateToPage(
                                                      0,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                                  // stop();
                                                },
                                                child: RectangleButton(
                                                    color:
                                                        new Color(0xFF694EFF),
                                                    text:
                                                        ('Stop').toUpperCase(),
                                                    type: 7,
                                                    mini: true))
                                    : RectangleButton(
                                        color: new Color(0xFFFF6926),
                                        text: ('Inizia').tr().toUpperCase(),
                                        type: 7,
                                        mini: true),
                              ),
                              Container(height: 20)
                            ],
                          )));
                }
              }),
        ),
      ],
    );
  }

  FadeIn idleTimer(
      BuildContext context, double _dStartTime, AsyncSnapshot snapshot) {
    return FadeIn(
      2,
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: SvgPicture.asset(
                                'assets/images/Home/SLOFF_logo.svg'),
                            height: 50,
                            width: 125),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TimerInfoPage(
                          text1: "Mancachallenge".tr(),
                          text2: "Mancachallenge2".tr()),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: AbsorbPointer(
                          child: SingleCircularSlider(
                            60,
                            1,
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: MediaQuery.of(context).size.width * 0.7,
                            baseColor: Color.fromARGB(100, 219, 219, 219),
                            selectionColor: Colors.grey,
                            handlerColor: Colors.grey,
                            handlerOutterRadius: 13,
                            onSelectionChange: null,
                            sliderStrokeWidth: 12.0,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.55,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Rive(
                          artboard: _riveArtboard,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: _dStartTime == null
                                ? Text('00:00',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: 'Poppins-Light',
                                        letterSpacing: 3,
                                        fontSize: 48,
                                        color: Colors.white),
                                    textAlign: TextAlign.center)
                                : Text(
                                    snapshot.data.docs[0]["start_time2"] != null
                                        ? "challenge-hours2".tr(namedArgs: {
                                            "start": snapshot
                                                .data.docs[0]["start_time"]
                                                .toString()
                                                .replaceAll(' ', ''),
                                            "end": snapshot
                                                .data.docs[0]["end_time"]
                                                .toString()
                                                .replaceAll(' ', ''),
                                            "start1": snapshot
                                                .data.docs[0]["start_time2"]
                                                .toString()
                                                .replaceAll(' ', ''),
                                            "end1": snapshot
                                                .data.docs[0]["end_time2"]
                                                .toString()
                                                .replaceAll(' ', '')
                                          })
                                        : "challenge-hours".tr(namedArgs: {
                                            "start": snapshot
                                                .data.docs[0]["start_time"]
                                                .toString()
                                                .replaceAll(' ', ''),
                                            "end": snapshot
                                                .data.docs[0]["end_time"]
                                                .toString()
                                                .replaceAll(' ', ''),
                                          }),
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontFamily: 'Poppins-Light',
                                        fontSize: 14,
                                        color: Colors.white),
                                    textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RectangleButton(
                      color: Colors.grey,
                      text: ('Inizia').tr().toUpperCase(),
                      mini: true,
                      type: 7),
                  Container(height: 20)
                ],
              ))),
    );
  }
}

/* // Start native parallel timers
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      DateTime finishTime = startTime.add(Duration(seconds: toWrite * 60));
      print("FINISHTIME $finishTime");

      if (finishTime.difference(DateTime.now()).isNegative) {
        setState(() {
          swiftTimerStop = true;
        });

        print("SWIFT TIMER STOPPED");
      }

      if (!swiftTimerStop) {
        if (Platform.isIOS) sendSwiftNotification();
        if (outofapp && !focusCompletedSched) {
          _focusCompletedNotificationS(
              DateTime.now().add(Duration(seconds: outBedTime)));

          print("SCHEDULEDFINISH " + outBedTime.toString());
          focusCompletedSched = true;
        }
      }
    }); */
