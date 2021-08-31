import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:sloff/components/SloffNotifications.dart';
import 'package:sloff/components/TimerInfoPage.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/pages/FocusSuccess.dart';
import 'package:sloff/services/SloffApi.dart';
import 'package:sloff/services/alarmManager.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';

class SloffTimer extends StatefulWidget {
  SloffTimer({Key key, this.goToRewards, this.uuid, this.company})
      : super(key: key);

  @override
  _SloffTimerState createState() => _SloffTimerState();

  final Function goToRewards;
  final String uuid;
  final String company;
}

class _SloffTimerState extends State<SloffTimer> with WidgetsBindingObserver {
  Timer timer;
  Timer nativeTimer;
  bool cancelNativeTimer = false;
  bool loadingTimer = false;
  int minutesToEnd = 0;
  int secondsToEnd = 0;
  int minutesToWrite = 0;
  Artboard _riveArtboard;
  RiveAnimationController _riveController;
  bool isRunning = false;
  int _currentIndex = 0;
  PageController _pageController = new PageController();
  SharedPreferences prefs;
  String name = "";
  String company = "";
  DateTime exitedTime;
  int exitedSeconds = 0;
  bool setExitedTime = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  DateTime startTime;
  DateTime swiftStopTime;
  bool swiftTimerStop = false;
  static const swiftPlatform = const MethodChannel("swiftTimer");
  bool focusCompletedSched = false;
  bool outsideApp = false;
  bool popupShown = false;
  bool completedNotificationSent = false;
  String uuid;
  int minutesToGroupChallenge = 0;
  String appState = "RESUMED";
  ValueKey<DateTime> forceRebuild;
  var initialRanking;
  var finalRanking;

  void _updateLabels(int init, int end, int laps) {
    if (_currentIndex != 1) {
      _currentIndex = 1;
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    setState(() {
      minutesToEnd = end;
      secondsToEnd = end * 60;
    });
  }

  Future<void> sendSwiftNotification() async {
    String value = "";
    try {
      value = await swiftPlatform.invokeMethod("swift-sendNotification");
    } catch (error) {
      print(error);
    }

    if (value == "EXIT-NOTIFICATION") {
      swiftStopTime = DateTime.now();
      print("SWIFTSTOP $swiftStopTime");

      flutterLocalNotificationsPlugin.cancel(1);

      SloffScheduledNotifications.lostFocusNotification(
          DateTime.now().add(Duration(seconds: 16)),
          flutterLocalNotificationsPlugin);
      flutterLocalNotificationsPlugin.cancel(1);
    }
  }

  bool canWrite() {
    DateTime now = DateTime.now();

    if (now.isAfter(startTime.add(Duration(seconds: minutesToWrite * 60)))) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> getAndroidWarning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.reload();

    bool warning = prefs.getBool("androidWarning");

    return warning;
  }

  static Future<void> alarmCallback() async {
    getAndroidWarning().then((androidWarning) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (!await isLockScreen() && !androidWarning) {
        NotificationManager n = new NotificationManager();
        n.initNotificationManager();
        n.warningNotification();
        n.lostFocusNotification(DateTime.now().add(Duration(seconds: 15)));

        prefs.setInt("androidStopTime", DateTime.now().millisecondsSinceEpoch);
        prefs.setBool("androidWarning", true);
      }
    });

    print('Alarm fired @' + DateTime.now().toString());
  }

  void runAlarm() async {
    await AndroidAlarmManager.periodic(
      Duration(minutes: 1),
      0,
      alarmCallback,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

  void resetSharedPrefs() {
    prefs.setInt("timeToRecord", 0);
    prefs.setBool("timeRecorded", false);
    prefs.setBool("lockscreen", false);
    prefs.setInt("androidStopTime", 0);
    prefs.setBool("androidWarning", false);
    prefs.setBool("focusCompleted", true);
  }

  Future<void> start() async {
    resetSharedPrefs();

    minutesToWrite = minutesToEnd;
    prefs.setInt("timeToRecord", minutesToWrite);

    startTime = DateTime.now();

    if (_currentIndex != 2) {
      _currentIndex = 2;
      _pageController.animateToPage(2,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    setState(() {
      isRunning = true;
    });

    // Start main timer
    timer = new Timer.periodic(Duration(seconds: 1), (timer) async {
      if (secondsToEnd > 0) {
        setState(() {
          secondsToEnd -= 1;
          forceRebuild = ValueKey(DateTime.now());
        });
      } else {
        secondsToEnd = 0;
      }

      if (secondsToEnd == 0) {
        writeDb(minutesToWrite);
        stop(false, true);
        prefs.setBool("timeRecorded", true);
      }
    });

    // Start native parallel timers
    nativeTimer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (DateTime.now()
              .difference(startTime.add(Duration(minutes: minutesToWrite)))
              .inMilliseconds >
          0) {
        setState(() {
          cancelNativeTimer = true;
        });
      } else {
        setState(() {
          cancelNativeTimer = false;
        });
      }

      if (!cancelNativeTimer) {
        if (DateTime.now().isBefore(
            startTime.add(Duration(seconds: (minutesToEnd * 60) - 16)))) {
          if (Platform.isIOS) sendSwiftNotification();
        }

        if (isRunning && await isLockScreen()) {
          SloffScheduledNotifications.focusCompletedNotification(
              DateTime.now().add(Duration(seconds: secondsToEnd)),
              name,
              flutterLocalNotificationsPlugin);
          completedNotificationSent = true;
        }
      }
    });
  }

  stop(bool userInitiated, bool successful) {
    if (_currentIndex != 0) {
      _currentIndex = 0;
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    Future.delayed(Duration(milliseconds: 500), () {
      if (!userInitiated) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (!successful) {
            SloffModals.focusLost(context, prefs.getInt("timeToRecord"), name,
                widget.goToRewards);
          } else if (successful) {
            pushWithFade(
                context,
                FocusSuccess(
                    company: widget.company,
                    uuid: widget.uuid,
                    minutes: minutesToWrite,
                    initialRanking: int.parse(initialRanking),
                    finalRanking: int.parse(finalRanking),
                    name: name),
                500);
            /* SloffModals.focusCompleted(context, minutesToWrite, name,
                widget.goToRewards, widget.company); */
          }
        });
      }
    });

    setState(() {
      isRunning = false;
      minutesToEnd = 0;
      secondsToEnd = 0;
      forceRebuild = ValueKey(DateTime.now());
    });

    timer.cancel();
    setState(() {
      cancelNativeTimer = true;
      loadingTimer = false;
    });

    swiftStopTime = null;
    flutterLocalNotificationsPlugin.cancel(1);
  }

  fetchInfo() async {
    prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid');

    resetSharedPrefs();

    DocumentSnapshot query =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();
    print('doc ' + query.toString());

    setState(() {
      if (query['name'].toString() == '') {
        name = '';
      } else {
        name = query['name'];
        company = query['company'];
      }
    });
  }

  Future<void> writeDb(int minutes) async {
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    initialRanking = await SloffApi.findRanking(uuid: uuid, token: token);

    // Update the user focus
    FirebaseFirestore.instance.collection("focus").doc(uuid).update({
      "available": FieldValue.increment(minutes),
      "total": FieldValue.increment(minutes)
    });

    DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    var dateQuery = await FirebaseFirestore.instance
        .collection("focus")
        .doc(uuid)
        .collection("daily")
        .doc(dateFormat.format(DateTime.now()))
        .get();

    if (dateQuery.exists) {
      FirebaseFirestore.instance
          .collection("focus")
          .doc(uuid)
          .collection("daily")
          .doc(dateFormat.format(DateTime.now()))
          .update({"focus": FieldValue.increment(minutes)});
    } else {
      FirebaseFirestore.instance
          .collection("focus")
          .doc(uuid)
          .collection("daily")
          .doc(dateFormat.format(DateTime.now()))
          .set({"focus": FieldValue.increment(minutes)});
    }

    // Update stats used to populate user progression charts on Sloff Panel
    var today = DateFormat("dd-MM-yyyy").format(DateTime.now());

    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(widget.company)
        .collection("focus_stats")
        .doc(today)
        .get();

    if (query.exists) {
      FirebaseFirestore.instance
          .collection("users_company")
          .doc(widget.company)
          .collection("focus_stats")
          .doc(today)
          .update({"focus": FieldValue.increment(minutes)});
    } else {
      FirebaseFirestore.instance
          .collection("users_company")
          .doc(widget.company)
          .collection("focus_stats")
          .doc(today)
          .set({"focus": minutes});
    }

    // Add or update user chart data, fetched through the API
    await SloffApi.increaseFocus(uuid, minutes, token);

    finalRanking = await SloffApi.findRanking(uuid: uuid, token: token);

    await Provider.of<TimerNotifier>(context, listen: false).getGroupFocus();
    await Provider.of<TimerNotifier>(context, listen: false)
        .getIndividualFocus(token);
    Provider.of<TimerNotifier>(context, listen: false)
        .setRanking(int.parse(initialRanking), int.parse(finalRanking));

    // If there is a group challenge, update the document containing group focus
    var groupChallenge =
        await SloffMethods.isThereGroupChallenge(widget.company);

    if (groupChallenge) {
      var challenge = await FirebaseFirestore.instance
          .collection('users_company')
          .doc(widget.company)
          .collection('challenge')
          .where("visible", isEqualTo: true)
          .get();

        FirebaseFirestore.instance
            .collection('users_company')
            .doc(widget.company)
            .collection('challenge')
            .doc(challenge.docs[0].reference.id)
            .set({
          "groupFocusMinutes": FieldValue.increment(minutes)
        }, SetOptions(merge: true));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // RESUMED
    if (state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed');

      appState = "RESUMED";
      outsideApp = false;
      await prefs.reload();

      // Handle Android out of app notification operations
      await prefs.setBool("androidWarning", false);
      int tAndroidStopTime = prefs.getInt("androidStopTime");
      DateTime androidStopTime = DateTime.fromMillisecondsSinceEpoch(
          (prefs.getInt('androidStopTime') ??
              DateTime.now().millisecondsSinceEpoch));

      NotificationManager n = new NotificationManager();
      n.initNotificationManager();
      n.cancelLostFocusNotification();

      if (isRunning) {
        setState(() {
          loadingTimer = true;
        });
      }

      /* if (secondsToEnd < 1) {
        setState(() {
          secondsToEnd = 0;
          minutesToEnd = 0;
        });
      } */

      // Cancel any scheduled notifications
      if (Platform.isAndroid) AndroidAlarmManager.cancel(0);
      await flutterLocalNotificationsPlugin.cancel(1);
      await flutterLocalNotificationsPlugin.cancel(2);
      await flutterLocalNotificationsPlugin.cancel(3);
      completedNotificationSent = false;

      // Recover any time lost outside the app
      if (isRunning) {
        setState(() {
          int secondsLost = DateTime.now().difference(exitedTime).inSeconds;
          print("SECONDSLOST $secondsLost");
          secondsToEnd = exitedSeconds - secondsLost;
          setExitedTime = false;
        });
      }

      // Save focus if user exited the app after the timer stopped
      /* if (!prefs.getBool("timeRecorded") &&
          prefs.getBool("lockscreen") &&
          canWrite()) {
        print("RECORDTIME");
        if (Platform.isIOS && swiftStopTime == null) {
          writeDb(prefs.getInt("timeToRecord"));
          prefs.setBool("timeRecorded", true);
          prefs.setBool("focusCompleted", false);
          prefs.setBool("lockscreen", false);
        } else if (Platform.isAndroid && tAndroidStopTime == 0) {
          writeDb(prefs.getInt("timeToRecord"));
          prefs.setBool("timeRecorded", true);
          prefs.setBool("focusCompleted", false);
          prefs.setBool("lockscreen", false);
        }
      } else {
        prefs.setBool("lockscreen", false);
      } */

      await Future.delayed(Duration(milliseconds: 500));

      // IOS: handle out of app penalties
      if (Platform.isIOS) {
        if (swiftStopTime != null) {
          if (DateTime.now().difference(swiftStopTime).inSeconds > 15) {
            stop(false, false);

            nativeTimer.cancel();
            swiftStopTime = null;
          } else {
            swiftStopTime = null;
          }
        }
      }

      // Android: handle out of app penalties
      if (Platform.isAndroid) {
        if (tAndroidStopTime != 0) {
          if (DateTime.now().difference(androidStopTime).inSeconds > 15) {
            stop(false, false);

            nativeTimer.cancel();
          } else {
            prefs.setInt("androidStopTime", 0);
          }
        }
      }

      if (isRunning) {
        setState(() {
          loadingTimer = false;
        });
      }
    }

    // PAUSED
    if (state == AppLifecycleState.paused) {
      appState = "PAUSED";
      print('AppLifecycleState state: Paused');

      outsideApp = true;
    }

    // INACTIVE
    if (state == AppLifecycleState.inactive) {
      appState = "INACTIVE";
      print('AppLifecycleState state: Inactive');

      if (isRunning) {
        SloffScheduledNotifications.focusCompletedNotification(
            DateTime.now().add(Duration(seconds: secondsToEnd)),
            name,
            flutterLocalNotificationsPlugin);
        completedNotificationSent = true;

        if (Platform.isAndroid) {
          runAlarm();

          if (!await isLockScreen()) {
            SloffScheduledNotifications.warningNotification(
                DateTime.now().add(Duration(seconds: 5)),
                flutterLocalNotificationsPlugin);
            SloffScheduledNotifications.lostFocusNotification(
                DateTime.now().add(Duration(seconds: 16)),
                flutterLocalNotificationsPlugin);
            prefs.setInt(
                "androidStopTime", DateTime.now().millisecondsSinceEpoch);
            prefs.setBool("androidWarning", true);
          }
        }

        if (!setExitedTime) {
          exitedTime = DateTime.now();
          print("EXITEDTIME $exitedTime");
          exitedSeconds = secondsToEnd;
          setExitedTime = true;
        }
      }

      setState(() async {
        if (await isLockScreen()) {
          outsideApp = true;
        } else {
          outsideApp = true;
        }
      });

      if (isRunning && await isLockScreen()) {
        SloffNotifications.instructionsNotification(
            secondsToEnd, flutterLocalNotificationsPlugin);
      }
    }
    print('AppLifecycleState state:  $state');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    rootBundle.load('assets/images/Home/Bolla_timer.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard
            .addController(_riveController = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );

    fetchInfo();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => _currentIndex = index,
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
                  Container(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _riveArtboard != null
                          ? Container(
                              height: MediaQuery.of(context).size.width * 0.55,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Rive(
                                artboard: _riveArtboard,
                              ),
                            )
                          : Container(),
                      Container(
                        key: forceRebuild,
                        child: IgnorePointer(
                          ignoring: isRunning ? true : false,
                          child: SingleCircularSlider(
                            60,
                            !isRunning
                                ? 1
                                : (secondsToEnd / 60).round() < 1
                                    ? 1
                                    : (secondsToEnd / 60).round(),
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: MediaQuery.of(context).size.width * 0.7,
                            baseColor: Color.fromARGB(100, 219, 219, 219),
                            selectionColor: new Color(0xFFFF6926),
                            handlerColor: new Color(0xFFFF6926),
                            handlerOutterRadius: 13,
                            onSelectionChange: _updateLabels,
                            sliderStrokeWidth: 12.0,
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 1000),
                        child: loadingTimer
                            ? Text(
                                DateFormat('mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        exitedSeconds * 1000)),
                                style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    letterSpacing: 3,
                                    fontSize: 48,
                                    color: Colors.white.withOpacity(.4)),
                              )
                            : Text(
                                DateFormat('mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        secondsToEnd * 1000)),
                                style: TextStyle(
                                    fontFamily: 'Poppins-Light',
                                    letterSpacing: 3,
                                    fontSize: 48,
                                    color: Colors.white),
                              ),
                      ),
                    ],
                  )),
                  RectangleButton(
                      onTap: minutesToEnd > 0
                          ? isRunning
                              ? () => stop(true, null)
                              : () => start()
                          : () {},
                      /* () => FirebaseAuth.instance.currentUser
                              .getIdToken()
                              .then((token) => SloffApi.getCompanyGroupFocus(
                                  companyID: widget.company, token: token)), */
                      /* () => pushWithFade(
                              context,
                              FocusSuccess(
                                  company: widget.company,
                                  uuid: widget.uuid,
                                  minutes: 0),
                              0), */
                      color: !isRunning
                          ? new Color(0xFFFF6926)
                          : new Color(0xFF694EFF),
                      text: !isRunning ? ('Inizia').tr().toUpperCase() : "STOP",
                      mini: true,
                      type: 7)
                ],
              ),
            ))
      ],
    );
  }
}
