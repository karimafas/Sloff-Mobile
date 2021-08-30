import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) await AndroidAlarmManager.initialize();

  initializeNotification();

  runApp(
    EasyLocalization(
        startLocale: Locale('en'),
        supportedLocales: [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    ),
  );
}

void initializeNotification() async {
  try {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Future getData;

  Future<Map> getUserCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var details = {
      "uuid": prefs.getString("uuid"),
      "company": prefs.getString("company")
    };

    return details;
  }

  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    getData = getUserCompany();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    FirebaseAnalytics analytics = FirebaseAnalytics();

    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.signInAnonymously().then((value) {
              print("signed in anonymously");
            });

            return MaterialApp(
              title: 'Sloff',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Poppins-Light',
                primarySwatch: Colors.blue,
                brightness: Brightness.light,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: MediaQuery(
                data: new MediaQueryData(),
                child: FutureBuilder(
                    future: getData,
                    builder: (context, userDetails) {
                      if (!userDetails.hasData) {
                        return Container();
                      } else if (userDetails.hasError) {
                        return Container();
                      } else {
                        return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            builder: (context, snapshot) {
                              return SplashScreen(
                                  uuid: userDetails.data["uuid"],
                                  company: userDetails.data["company"],
                                  analytics: analytics);
                            });
                      }
                    }),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
