//import 'package:sloff/values/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/AnimatedTextBox.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/pages/homepage.dart';
import 'package:sloff/pages/onboarding/EmojiSurvey.dart';
import 'package:toast/toast.dart';
import 'package:flutter/rendering.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/global.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const Login({Key key, this.text, this.onTap}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected = Colors.blue;
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
  bool _emailTapped = false;
  bool _passwordTapped = false;
  bool _emailError = false;
  bool _passwordError = false;
  String _emailErrorText = "";
  String _passwordErrorText = "";
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  bool _showCircularIndicator = false;
  bool loginEnabled = false;
  bool passwordVerified = false;
  bool emailVerified = false;

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

  void _loginUser() async {
    try {
      setState(() {
        _showCircularIndicator = true;
      });

      setState(() {
        emailVerified = true;
        passwordVerified = true;
      });

      username = _emailController.text;
      password = _passwordController.text;
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password)
          .then((user) async {
        print(
            'The username is : $username and password is : $password and user is :' +
                user.user.uid);
        if (user != null) {
          QuerySnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .where("email", isEqualTo: _emailController.text)
              .get();
          if (doc.docs.length == 0) {
            Toast.show(
                "Il tuo indirizzo email non ?? collegato a nessuna azienda",
                context);
          } else {
            String uuid = doc.docs[0].id;
            String company = doc.docs[0].get('company');
            print('TEST ENTER');

            FirebaseMessaging.instance.getToken().then((token) {
              final DocumentReference postRef =
                  FirebaseFirestore.instance.collection('users').doc(uuid);
              if (postRef != null) {
                print("Getting post reference////// ${postRef.path}");
                postRef.update({
                  "last_login": DateTime.now().millisecondsSinceEpoch,
                  "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                  "version": Global.version,
                  "token": token,
                }).then((value) async {
                  FirebaseFirestore.instance
                      .collection('users_company')
                      .doc(company)
                      .collection('users')
                      .doc(uuid)
                      .update({
                    "last_login": DateTime.now().millisecondsSinceEpoch,
                    "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                  }).then((value) async {
                    final sharedPref = await setSharedPref();

                    ///sharedPref.setBool(
                    // AppStateModel.IS_AUDIO_BOOK_LOGIN, true);
                    //sharedPref.setString(
                    //  AppStateModel.LOGGED_IN_USER_ID, user.user.uid);
                    if (true) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('uuid', uuid);
                      await prefs.setString('company', company);

                      setState(() {
                        _emailError = false;
                        _passwordError = false;
                      });

                      pushReplacementWithFade(context, HomeInitialPage(), 500);
                    }
                  }).then((value) {
                    FirebaseMessaging.instance
                        .subscribeToTopic("AllPushNotifications");

                    FirebaseMessaging.instance
                        .subscribeToTopic(company);
                  });
                });
              } else {}
            });
          }
        }
      }).catchError((error) {
        setState(() {
          _showCircularIndicator = false;
        });
        switch (error.code) {
          case "user-not-found":
            {
              setState(() {
                isLoading = false;
                setState(() {
                  _passwordError = false;
                  _emailError = true;
                  _emailErrorText = "Email non registrata.";
                });
              });
            }
            break;
          case "invalid-email":
            {
              setState(() {
                isLoading = false;
                setState(() {
                  _emailError = true;
                  _emailErrorText = "Email non registrata.";
                });
              });
            }
            break;
          case "ERROR_NETWORK_REQUEST_FAILED":
            {
              setState(() {
                isLoading = false;
                Toast.show("Controlla la tua connessione a internet.", context);
              });
            }
            break;
          case "wrong-password":
            {
              setState(() {
                isLoading = false;
                setState(() {
                  _emailError = false;
                  _passwordError = true;
                  _passwordErrorText = "Password non valida.";
                });
              });
            }
            break;
          default:
            {
              setState(() {
                isLoading = false;
                Toast.show("Qualcosa ?? andato storto.", context);
              });
            }
        }
      });
    } catch (error) {
      print('Error code:-> ' + error.code);
      switch (error.code) {
        case "user-not-found":
          {
            setState(() {
              isLoading = false;
              Toast.show("Email not registered.", context);
              setState(() {
                _passwordError = false;
                _emailError = true;
                _emailErrorText = "Email non registrata.";
              });
            });
          }
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          {
            setState(() {
              isLoading = false;
              Toast.show("Controlla la tua connessione a internet.", context);
            });
          }
          break;
        case "ERROR_WRONG_PASSWORD":
          {
            setState(() {
              isLoading = false;
              setState(() {
                _passwordError = true;
                _passwordErrorText = "Password non valida.";
              });
            });
          }
          break;
        default:
          {
            setState(() {
              isLoading = false;
              Toast.show("Qualcosa ?? andato storto.", context);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: new Color(0xFFFFF8ED),
        appBar: new AppBar(
          iconTheme: IconThemeData(color: new Color(0xFF190E3B)),
          leading: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_outlined,
                color: new Color(0xFF190E3B)),
          ),
          title: Text('accedi'.tr().toUpperCase(),
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
                color: new Color(0xFFFFF8ED),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("welcomeback".tr(),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 33,
                            fontFamily: 'GrandSlang')),
                    Container(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text("enteremail".tr(),
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: new Color(0xFF190E3B),
                                    fontSize: 13,
                                    fontFamily: 'Poppins-Light'),
                                textAlign: TextAlign.start),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'email'.tr(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: new Color(0xFF190E3B)),
                          ),
                          if (emailVerified)
                            !_emailError
                                ? SvgPicture.asset(
                                    'assets/images/Log_In/Verification.svg')
                                : SvgPicture.asset(
                                    'assets/images/Log_In/Wrong.svg')
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    AnimatedTextBox(
                        onChanged: (value) {
                          if (value.trim() != "") {
                            if (_emailController.text.trim() != "" &&
                                _passwordController.text.trim() != "") {
                              setState(() {
                                loginEnabled = true;
                              });
                            } else {
                              setState(() {
                                loginEnabled = false;
                              });
                            }
                          } else {
                            setState(() {
                              loginEnabled = false;
                            });
                          }
                        },
                        validator: _emailError,
                        errorText: _emailErrorText,
                        onSubmit: (value) {
                          FocusScope.of(context).nextFocus();
                          setState(() {
                            _passwordTapped = true;
                          });
                        },
                        email: true,
                        emailTapped: _emailTapped,
                        emailController: _emailController,
                        onTap: () {
                          setState(() {
                            _emailTapped = true;
                          });
                        }),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: new Color(0xFF190E3B)),
                          ),
                          if (passwordVerified)
                            !_passwordError
                                ? SvgPicture.asset(
                                    'assets/images/Log_In/Verification.svg')
                                : SvgPicture.asset(
                                    'assets/images/Log_In/Wrong.svg')
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    AnimatedTextBox(
                        onChanged: (value) {
                          if (value.trim() != "") {
                            if (_emailController.text.trim() != "" &&
                                _passwordController.text.trim() != "") {
                              setState(() {
                                loginEnabled = true;
                              });
                            } else {
                              setState(() {
                                loginEnabled = false;
                              });
                            }
                          } else {
                            setState(() {
                              loginEnabled = false;
                            });
                          }
                        },
                        validator: _passwordError,
                        errorText: _passwordErrorText,
                        onSubmit: (value) => _loginUser(),
                        email: false,
                        emailTapped: _passwordTapped,
                        emailController: _passwordController,
                        onTap: () {
                          setState(() {
                            _passwordTapped = true;
                          });
                        }),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _emailController.text.trim() == '' ||
                              _passwordController.text.trim() == ''
                          ? () {}
                          : () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _loginUser();
                            },
                      child: RectangleButton(
                          textColor: loginEnabled
                              ? Colors.white
                              : Colors.white.withOpacity(.5),
                          text: "accedi".tr().toUpperCase(),
                          width: 350,
                          color: new Color(0xFF694EFF)),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text("forgot-password".tr(),
                          style: TextStyle(
                              fontSize: 15,
                              color: new Color(0xFF694EFF),
                              fontFamily: 'Poppins-Regular'),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 50),
                    Center(
                        child: AnimatedOpacity(
                      opacity: _showCircularIndicator ? 1 : 0,
                      duration: Duration(milliseconds: 250),
                      child: CircularProgressIndicator(
                        backgroundColor: new Color(0xFF694EFF),
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white60),
                      ),
                    ))
                  ],
                ))),
      ),
    );
  }
}
