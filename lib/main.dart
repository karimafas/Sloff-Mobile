import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EasyLocalization(
        startLocale: Locale('en'),
        supportedLocales: [Locale('en')],
        path: 'assets/translations',
        // <-- change patch to your
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
  initializeNotification();
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
    // _requestPermissions();
    //
  } catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> //with
{
  String uuid = null;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Future<String> _check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      uuid = prefs.get('uuid');
    });

    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Accedi/Accedi_Log_In.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Accedi/campo_di_testo.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Accedi/campo_di_testo_attivo.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Accedi/Coupon_Accedi.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Accedi/Coupon_Accedi_Google.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Accedi/Registrati.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Accedi/SLOFF.svg'),
      context,
    );
    await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/Accedi/Sloth.svg'),
      context,
    );

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
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Profilo/Modifica_profilo.svg'),
      context,
    );

    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/Profilo/Servizio_Clienti.svg'),
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
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _check();
    Firebase.initializeApp();
  }

  //extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light)
    );

    FirebaseAnalytics analytics = FirebaseAnalytics();

    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
                child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    builder: (context, snapshot) {
                      return SplashScreen(uuid: uuid, analytics: analytics);
                    }),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Container buildHome() {
    return Container();

    /*return Container(
            color: Colors.transparent,
            child: uuid == '' ? PreLogin() : HomeInitialPage(),
          );*/
  }
}

class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTWH(0, 0, size.width, size.height - 30.0);
    final Gradient gradient = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orangeAccent, Colors.yellow],
      tileMode: TileMode.clamp,
    );

    final Rect colorBounds = Rect.fromLTRB(size.width, size.height, 0,
        0); // Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = new Paint()
      ..shader = gradient.createShader(colorBounds);

    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: 30);
    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top) //3
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy) //4
      ..arcTo(avatarBounds, -pi, pi, false) //5
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //6
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //7
      ..close(); //8

    //9
    canvas.drawPath(backgroundPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
