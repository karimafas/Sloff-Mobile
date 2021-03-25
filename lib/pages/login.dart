//import 'package:sloff/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/main.dart';
import 'package:toast/toast.dart';
import'package:sloff/pages/homepage.dart';

import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/components/textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/pages/cambiocausa.dart';
import 'package:sloff/pages/welcome/welcome.dart';
import 'package:sloff/global.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final registrati;

  const Login({
    Key key,
    this.text,
    this.onTap,
    this.registrati
  }) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected=Colors.blue;
  bool validateUserName = false;
  bool validatePassword = false;
  bool isLoading = false;
  bool isShow = false;
  String username = '', password = '';
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final focus = FocusNode();
  SharedPreferences sharedPreferences;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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


  void _signUpUser() async {
    if (
    _emailController.text.isNotEmpty && _emailController.text != null &&
        _passwordController.text.isNotEmpty && _passwordController.text != null
    ) {
      setState(() {
        isLoading = true;
        FocusScope.of(context).unfocus();
      });
      try {
        print('TEST ENTER');
        String mail = _emailController.text;
        var user =
        (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text));

        if (user != null) {
          QuerySnapshot doc =  await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: _emailController.text).get();
          if(doc.docs.length==0){
            Toast.show("Il tuo indirizzo email non è collegato a nessuna azienda", context);
          }else{
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
                              utente: _nameController.text,
                            ),
                          ),
                              (Route<dynamic> route) => false);
                    }
                  });

                });

              });




            });
          }}
      } catch (error) {
        print('Error code:-> ' + error.toString());
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                isLoading = false;
                Toast.show("Email already registered.", context);
              });
            }
            break;
          case "ERROR_NETWORK_REQUEST_FAILED":
            {
              setState(() {
                isLoading = false;
                Toast.show("Check your internet connection.", context);
              });
            }
            break;
          default:
            {
              setState(() {
                isLoading = false;
                Toast.show("Qualcosa non va", context);
              });
            }
        }
      }
    } else {
      setState(() {
        isLoading = false;
//        print('Enter proper details.');
      });
    }
  }
  void _loginUser() async {

    try {
      username = _emailController.text;
      password = _passwordController.text;
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password)
          .then((user) async {
        print(
            'The username is : $username and password is : $password and user is :'+user.user.uid);
        if (user != null) {
          QuerySnapshot doc =  await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: _emailController.text).get();
          if(doc.docs.length==0){
            Toast.show("Il tuo indirizzo email non è collegato a nessuna azienda", context);
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
          }}

      }).catchError((error) {
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            {
              setState(() {
                isLoading = false;
                Toast.show("Email not registered.", context);
              });
            }
            break;
          case "ERROR_NETWORK_REQUEST_FAILED":
            {
              setState(() {
                isLoading = false;
                Toast.show("Check your internet connection.", context);
              });
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                isLoading = false;
                Toast.show("Invalid password.", context);
              });
            }
            break;
          default:
            {
              setState(() {
                isLoading = false;
                Toast.show("Something went wrong", context);
              });
            }
        }
      });
    } catch (error) {
      print('Error code:-> ' + error.code);
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            setState(() {
              isLoading = false;
              Toast.show("Email not registered.", context);
            });
          }
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          {
            setState(() {
              isLoading = false;
              Toast.show("Check your internet connection.", context);
            });
          }
          break;
        case "ERROR_WRONG_PASSWORD":
          {
            setState(() {
              isLoading = false;
              Toast.show("Invalid password.", context);
            });
          }
          break;
        default:
          {
            setState(() {
              isLoading = false;
              Toast.show("Something went wrong", context);
            });
          }
      }
    }

  }

  Future<GoogleSignInAccount> getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: Text((!widget.registrati?'accedi'.tr():'registrati'.tr()).toUpperCase(),
        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
      ), backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: Colors.black),),

      body:
      SingleChildScrollView(child:
      Container(
          color: Colors.white,
          padding: EdgeInsets.all(30),
          child:Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.registrati?Text('nome'.tr(),
                style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black

                ),):Container(),
              widget.registrati?TheTextfield(controller: _nameController):Container(),
              Text('ind_mail'.tr(),
                style: TextStyle(
                    fontSize: 21.0,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
              TheTextfield(controller: _emailController),
              Text('Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: -0.8,
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black

                ),),
              //Container(height: 10,),
              TheTextfield(ispass: true, controller: _passwordController),
              Container(height: 18,),

              GestureDetector(onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                print(_passwordController.text);
                !widget.registrati?_loginUser():_signUpUser();

              },
                child:RectangleButton(text: !widget.registrati?'accedi'.tr():'accedi'.tr(), mini:true), ),

            ],

          )))),
    );
  }
}