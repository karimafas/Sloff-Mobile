
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/main.dart';
import 'package:toast/toast.dart';
import'package:sloff/pages/homepage.dart';
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

class _PreLogin extends State<PreLogin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected=Colors.blue;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

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

  void _getSignedInAccount() async {
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
          QuerySnapshot doc =  await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: user.user.email).get();
          if(doc.docs.length==0){
            Toast.show("Il tuo indirizzo email non è collegato a nessuna azienda", context);
          }else{
          if(doc.docs[0].get('last_login')==''){
            String uuid = doc.docs[0].id;
            String company =doc.docs[0].get('company');
            print('TEST ENTER');
            FirebaseFirestore.instance.collection('users').doc(uuid).update({
              "last_login": DateTime.now().millisecondsSinceEpoch,
              "last_app_usage": DateTime.now().millisecondsSinceEpoch,
            }).then((value) async {
              FirebaseFirestore.instance.collection('focus').doc(uuid).set({
                "total": 0,
                "available": 0,
              }).then((value) async {
                FirebaseFirestore.instance.collection('users_company').doc(company).collection('focus').doc(uuid).set({
                  "total": 0,
                  "available": 0,
                }).then((value) async {
                  FirebaseFirestore.instance.collection('users_company').doc(company).collection('users').doc(uuid).update({
                    "last_login": DateTime.now().millisecondsSinceEpoch,
                    "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                    "uuid":uuid
                  }).then((value) async {
                    if (true) {
                      //sharedPref.setBool('isFirst', true);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
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

          }else{
            String uuid = doc.docs[0].id;
            String company =doc.docs[0].get('company');
            print('TEST ENTER');
            final DocumentReference postRef =
            FirebaseFirestore.instance.collection('users').doc(uuid);
            if (postRef != null) {
              print("Getting post reference////// ${postRef.path}");
              postRef
                  .update({
                "last_login": DateTime.now().millisecondsSinceEpoch,
                "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                "version": Global.version,

              }).then((value) async{
                FirebaseFirestore.instance.collection('users_company').doc(company).collection('users').doc(uuid).update({
                  "last_login": DateTime.now().millisecondsSinceEpoch,
                  "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                }).then((value) async {
                  final sharedPref = await setSharedPref();

                  ///sharedPref.setBool(
                  // AppStateModel.IS_AUDIO_BOOK_LOGIN, true);
                  //sharedPref.setString(
                  //  AppStateModel.LOGGED_IN_USER_ID, user.user.uid);
                  if (true) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('uuid', uuid);
                    await prefs.setString('company', company);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomeInitialPage(

                          ),
                        ),
                            (Route<dynamic> route) => false);
                  }
                });

              });
            } else {

            }
          }

          }
          }
      });

    }
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffbef00), Color(0xff10eb50), Color(0xff08b9ff), Color(0xff0f80ff),
      Color(0xff9e06db), Color(0xffff0f5f), Color(0xffFF7E05), Color(0xffFAFA19)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 250.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:

      Container(padding: EdgeInsets.all(30),
          child:Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Container(
              //height: 80,
              //child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //SvgPicture.asset('assets/images/Accedi/Sloth.svg'),

                  SvgPicture.asset('assets/images/Accedi/Sloth.svg'),
                  //Container(width: 120,),
                  //SvgPicture.asset('assets/images/Accedi/SLOFF.svg')
                  Container(
                      width: 150,
                      child:
                      SvgPicture.asset('assets/images/Accedi/SLOFF.svg')),

                ],),//),
              new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  text: 'Your focus for\n',
                  style: TextStyle(
                      letterSpacing: -0.8,
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: 'Earthcare', style: new  TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = linearGradient,
                    )),
                  ],
                ),
              ),
              /* Text('Earthcare',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold
            ),),
          ColorizeAnimatedTextKit(
              onTap: () {
                print("Tap Event");
              },
              text: [
                "Earthcare",
              ],
              //repeatForever: true,
              //isRepeatingAnimation: true,
              speed: Duration(milliseconds: 3000),
              textStyle: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
              colors: [
                //Colors.purple,
                Colors.blue,
                Colors.yellow,
                Colors.red,
                Colors.yellow,
                Colors.blue,
              ],
              textAlign: TextAlign.start,
              alignment: AlignmentDirectional.topStart // or Alignment.topLeft
          ),*/
              Container(height: 10,),
              /*Text('welcome_ut',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
          ),).tr(),
          Container(height: 10,),

          Text('welcome_ut1',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 16.0,
          ),).tr(),*/
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(registrati: true,))
                    );

                  },
                      child:RectangleButton(text: ('registrati').tr().toUpperCase(),  mini: true, type: 6)),
                  GestureDetector(onTap: (){
                    _getSignedInAccount();

                  },
                    child:
                    RectangleButton(text: ('accedigoogle').tr(), type: 2, mini: true),
                  ),
                  Center(child:
                  Container(padding: EdgeInsets.only(top: 20, bottom: 27),
                    child: Text('OPPURE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: -0.8,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),),

                  )),
                  GestureDetector(onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(registrati: false,))
                    );

                  },
                      child:RectangleButton(text: ('accedi').tr(),)),

                ],),


              GestureDetector(onTap: (){


              },
                  child:Container()),

            ],

          )
          )),
    );
  }
}