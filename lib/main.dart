import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/components/textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/pages/prelogin.dart';
import'package:sloff/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() {
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('it')],
        path: 'assets/translations', // <-- change patch to your
        fallbackLocale: Locale('it'),
        child: MyApp()
    ),
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
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
   // _requestPermissions();
    //
  } catch(e) {
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {

@override
_MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp>
    //with
  {
    String uuid = null;

  Future<String> _check () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp();


    print('QUA'+prefs.get('uuid'));
    print('QUA'+prefs.get('company'));

    //await FirebaseMessaging.instance.subscribeToTopic(prefs.get('company'));

    setState(() {
      uuid = prefs.get('uuid');
    });
    //return uuid;
    /*await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Accedi_attivo_Log_in.svg'), context,);*/
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Accedi_Log_In.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/campo_di_testo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/campo_di_testo_attivo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Coupon_Accedi.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Coupon_Accedi_Google.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Registrati.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/SLOFF.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Accedi/Sloth.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon_da_riscattare.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon_grigio.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Riscatta_coupon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Sloff_Coupon_finiti.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Freccia_detox.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia.svg'), context,);
    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia_attivo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/SLOFF_logo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Sloth_detox.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Stop.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Terra.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Esci.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Gestione_account.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Impostazioni.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Privacy_policy.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Segnala.svg'), context,);
    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Servizio_clienti.svg'), context,);

    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/On_boarding_testo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img1.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img2.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img3.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Torta.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Copia.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_aperto.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_aperto_linea.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_da_utilizzare.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Modifica_profilo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Segnala.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Servizio_Clienti.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Coupon_icon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Coupon_icon_ON.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Home_icon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Home_icon_ON.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Profilo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Profilo_ON.svg'), context,);


  }



    void initState(){
      WidgetsFlutterBinding.ensureInitialized();
      super.initState();
      _check();

    }
  //extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  // systemNavigationBarColor: AppColors.orange, // navigation bar color
  statusBarColor: Colors.white, // status bar color
  statusBarIconBrightness: Brightness.dark));
  return MaterialApp(
  title: 'Sloff',
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  locale: context.locale,
  debugShowCheckedModeBanner: false,

  theme: ThemeData(
  fontFamily: 'Montserrat',

  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  home:  SafeArea(child:uuid==null?PreLogin():HomeInitialPage()
  /*FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if (snapshot.hasData){
          FirebaseUser user = snapshot.data; // this is your user instance
          /// is because there is user already logged
          return HomeInitialPage();
        }
        /// other way there is no user logged.
        return PreLogin();
      }
  )*/

  ), //PreLogin(),
  );
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

  final Rect colorBounds =Rect.fromLTRB(size.width, size.height, 0, 0);// Rect.fromLTRB(0, 0, size.width, size.height);
  final Paint paint = new Paint()
  ..shader = gradient.createShader(colorBounds);


  final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
  final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: 30);
  final backgroundPath = Path()
  ..moveTo(shapeBounds.left, shapeBounds.top) //3
  ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy) //4
  ..arcTo(avatarBounds, -pi, pi, false) //5
  //..arcTo(avatarBounds, -pi, pi, false)
  ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //6
  ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //7
  ..close(); //8

  //9
  canvas.drawPath(backgroundPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  }

