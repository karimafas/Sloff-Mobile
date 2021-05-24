import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sloff/components/AnimatedTextBox.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/global.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding/Onboarding.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({Key key, this.email}) : super(key: key);

  @override
  _SignUp1State createState() => _SignUp1State();
  final String email;
}

class _SignUp1State extends State<SignUp1> {
  bool emailVerified = false;

  bool emailError = false;

  String emailErrorText = "";

  TextEditingController emailController = new TextEditingController();

  bool emailTapped = false;
  bool buttonEnabled = false;

  validateEmail(String email) async {
    emailVerified = true;

    if (email.contains("@")) {
      if (email.contains(".")) {
        QuerySnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .where("email", isEqualTo: emailController.text)
            .get();
        if (doc.docs.length == 0) {
          setState(() {
            emailErrorText = "missing-email".tr();
            emailError = true;
          });
        } else {
          QuerySnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .where("email", isEqualTo: emailController.text)
              .get();

          if (doc.docs[0]['last_login'] != "") {
            setState(() {
              emailErrorText = "email-in-use".tr();
              emailError = true;
            });
          } else {
            setState(() {
              emailError = false;
            });
            pushWithFade(context, Welcome(email: emailController.text), 600);
          }
        }
      } else {
        setState(() {
          emailErrorText = "invalid-email".tr();
          emailError = true;
        });
        return false;
      }
    } else {
      setState(() {
        emailErrorText = "invalid-email".tr();
        emailError = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    emailController.text = widget.email;
    emailTapped = widget.email == "" ? false : true;
    emailVerified = widget.email == "" ? false : true;
    emailError = widget.email == "" ? false : false;
    buttonEnabled = widget.email == "" ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: new Color(0xFFFFF8ED),
        appBar: AppBar(
            backgroundColor: new Color(0xFFFFF8ED),
            iconTheme: IconThemeData(color: new Color(0xFF190E3B)),
            elevation: 0,
            title: Text("signup".tr().toUpperCase(),
                style: TextStyle(
                    color: new Color(0xFF190E3B),
                    fontFamily: 'Poppins-Regular',
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            leading: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_outlined,
                  color: new Color(0xFF190E3B)),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 4, width: 100, color: new Color(0xFFFF6926)),
                    Container(
                        height: 4, width: 100, color: new Color(0xFFFFDFAD)),
                    Container(
                        height: 4, width: 100, color: new Color(0xFFFFDFAD))
                  ],
                ),
                SizedBox(height: 30),
                Text("what-email".tr(),
                    style: TextStyle(
                        color: new Color(0xFF190E3B),
                        fontFamily: 'GrandSlang',
                        fontSize: 25)),
                SizedBox(height: 5),
                Text("enter-email".tr(),
                    style: TextStyle(
                        color: new Color(0xFF190E3B),
                        fontFamily: 'Poppins-Light',
                        fontSize: 13)),
                SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "email".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: new Color(0xFF190E3B)),
                      ),
                      if (emailVerified)
                        !emailError
                            ? SvgPicture.asset(
                                'assets/images/Log_In/Verification.svg')
                            : SvgPicture.asset('assets/images/Log_In/Wrong.svg')
                    ],
                  ),
                ),
                SizedBox(height: 5),
                AnimatedTextBox(
                    done: true,
                    onChanged: (value) {
                      if (value.trim() != "") {
                        if (emailController.text.trim() != "") {
                          setState(() {
                            buttonEnabled = true;
                          });
                        } else {
                          setState(() {
                            buttonEnabled = false;
                          });
                        }
                      } else {
                        setState(() {
                          buttonEnabled = false;
                        });
                      }
                    },
                    validator: emailError,
                    errorText: emailErrorText,
                    onSubmit: emailController.text.trim() == ''
                        ? (value) {}
                        : (value) {
                            validateEmail(emailController.text);
                          },
                    email: true,
                    emailTapped: emailTapped,
                    emailController: emailController,
                    onTap: () {
                      setState(() {
                        emailTapped = true;
                      });
                    }),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: emailController.text.trim() == ''
                      ? () {}
                      : () {
                          validateEmail(emailController.text);
                        },
                  child: RectangleButton(
                      textColor: buttonEnabled
                          ? Colors.white
                          : Colors.white.withOpacity(.5),
                      text: "avanti".tr().toUpperCase(),
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: new Color(0xFF694EFF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  final String email;

  const Welcome({Key key, this.email}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with AnimationMixin {
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: new Color(0xFF190E3B),
        ),
        FadeIn(3, Background()),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideYFadeIn(
                      1,
                      Text("welcome-sloff".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'GrandSlang',
                              fontSize: 33)),
                    ),
                    SizedBox(height: 10),
                    SlideYFadeIn(
                      1,
                      Text("setup".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins-Light',
                              fontSize: 13)),
                    ),
                    SizedBox(height: 60),
                    AnimatedContainer(
                      height: _height,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOutQuad,
                    ),
                    FadeIn(
                      2,
                      RectangleButton(
                        text: "inizia".tr().toUpperCase(),
                        color: new Color(0xFFFF6926),
                        onTap: () {
                          setState(() {
                            _height = 400;
                          });
                          pushReplacementWithFade(
                              context, SignUp2(email: widget.email), 600);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SignUp2 extends StatefulWidget {
  final String email;

  const SignUp2({Key key, this.email}) : super(key: key);

  @override
  _SignUp2State createState() => _SignUp2State();
}

int _currentIndex = 0;
String nameValue = "";
TextEditingController nameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController password2Controller = new TextEditingController();
PageController _pageController = new PageController();
bool buttonEnabled = false;

class _SignUp2State extends State<SignUp2> {
  String pwErrorText = "";
  bool isLoading = false;

  bool verifyPassword(String password1, String password2) {
    if (password1 == password2) {
      if (password1.length >= 8) {
        return true;
      } else {
        pwErrorText = "password-length".tr();
        return false;
      }
    } else {
      pwErrorText = "same-password".tr();
      return false;
    }
  }

  void _signUp() async {
    if (widget.email.isNotEmpty &&
        widget.email != null &&
        passwordController.text.isNotEmpty &&
        passwordController.text != null) {
      setState(() {
        isLoading = true;
        FocusScope.of(context).unfocus();
      });
      try {
        print('TEST ENTER');
        String mail = widget.email;
        var user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.email, password: passwordController.text));

        if (user != null) {
          QuerySnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .where("email", isEqualTo: widget.email)
              .get();
          if (doc.docs.length == 0) {
            Toast.show(
                "Il tuo indirizzo email non è collegato a nessuna azienda",
                context);
          } else {
            String uuid = doc.docs[0].id;
            String company = doc.docs[0].get('company');
            print('TEST ENTER');
            FirebaseFirestore.instance.collection('users').doc(uuid).update({
              "last_login": DateTime.now().millisecondsSinceEpoch,
              "last_app_usage": DateTime.now().millisecondsSinceEpoch,
            }).then((value) async {
              FirebaseFirestore.instance.collection('focus').doc(uuid).set({
                "total": 0,
                "available": 0,
              }).then((value) async {
                FirebaseFirestore.instance
                    .collection('users_company')
                    .doc(company)
                    .collection('focus')
                    .doc(uuid)
                    .set({
                  "total": 0,
                  "available": 0,
                }).then((value) async {
                  FirebaseFirestore.instance
                      .collection('users_company')
                      .doc(company)
                      .collection('users')
                      .doc(uuid)
                      .update({
                    "last_login": DateTime.now().millisecondsSinceEpoch,
                    "last_app_usage": DateTime.now().millisecondsSinceEpoch,
                    "uuid": uuid
                  }).then((value) async {
                    if (true) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('uuid', uuid);
                      await prefs.setString('company', company);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Onboarding(
                              name: nameController.text,
                            ),
                          ),
                          (Route<dynamic> route) => false);

                      Future.delayed(Duration(milliseconds: 1000), () {
                        nameController.clear();
                        passwordController.clear();
                        password2Controller.clear();
                      });
                    }
                  }).then((value) {
                    FirebaseMessaging.instance.getToken().then((token) {
                      final DocumentReference postRef = FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(uuid);

                      if (postRef != null) {
                        print("Getting post reference////// ${postRef.path}");
                        postRef.update({
                          "last_login": DateTime.now().millisecondsSinceEpoch,
                          "last_app_usage":
                              DateTime.now().millisecondsSinceEpoch,
                          "version": Global.version,
                          "token": token
                        });
                      }
                    }).then((value) {
                      FirebaseMessaging.instance
                        .subscribeToTopic("AllPushNotifications");

                      FirebaseMessaging.instance
                        .subscribeToTopic(company);
                    });
                  });
                });
              });
            });
          }
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Container(color: new Color(0xFF190E3B)),
          SlideYFadeIn(2, Background()),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  iconTheme: IconThemeData(color: Colors.white),
                  elevation: 0,
                  title: Text("signup".tr().toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  leading: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      print(_currentIndex);
                      if (_currentIndex == 0) {
                        Navigator.pop(context);
                      } else {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuad);
                      }
                    },
                    child: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.white),
                  )),
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: NamePage(
                                buttonEnabled: buttonEnabled,
                                onChanged: (value) {
                                  if (value.trim() == "") {
                                    setState(() {
                                      buttonEnabled = false;
                                    });
                                  } else {
                                    setState(() {
                                      buttonEnabled = true;
                                    });
                                  }
                                },
                                onSubmit: !buttonEnabled
                                    ? (value) {}
                                    : (value) {
                                        _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOutQuad);
                                        setState(() {
                                          _currentIndex = 1;
                                        });
                                      },
                                nameController: nameController,
                                pageController: _pageController,
                                onTap: !buttonEnabled
                                    ? () {}
                                    : () {
                                        _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOutQuad);
                                        setState(() {
                                          _currentIndex = 1;
                                        });
                                      }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: PasswordPage(
                              changeScope: (value) {
                                FocusScope.of(context).nextFocus();
                              },
                              isLoading: isLoading,
                              onSubmit: (value) {
                                if (verifyPassword(passwordController.text,
                                    password2Controller.text)) {
                                  _signUp();
                                } else {
                                  print(pwErrorText);
                                }
                              },
                              onTap: () {
                                if (verifyPassword(passwordController.text,
                                    password2Controller.text)) {
                                  _signUp();
                                } else {
                                  print(pwErrorText);
                                }
                              },
                              passwordError: pwErrorText,
                              passwordController: passwordController,
                              password2Controller: password2Controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NamePage extends StatelessWidget {
  const NamePage({
    Key key,
    @required this.nameController,
    @required PageController pageController,
    this.onTap,
    this.buttonEnabled,
    this.onChanged,
    this.onSubmit,
  }) : super(key: key);

  final TextEditingController nameController;
  final Function onTap;
  final bool buttonEnabled;
  final Function(String) onChanged;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 4,
                width: 100,
                color: new Color(0xFF694EFF).withOpacity(.4)),
            Container(color: new Color(0xFF694EFF), height: 4, width: 100),
            Container(
                height: 4,
                width: 100,
                color: new Color(0xFF694EFF).withOpacity(.4))
          ],
        ),
        SizedBox(height: 30),
        Text("whatsurname".tr(),
            style: TextStyle(
                color: Colors.white, fontFamily: 'GrandSlang', fontSize: 23)),
        SizedBox(height: 5),
        Text("why-name".tr(),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Light',
                fontSize: 13)),
        SizedBox(height: 40),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "name".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        AnimatedTextBox(
            done: true,
            textColor: Colors.white,
            backgroundColor: new Color(0xFF483F64),
            onChanged: (value) => onChanged(value),
            validator: false,
            errorText: "",
            onSubmit: (value) => onSubmit(value),
            email: true,
            keyboard: false,
            emailTapped: true,
            emailController: nameController,
            onTap: () {}),
        SizedBox(height: 40),
        GestureDetector(
            onTap: onTap,
            child: RectangleButton(
                textColor:
                    buttonEnabled ? Colors.white : Colors.white.withOpacity(.5),
                text: "avanti".tr().toUpperCase(),
                width: MediaQuery.of(context).size.width * 0.9,
                color: new Color(0xFFFF6926))),
      ],
    );
  }
}

class PasswordPage extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController password2Controller;
  final Function onTap;
  final String passwordError;
  final Function(String) onSubmit;
  final Function(String) changeScope;
  final bool isLoading;

  const PasswordPage(
      {Key key,
      this.passwordController,
      this.password2Controller,
      this.onTap,
      this.passwordError,
      this.onSubmit,
      this.isLoading,
      this.changeScope})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 4,
                width: 100,
                color: new Color(0xFF694EFF).withOpacity(.4)),
            Container(
                color: new Color(0xFF694EFF).withOpacity(.4),
                height: 4,
                width: 100),
            Container(height: 4, width: 100, color: new Color(0xFF694EFF))
          ],
        ),
        SizedBox(height: 30),
        Text("create-password".tr(),
            style: TextStyle(
                color: Colors.white, fontFamily: 'GrandSlang', fontSize: 23)),
        SizedBox(height: 5),
        Text("why-password".tr(),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Light',
                fontSize: 13)),
        SizedBox(height: 40),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "password".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        AnimatedTextBox(
            done: false,
            //autofocus: true,
            textColor: Colors.white,
            backgroundColor: new Color(0xFF483F64),
            onChanged: (value) {},
            validator: false,
            errorText: "",
            onSubmit: (value) => changeScope(value),
            email: false,
            keyboard: null,
            emailTapped: true,
            emailController: passwordController,
            onTap: () {}),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "pw-repeat".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        AnimatedTextBox(
            textColor: Colors.white,
            backgroundColor: new Color(0xFF483F64),
            onChanged: (value) {},
            validator: false,
            errorText: "",
            onSubmit: (value) => onSubmit(value),
            email: false,
            keyboard: null,
            emailTapped: true,
            emailController: password2Controller,
            onTap: () {}),
        SizedBox(height: 10),
        Text(passwordError, style: TextStyle(color: Colors.red, fontSize: 13)),
        SizedBox(height: 40),
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                RectangleButton(
                    text: "",
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: new Color(0xFFFF6926)),
                Positioned(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      switchOutCurve: Curves.easeInOutQuart,
                      switchInCurve: Curves.easeInOutQuart,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : SizedBox(
                              child: Text(
                                "create-account".tr().toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins-Regular'),
                              ),
                            ),
                    ),
                    top: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
