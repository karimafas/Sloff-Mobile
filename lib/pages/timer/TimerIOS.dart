import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/AnimatedBackground.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/pages/timer/drawer.dart';
import 'dart:async' as asy;
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'dart:isolate';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class TimerIOS extends StatefulWidget {
  const TimerIOS({Key key, this.callback, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Timer();
  }

  final Function callback;
  final String name;
}

class _Timer extends State<TimerIOS>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool animate = false;
  int duration = 0;
  PageController _pageController = new PageController();
  int _currentIndex = 0;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ValueKey<DateTime> forceRebuild;
  int initTime = 0;
  int endTime = 60;
  int towrite = 0;
  int firstsec = 1;
  int blocktimer;
  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  DateTime sleep;
  int totaltimer = 0;
  int blockedtotaltimer = 0;

  int inBedTime = 0;
  int outBedTime = 0;
  int seconds = 0;

  int position = 1;
  bool checkcontrol = true;
  bool outofapp = false;
  bool first = true;
  bool istarted = false;
  AnimationController _controllertext;
  Animation<Offset> _offsetFloat;
  String company = '';
  String challenge = '';
  SharedPreferences prefs;

  asy.Timer _timer;
  int _start;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    company = '6uzGun2h76ULCLJKqO7C6xVQf9';

    fetchInfo();

    _controllertext = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetFloat = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(3.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controllertext,
        curve: Curves.ease,
      ),
    );
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    Future.wait([
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/images/Home/Terra.svg'),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/images/Accedi/SLOFF.svg'),
        null,
      ),
      // other SVGs or images here
    ]);

    rootBundle.load('assets/images/Home/Bolla_timer.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );

    //precacheImage(new AssetImage('assets/images/Home/Terra.svg'), context);
  }

  String name = '';

  fetchInfo() async {
    // _togglePlay();

    prefs = await SharedPreferences.getInstance();
    String uuid = await prefs.getString('uuid');
    //print('fetchname');

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();
    //print('doc ' + aa.toString());
    String cc = prefs.getString('company');

    setState(() {
      //print('nn' + aa['name']);
      //print('cc' + aa['company']);

      if (aa['name'].toString() == '') {
        name = '     ';
        //company ='6uzGun2h76ULCLJKqO7C6xVQf9w2';
      } else {
        name = aa['name'].toString();
        company = aa['company'].toString();
        //company ='6uzGun2h76ULCLJKqO7C6xVQf9w2';

      }
      //print('ilname' + name);
    });
  }

  bool hasBeenInactive = false;

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    /*if (state == AppLifecycleState.inactive) {
      print('app inactive, is lock screenDID DEP: ${await isLockScreen()}');
    }*/
    switch (state) {
      case AppLifecycleState.resumed:
        //print("app in resumed");
        int started = await prefs.getInt('started');
        DateTime startedtime = new DateTime.fromMillisecondsSinceEpoch(started);
        final DateTime dateTimeNow = new DateTime.now();
        /* Duration remainingTime = dateTimeNow.difference(startedtime);
        if(istarted){
          print('TIME: '+remainingTime.inSeconds.toString());
          //totaltimer=blocktimer-remainingTime.inSeconds;
          //if(remainingTime.inSeconds-blockedtotaltimer>0)
          totaltimer = blockedtotaltimer-remainingTime.inSeconds;
        }*/

        setState(() {
          final DateTime dateTimeNow = new DateTime.now();
          Duration remainingTime = dateTimeNow.difference(startedtime);
          if (istarted) {
            //print('TIME: ' + remainingTime.inSeconds.toString());
            //totaltimer=blocktimer-remainingTime.inSeconds;
            //if(remainingTime.inSeconds-blockedtotaltimer>0)
            totaltimer = blockedtotaltimer - remainingTime.inSeconds;
          }
          outofapp = false;
          hasBeenInactive = false;
        });
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        if (!hasBeenInactive) {
          setState(() async {
            sleep = new DateTime.now();
            blocktimer = totaltimer;
            if (!await isLockScreen()) {
              outofapp = true;
            } else {
              outofapp = false;
            }
            hasBeenInactive = true;
          });
        }
        break;
      case AppLifecycleState.paused:
        //print("app in paused");
        setState(() async {
          sleep = new DateTime.now();
          blocktimer = totaltimer;
          if (!await isLockScreen()) {
            outofapp = true;
          } else {
            outofapp = false;
          }
        });
        break;
      case AppLifecycleState.detached:
        //print("app in detached");
        break;
    }
  }

  void _shuffle() {
    setState(() {
      position = 15;
      initTime = 0;
      endTime = 60;
      inBedTime = initTime;
      outBedTime = endTime;
    });
  }

  void stop() async {
    await flutterLocalNotificationsPlugin.cancel(1);
    if (_isolate != null) {
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
    await _timer.cancel();
    setState(() {
      totaltimer = 0;
      outBedTime = 0;
      istarted = false;
      position = 1;
      firstsec = 1;
      animate = false;

      Random r = new Random();
      int rr = r.nextInt(10000);

      forceRebuild = new ValueKey(DateTime.now().add(Duration(days: rr)));
    });
  }

  void _updateLabels(int init, int end, int aa) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });

    if (!istarted && _currentIndex != 1) {
      _currentIndex = 1;
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  Future _finishedNotification() async {
    //print('Showit!!!!!!!!!!!!!!!!!!');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
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
        'Sorry!',
        "You've lost your focus. Go back to Sloff to start again!",
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _showNotificationWithDefaultSound() async {
    print('Showit!!!!!!!!!!!!!!!!!!');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
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

  Future _focusCompletedNotification() async {
    print('Showit!!!!!!!!!!!!!!!!!!');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
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
        'Congrats, ' + name.capitalize() + '!',
        'You have completed your focus.',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future _showNotificationWithDefaultSoundscheduled(DateTime time) async {
    print('Showit!!!!!!!!!!!!!!!!!!');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
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
        'Congrats ' + name.capitalize() + '!',
        'You have completed your focus.',
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }

  void checklockscreen(AppLifecycleState state) async {
    //print('app inactive, is lock screen: ${await isLockScreen()}');
    bool check = await isLockScreen();
    setState(() {
      checkcontrol = check;
    });
  }

  void writeDb(int result) async {
    print('WRITE?');
    String uuid = await prefs.getString('uuid');
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
      }).then((value) async {});
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

    var query = await FirebaseFirestore.instance.collection('focus')
        .doc(uuid)
        .collection('daily')
        .doc(dateFormat.format(DateTime.now())).get();

    int focusToday = 0;

    if(query.exists){
      focusToday = query['focus'];
    }

    FirebaseFirestore.instance.collection('focus')
        .doc(uuid)
        .collection('daily')
        .doc(dateFormat.format(DateTime.now())).set({
      'focus': focusToday + result
    });
  }

  void _startTim(int sec, AppLifecycleState state) async {
    Map map = {
      'port': _receivePort.sendPort,
      'initial_duration': sec,
    };

    _isolate =
        await Isolate.spawn(startTimer(sec, state, map), _receivePort.sendPort);
    _receivePort.sendPort.send(sec);
  }

  showpop(int result) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              //height: MediaQuery.of(context).size.height * 0.6,
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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  showpopfail() {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('RewardTimertitlefail'.tr()),
      content: Text('RewardTimerfail'.tr()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  startTimer(int secnumb, AppLifecycleState state, Map map) async {
    //print('Minuti' + secnumb.toString());
    setState(() {
      first = true;
      istarted = true;
      towrite = outBedTime;
      duration = outBedTime;
    });
    await _controllertext.forward();

    var sec = secnumb % 60;
    super.didChangeAppLifecycleState(state);
    totaltimer = outBedTime * 60;
    blockedtotaltimer = outBedTime * 60;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showNotificationWithDefaultSoundscheduled(
        DateTime.now().add(Duration(seconds: totaltimer)));
    await prefs.setInt('started', DateTime.now().millisecondsSinceEpoch);
    //print('TIM' + totaltimer.toString());
    /*if (state == AppLifecycleState.inactive) {
       print('app inactive, is lock screen: ${await isLockScreen()}');
    }*/
    //print('app inactive, is lock screen: ${await isLockScreen()}');

    var oneSec = Duration(seconds: 1);
    bool check = true;
    int diecisec = 10;
    SendPort port = map['port'];
    _timer = new asy.Timer.periodic(
      oneSec,
      (asy.Timer timer) => setState(
        () {
          port.send(timer.tick);
          checklockscreen(state);
          if (outofapp) {
            if (first) {
              first = false;
              print('NEED TO CANCEL');
              stop();
              _finishedNotification();
              print("FINITO");
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            }
            /*if (diecisec < 1) {
              print('cancella');
              istarted = false;
              towrite = 0;
              firstsec = 1;
              stop();
              _finishedNotification();
              //showpopfail();
            } else {
              print('aspetta');
              diecisec = diecisec - 1;
            }*/
          }
          /*else if (outofapp && !first) {
            print('cancella subito');
            first = true;
            stop();
            _finishedNotification();
            towrite = 0;
            firstsec = 1;
            //showpopfail();

          }*/

          if (totaltimer < 1) {
            istarted = false;
            //timer.cancel();
            //_focusCompletedNotification();
            stop();
            position = 1;
            //print(towrite);
            writeDb(towrite);
            firstsec = 1;
            showpop(towrite);
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          } else {
            firstsec = firstsec - 1;
            Random r = new Random();
            int rr = r.nextInt(10000);

            forceRebuild = new ValueKey(DateTime.now().add(Duration(days: rr)));
            totaltimer = totaltimer - 1;
            outBedTime = totaltimer.ceil();
            position = (totaltimer / 60).ceil();
          }
        },
      ),
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
              child: animate
                  ? AnimatedBackground(
                      animate: animate,
                      duration: duration * 60,
                      halfDuration: ((duration * 60) / 2).round())
                  : FadeIn(10, Background())),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users_company')
                    .doc(company)
                    .collection('challenge')
                    .where('elapsed_time', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: (context, snapshot) {
                  double _dStartTime;
                  double _dEndTime;
                  double _dStartTime2;
                  double _dEndTime2;
                  double _dNowTime;

                  if(snapshot.data == null) return Container();


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

                      _dNowTime = TimeOfDay.now().hour.toDouble() +
                          (TimeOfDay.now().minute.toDouble() / 60);
                    }
                  }

                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.docs.length == 0 ||
                      (_dNowTime != null && _dNowTime > _dEndTime ||
                              _dNowTime != null && _dNowTime < _dStartTime) &&
                          (_dNowTime != null && _dNowTime > _dEndTime2 ||
                              _dNowTime != null && _dNowTime < _dStartTime2)) {
                    challenge = '';
                    return IdleTimer(context, _dStartTime, snapshot);
                  } else {
                    if (snapshot.data.docs.length > 0 &&
                        snapshot.data.docs[0]['visible']) {
                      challenge = snapshot.data.docs[0].id;
                      //return Container(child:Text('challenge'));
                    } else {
                      challenge = '';
                    }
                    return Scaffold(
                        key: _drawerKey,
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
                                        0.8, SizedBox(
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
                                  0.4, Container(
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    child: PageView(
                                      physics: NeverScrollableScrollPhysics(),
                                      onPageChanged: (index) =>
                                          _currentIndex = index,
                                      controller: _pageController,
                                      children: [
                                        Page(
                                            text1: "Selezionatempo".tr(),
                                            text2: "trascinandobradipo".tr()),
                                        AnimatedOpacity(
                                          duration: Duration(milliseconds: 600),
                                          opacity: _currentIndex == 1 ? 1 : 0,
                                          child: Page(
                                              text1: "Selezionatempo2".tr(),
                                              text2: "trascinandobradipo2".tr()),
                                        ),
                                        Page(
                                            text1: "Selezionatempo3".tr(),
                                            text2: "trascinandobradipo3".tr()),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(height: 20),
                                SlideYFadeInBottom(
                                  0.2, Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                          key: forceRebuild,
                                          child: Center(
                                            child: SingleCircularSlider(
                                              60,
                                              position,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              baseColor: Color.fromARGB(
                                                  100, 219, 219, 219),
                                              selectionColor: new Color(0xFFFF6926),
                                              handlerColor: new Color(0xFFFF6926),
                                              handlerOutterRadius: 13,
                                              onSelectionChange: _updateLabels,
                                              sliderStrokeWidth: 12.0,
                                            ),
                                          )),
                                      istarted
                                          ? Center(
                                              child: Container(
                                              height: 261,
                                              width: 261,
                                              color: Colors.transparent,
                                            ))
                                          : Container(),
                                      Container(
                                        height: MediaQuery.of(context).size.width *
                                            0.55,
                                        width: MediaQuery.of(context).size.width *
                                            0.55,
                                        child: Rive(
                                          artboard: _riveArtboard,
                                        ),
                                      ),
                                      SlideYFadeInBottom(
                                        0, Container(
                                            padding:
                                                EdgeInsets.symmetric(vertical: 10),
                                            child: CountdownTimer(
                                              endTime: outBedTime,
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
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.45,
                                                      child: Text(
                                                          !istarted
                                                              ? '${_formatTime(outBedTime)}'
                                                              : '${_formatTime(outBedTime)}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-Light',
                                                              letterSpacing: 3,
                                                              fontSize: 48,
                                                              color: Colors.white),
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
                                SizedBox(height: 60),
                                SlideYFadeInBottom(
                                  0, challenge != ''
                                      ? !istarted && outBedTime > 0
                                          ? GestureDetector(
                                              onTap: () {
                                                //shouldStop = false;
                                                setState(() {
                                                  istarted = true;
                                                  animate = true;
                                                });
                                                _pageController.animateToPage(2,
                                                    duration:
                                                        Duration(milliseconds: 500),
                                                    curve: Curves.ease);
                                                _startTim(
                                                    _formatTimeint(outBedTime),
                                                    state);
                                              },
                                              child: RectangleButton(
                                                  color: new Color(0xFFFF6926),
                                                  text:
                                                      ('Inizia').tr().toUpperCase(),
                                                  mini: true,
                                                  type: 7))
                                          : !istarted && outBedTime == 0
                                              ? RectangleButton(
                                                  color: Colors.grey,
                                                  text:
                                                      ('Inizia').tr().toUpperCase(),
                                                  type: 7,
                                                  mini: true)
                                              : GestureDetector(
                                                  onTap: () {
                                                    _pageController.animateToPage(0,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        curve: Curves.ease);
                                                    stop();
                                                  },
                                                  child: RectangleButton(
                                                      color: new Color(0xFF694EFF),
                                                      text: ('Stop').toUpperCase(),
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

  FadeIn IdleTimer(
      BuildContext context, double _dStartTime, AsyncSnapshot snapshot) {
    return FadeIn(
      2, Scaffold(
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
                        /*SizedBox(
                                        child: SvgPicture.asset(
                                            'assets/images/Home/Notifiche.svg'),
                                        height: 30,
                                        width: 30),*/
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Page(
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
                            position,
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
                                    "challenge-hours".tr(namedArgs: {
                                      "start": snapshot.data.docs[0]["start_time"]
                                          .toString()
                                          .replaceAll(' ', ''),
                                      "end": snapshot.data.docs[0]["end_time"]
                                          .toString()
                                          .replaceAll(' ', ''),
                                      "start1": snapshot
                                          .data.docs[0]["start_time2"]
                                          .toString()
                                          .replaceAll(' ', ''),
                                      "end1": snapshot.data.docs[0]["end_time2"]
                                          .toString()
                                          .replaceAll(' ', '')
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

  Widget _formatBedTime(String pre, int time) {
    return Column(
      children: [
        Text(pre, style: TextStyle(color: Colors.blue)),
        Text('BED AT', style: TextStyle(color: Colors.blue)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  String _formatTime(int time) {
    if (time == 0 || time == null) {
      return '00:00';
    }
    var hours = time ~/ 60;
    var minutes = (time % 60);
    var seconds = (time % 360);
    final now = Duration(seconds: time);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(now.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(now.inSeconds.remainder(60));
    if (firstsec != 1) {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitSeconds:00';
    }
  }

  int _formatTimeint(int time) {
    if (time == 0 || time == null) {
      return 0;
    }
    var hours = time ~/ 60;
    var minutes = (time % 60);
    var seconds = (minutes % 60);

    return minutes;
  }

  int _generateRandomTime() => Random().nextInt(288);
}

class Page extends StatelessWidget {
  const Page({
    Key key,
    this.text1,
    this.text2,
  }) : super(key: key);
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInRTL(
      0,
      Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(text1,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: new Color(0xFF190E3B)))),
          Container(
            height: 2,
          ),
          Container(
              child: Text(text2,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: new Color(0xFF190E3B)))),
        ],
      ),
    );
  }
}
