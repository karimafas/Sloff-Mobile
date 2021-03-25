import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/pages/timer/drawer.dart';
import 'dart:async' as asy;
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:isolate';

class Timer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Timer();
  }
}
class _Timer extends State<Timer> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ValueKey<DateTime> forceRebuild;
  int initTime = 0;
  int endTime= 60;
  int towrite= 0;
  int firstsec = 1;
  int blocktimer;
  Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  DateTime sleep;
  int totaltimer =0;
  int blockedtotaltimer=0;


  int inBedTime =0;
  int outBedTime=0;
  int seconds=0;

  int position = 1;
  bool checkcontrol=true;
  bool outofapp = false;
  bool first = true;
  bool istarted = false;
  AnimationController _controllertext;
  Animation<Offset> _offsetFloat;
  String company='';
  String challenge='';
  SharedPreferences prefs;



  asy.Timer _timer;
  int _start;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    company ='6uzGun2h76ULCLJKqO7C6xVQf9';

    fetchname();

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
    WidgetsBinding.instance.addObserver(this);

    rootBundle.load('assets/images/earth (1).riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Untitled 1'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    Future.wait([
      precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Terra.svg'),
        null,
      ),
      precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/SLOFF.svg'),
        null,
      ),
      // other SVGs or images here
    ]);


    //precacheImage(new AssetImage('assets/images/Home/Terra.svg'), context);

  }

  String name = '';
  fetchname() async {
   // _togglePlay();

     prefs = await SharedPreferences.getInstance();
    String uuid = await prefs.getString('uuid');
    print('fetchname');

    DocumentSnapshot aa =  await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid).get();
    print('doc '+aa.toString());
    String cc = prefs.getString('company');


    setState(() {
      print('nn'+aa['name']);
      print('cc'+aa['company']);

      if(aa['name'].toString()==''){
        name = '     ';
        //company ='6uzGun2h76ULCLJKqO7C6xVQf9w2';
      }else{
        name = aa['name'].toString();
        company =aa['company'].toString();
        //company ='6uzGun2h76ULCLJKqO7C6xVQf9w2';


      }
      print('ilname' +name);

    });

  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      print('app inactive, is lock screenDID DEP: ${await isLockScreen()}');
    }
    switch(state){
      case AppLifecycleState.resumed:
        print("app in resumed");
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
          if(istarted){
            print('TIME: '+remainingTime.inSeconds.toString());
          //totaltimer=blocktimer-remainingTime.inSeconds;
            //if(remainingTime.inSeconds-blockedtotaltimer>0)
            totaltimer = blockedtotaltimer-remainingTime.inSeconds;
          }
          outofapp=false;

        });
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        setState(() async{
          sleep = new DateTime.now();
          blocktimer=totaltimer;
          if(!await isLockScreen()){
            outofapp=true;

          }else{
            outofapp=false;

          }
        });
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        setState(() async{
          sleep = new DateTime.now();
          blocktimer=totaltimer;
          if(!await isLockScreen()){
            outofapp=true;
          }else{
            outofapp=false;
          }
        });
        break;
      case AppLifecycleState.detached:
        print("app in detached");
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

  void stop() async{
    await flutterLocalNotificationsPlugin.cancel(1);
    if (_isolate != null) {
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
    await _timer.cancel();
    setState(() {
      totaltimer=0;
      outBedTime=0;
      istarted=false;
      position=1;
      firstsec=1;

      Random r = new Random();
      int rr = r.nextInt(10000);

      forceRebuild = new ValueKey(DateTime.now().add(Duration(days: rr)));
    });
  }

  void _updateLabelsss(int init, int end, int aa) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });
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
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true,);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Ciao '+name+' torna su sloff o blocca', 'lo schermo per non perdere il tuo focus!', platformChannelSpecifics,
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
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true,);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        1, 'Ciao '+name+' hai completato ', 'il tuo focus!', time, platformChannelSpecifics,
        payload: 'item x');
  }


   void checklockscreen(AppLifecycleState state) async{
    //print('app inactive, is lock screen: ${await isLockScreen()}');
    bool check = await isLockScreen();
    setState(() {
      checkcontrol = check;
    });


  }
  void writeDb(int result) async{
    print('WRITE?');
    String uuid = await prefs.getString('uuid');
    final DocumentSnapshot postRef =
    await FirebaseFirestore.instance.collection('focus').doc(uuid).get();

    final DocumentSnapshot postRef1 = await FirebaseFirestore.instance
        .collection('users_company').doc(company).collection('challenge').doc(challenge).collection('focus').doc(uuid).get();

    if (postRef.exists) {
      print('1');
      int total = postRef['total'];
      int available = postRef['available'];

      FirebaseFirestore.instance
            .collection('focus')
            .doc(uuid)
            .update({
          "total": result+total,
          "available": result+available
        }).then((value) async{

        });

    }else{
      print('2');

      FirebaseFirestore.instance
          .collection('focus')
          .doc(uuid)
          .set({
        "total": result,
        "available": result
      }).then((value) async{

      });

    }
    if (postRef1.exists) {
      print('3');

      int total = postRef1['total'];
      int available = postRef1['available'];
      print(uuid);
      print(total);
      print(available);

      FirebaseFirestore.instance
          .collection('users_company').doc(company).collection('challenge').doc(challenge).collection('focus').doc(uuid)
          .update({
        "total": result+total,
        "available": result+available
      }).then((value) async{

      });

    }else{
      print('4');

      FirebaseFirestore.instance
          .collection('users_company').doc(company).collection('challenge').doc(challenge).collection('focus').doc(uuid)
          .set({
        "total": result,
        "available": result
      }).then((value) async{

      });

    }


  }

  void _startTim(int sec, AppLifecycleState state) async {
    Map map = {
      'port': _receivePort.sendPort,
      'initial_duration': sec,
    };

    _isolate = await Isolate.spawn(startTimer(sec, state, map), _receivePort.sendPort);
    _receivePort.sendPort.send(sec);




  }
    showpop(){
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {Navigator.of(context).pop(); },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text('RewardTimertitle'.tr()),
        content: Text('RewardTimer'.tr()),
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
  showpopfail(){
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop(); },
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
   startTimer(int secnumb, AppLifecycleState state, Map map) async{
    print('Minuti'+ secnumb.toString());
    setState(() {
      first = true;
      istarted=true;
      towrite=outBedTime;
    });
    await _controllertext.forward();

    var sec = secnumb % 60;
    super.didChangeAppLifecycleState(state);
    totaltimer = outBedTime*60;
    blockedtotaltimer=outBedTime*60;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showNotificationWithDefaultSoundscheduled(DateTime.now().add(Duration(seconds: totaltimer)));
    await prefs.setInt('started', DateTime.now().millisecondsSinceEpoch);
    print('TIM'+totaltimer.toString());
    /*if (state == AppLifecycleState.inactive) {
       print('app inactive, is lock screen: ${await isLockScreen()}');
    }*/
    //print('app inactive, is lock screen: ${await isLockScreen()}');

    var oneSec =  Duration(seconds: 1);
    bool check = true;
    int diecisec = 10;
    SendPort port = map['port'];
    _timer = new asy.Timer.periodic(
      oneSec,
          (asy.Timer timer) => setState(
            (){
              port.send(timer.tick);
              checklockscreen(state);
              //print('CHECK'+checkcontrol.toString());
              print('CHECKAPP'+outofapp.toString());
              if(outofapp ){
                if(first){
                  first = false;
                  print('NEED TO CANCEL');
                  _showNotificationWithDefaultSound();
                }
                if (diecisec < 1) {
                  print('cancella');
                  istarted=false;
                  towrite=0;
                  firstsec=1;
                  stop();
                  //showpopfail();
                } else {
                  print('aspetta');
                  diecisec = diecisec - 1;
                }
              } else if(outofapp && !first){
                print('cancella subito');
                first=true;
                stop();
                towrite=0;
                firstsec=1;
                //showpopfail();



              }

          if (totaltimer < 1) {
            istarted=false;
            //timer.cancel();
            stop();
            position =1;
            print(towrite);
            writeDb(towrite);
            firstsec=1;
            showpop();


          } else {
            /*if(state==AppLifecycleState.resumed && !outofapp && istarted){
              int started =  prefs.getInt('started');
              DateTime startedtime = new DateTime.fromMillisecondsSinceEpoch(started);
              final DateTime dateTimeNow = new DateTime.now();
              Duration remainingTime = dateTimeNow.difference(startedtime);
              if(istarted){
                print('TIME: '+remainingTime.inSeconds.toString());
                //totaltimer=blocktimer-remainingTime.inSeconds;
                //if(remainingTime.inSeconds-blockedtotaltimer>0)
                totaltimer = blockedtotaltimer-remainingTime.inSeconds;
              }
            }*/

            firstsec=firstsec-1;
            Random r = new Random();
            int rr = r.nextInt(10000);

            forceRebuild = new ValueKey(DateTime.now().add(Duration(days: rr)));
            totaltimer = totaltimer - 1;
            outBedTime=totaltimer.ceil();
            position = (totaltimer/60).ceil();
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    AppLifecycleState state;
    return StreamBuilder(
        stream:  FirebaseFirestore.instance
            .collection('users_company').doc(company).collection('challenge').where('elapsed_time', isGreaterThan: DateTime.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }else if (snapshot.data.docs.length==0) {
            challenge='';
            return Scaffold(
                key: _drawerKey,
                endDrawer: DrawerUiWidget(),
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  title: Padding(
                      padding: new EdgeInsets.all(10.0),
                      child:SvgPicture.asset('assets/images/Accedi/SLOFF.svg', fit: BoxFit.cover, height: 20,)),
                  /*leading: new IconButton(
          icon: SvgPicture.asset('assets/images/Notifiche/Notifiche.svg', fit: BoxFit.cover),
          //onPressed: () => Navigator.of(context).pop(),
        ),*/
                  actions: <Widget>[
                    /*new
                    GestureDetector(
                      onTap: () => _drawerKey.currentState.openEndDrawer(),
                      child:
                      Padding(
                          padding: new EdgeInsets.only(right: 10.0),
                          child:
                          IconButton(
                              icon: SvgPicture.asset('assets/images/Notifiche/Notifiche.svg', fit: BoxFit.cover, height: 25,))),
                      //onPressed: () => Navigator.of(context).pop(),
                    ),*/
                  ],
                  elevation: 0,
                ),

                body:Container(
                    height: MediaQuery.of(context).size.height,
                    child:
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(height: 15,),

                        !istarted?
                        Container( padding: EdgeInsets.symmetric(horizontal: 10),child: Text(challenge!=''&& outBedTime==0?'Selezionatempo'.tr():
                        challenge!=''&& outBedTime>0?'Selezionatempo2'.tr():
                        'Mancachallenge'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,
                            fontSize: 15, color: Colors.black)))
                        //)
                            :
                        Container(child: Text(challenge!=''?'Selezionatempo3'.tr():'', style:new TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 15, color: Colors.black))),
                        Container(height: 3,),
                        !istarted?Container(child: Text(challenge!=''&& outBedTime==0?'trascinandobradipo'.tr():
                        challenge!=''&& outBedTime>0?'trascinandobradipo2'.tr():
                        '',
                            style: new TextStyle(fontWeight: FontWeight.w600,  fontSize: 15, color: Colors.blue))):
                        Container(child: Text('trascinandobradipo3'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,  fontSize: 15, color: Colors.blue))),
                        Container(height: 15,),
                        Container(height: 15,),

                        Container(
                          key: forceRebuild,
                          child:
                          SingleCircularSlider(
                            60,
                            position,
                            height: 260.0,
                            width: 260.0,

                            // primarySectors: 4,
                            //secondarySectors: 24,
                            baseColor: Color.fromARGB(100, 219, 219, 219),
                            selectionColor: Colors.blue,
                            handlerColor: Colors.black87,
                            handlerOutterRadius: 12.0,
                            onSelectionChange: _updateLabelsss,
                            sliderStrokeWidth: 12.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Center(
                                  child: //Text('${_formatIntervalTime(inBedTime, outBedTime)}',
                                  // style: TextStyle(fontSize: 36.0, color: Colors.blue))
                                  Rive(artboard: _riveArtboard)
                                //SvgPicture.asset('assets/images/Home/Terra.svg')
                                //FlareActor('assets/images/Sloff_lavora.json', animation: 'idle',)
                              ),
                            ),
                          ),),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:
                            CountdownTimer(
                              endTime: outBedTime,
                              widgetBuilder: (_, CurrentRemainingTime time) {
                                return Text(
                                    !istarted?'${_formatTime(outBedTime)}':'${_formatTime(outBedTime)}',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 50, color: Colors.black));
                              },
                            )
                        ),
                        Container(height: 13,),
                        challenge!=''?
                        !istarted && outBedTime>0?GestureDetector(
                            onTap: () {
                              setState(() {
                                istarted=true;
                              });
                              _startTim(_formatTimeint(outBedTime), state);},
                            child:
                            RectangleButton(text: ('inizia').tr().toUpperCase(), mini:true, type: 4
                            )):
                        !istarted && outBedTime==0?RectangleButton(text: ('Inizia').toUpperCase(), type: 5, mini: true
                        ):
                        GestureDetector(
                            onTap: ()=> stop(),
                            child:RectangleButton(text: ('Stop').toUpperCase(), type: 3, mini: true
                            )):RectangleButton(text: ('Inizia').toUpperCase(), type: 5, mini: true
                        ),

                      ],
                    ))
            );
          } else {

            if(snapshot.data.docs.length>0 && snapshot.data.docs[0]['visible']){
              challenge =snapshot.data.docs[0].id;
              //return Container(child:Text('challenge'));
            }else{
              challenge='';
            }
            return Scaffold(
                key: _drawerKey,
                endDrawer: DrawerUiWidget(),
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  title: Padding(
                      padding: new EdgeInsets.all(10.0),
                      child:SvgPicture.asset('assets/images/Accedi/SLOFF.svg', fit: BoxFit.cover, height: 20,)),
                  /*leading: new IconButton(
          icon: SvgPicture.asset('assets/images/Notifiche/Notifiche.svg', fit: BoxFit.cover),
          //onPressed: () => Navigator.of(context).pop(),
        ),*/
                  actions: <Widget>[
                    /*new
                    GestureDetector(
                      onTap: () => _drawerKey.currentState.openEndDrawer(),
                      child:
                      Padding(
                          padding: new EdgeInsets.only(right: 10.0),
                          child:
                          IconButton(
                              icon: SvgPicture.asset('assets/images/Notifiche/Notifiche.svg', fit: BoxFit.cover, height: 25,))),
                      //onPressed: () => Navigator.of(context).pop(),
                    ),*/
                  ],
                  elevation: 0,
                ),

                body:Container(
                    height: MediaQuery.of(context).size.height,
                    child:
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(height: 15,),

                        !istarted?
                        Container( padding: EdgeInsets.symmetric(horizontal: 10),child: Text(challenge!=''&& outBedTime==0?'Selezionatempo'.tr():
                        challenge!=''&& outBedTime>0?'Selezionatempo2'.tr():
                        'Mancachallenge'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,
                            fontSize: 15, color: Colors.black)))
                        //)
                            :
                        Container(child: Text(challenge!=''?'Selezionatempo3'.tr():'', style:new TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 15, color: Colors.black))),
                        Container(height: 3,),
                        !istarted?Container(child: Text(challenge!=''&& outBedTime==0?'trascinandobradipo'.tr():
                        challenge!=''&& outBedTime>0?'trascinandobradipo2'.tr():
                        '',
                            style: new TextStyle(fontWeight: FontWeight.w600,  fontSize: 15, color: Colors.blue))):
                        Container(child: Text('trascinandobradipo3'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,  fontSize: 15, color: Colors.blue))),
                        Container(height: 15,),
                        Container(height: 15,),
                        Stack(children: [                        Container(
                          key: forceRebuild,
                          child:
                          Center(child:
                          SingleCircularSlider(
                            60,
                            position,
                            height: 260.0,
                            width: 260.0,
                            // primarySectors: 4,
                            //secondarySectors: 24,
                            baseColor: Color.fromARGB(100, 219, 219, 219),
                            selectionColor: Colors.blue,
                            handlerColor: Colors.black87,
                            handlerOutterRadius: 12.0,
                            onSelectionChange: _updateLabelsss,
                            sliderStrokeWidth: 12.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Center(
                                  child: //Text('${_formatIntervalTime(inBedTime, outBedTime)}',
                                  // style: TextStyle(fontSize: 36.0, color: Colors.blue))
                                  Rive(artboard: _riveArtboard)
                                //SvgPicture.asset('assets/images/Home/Terra.svg')
                                //FlareActor('assets/images/Sloff_lavora.json', animation: 'idle',)
                              ),
                            ),
                          ),)),
                          istarted?
                          Center(child:
                          Container(height: 261, width: 261, color: Colors.transparent,)):
                          Container()


                        ],),

                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:
                            CountdownTimer(
                              endTime: outBedTime,
                              widgetBuilder: (_, CurrentRemainingTime time) {
                                return Text(
                                    !istarted?'${_formatTime(outBedTime)}':'${_formatTime(outBedTime)}',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 50, color: Colors.black));
                              },
                            )
                        ),
                        Container(height: 13,),
                        challenge!=''?
                        !istarted && outBedTime>0?GestureDetector(
                            onTap: () {
                              setState(() {
                                istarted=true;
                              });
                              _startTim(_formatTimeint(outBedTime), state);},
                            child:
                            RectangleButton(text: ('inizia').tr().toUpperCase(), mini:true, type: 4
                            )):
                        !istarted && outBedTime==0?RectangleButton(text: ('Inizia').toUpperCase(), type: 5, mini: true
                        ):
                        GestureDetector(
                            onTap: ()=> stop(),
                            child:RectangleButton(text: ('Stop').toUpperCase(), type: 3, mini: true
                            )):RectangleButton(text: ('Inizia').toUpperCase(), type: 5, mini: true
                        ),

                      ],
                    ))
            );
          }
    });
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
    if(firstsec!=1){
      return '$twoDigitMinutes:$twoDigitSeconds';
   }else{
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