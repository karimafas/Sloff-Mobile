import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/pages/Login.dart';

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

class _PreLogin extends State<PreLogin> with SingleTickerProviderStateMixin {
  Color selected = Colors.blue;
  int _currentIndex = 0;
  CarouselController _carouselController = new CarouselController();

  @override
  void initState() {
    super.initState();
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(color: new Color(0xFFFFF8ED)),
          Background(page: 1),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(height: 20)
                  ],
                ),
                SlideYFadeInBottom(
                  0.5, SizedBox(
                      height: 35,
                      child: SvgPicture.asset(
                          'assets/images/Home/SLOFF_logo.svg')),
                ),
                Container(height: 10),
                SlideYFadeIn(
                  1, SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            print(index);
                            _currentIndex = index;
                          });
                        },
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 16/9,
                      ),
                      items: [
                        InfoPage(title: "welcome-1".tr(), text: "welcome-1_2".tr()),
                        InfoPage(title: "welcome-2".tr(), text: "welcome-2_2".tr()),
                        InfoPage(title: "welcome-3".tr(), text: "welcome-3_2".tr()),
                        InfoPage(title: "welcome-4".tr(), text: "welcome-4_2".tr())
                      ],
                    ),
                  ),
                ),
                FadeIn(
                  1.5, DotsIndicator(
                    dotsCount: 4,
                    position: _currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      activeColor: new Color(0xFFFF6926),
                      color: new Color(0xFFFFDFAD),
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Column(
                  children: [
                    /* GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp1(email: "")));
                        },
                        child: RectangleButton(
                          color: new Color(0xFF694EFF),
                          width: 350,
                            text: ('registrati').tr().toUpperCase(),
                            mini: true,
                            type: 6)), */
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Container(
                          height: 54,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.transparent,
                            border: Border.all(color: new Color(0xFF190E3B), width: 2),
                          ),
                          child: Center(
                            child: Text("accedi".tr().toUpperCase(), textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w600,
                                color: new Color(0xFF190E3B),
                                fontSize: 15,
                              ),),
                          ),
                        )),
                        Container(height: 50)
                  ],
                ),
                GestureDetector(onTap: () {}, child: Container()),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({
    Key key, this.title, this.text,
  }) : super(key: key);
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontSize: 33,
                  fontFamily: 'GrandSlang'),
              textAlign: TextAlign.center),
          Container(height: 20),
          Text(text,
              style: TextStyle(
                  color: new Color(0xFF190E3B),
                  fontSize: 13,
                  fontFamily: 'Poppins-Light'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
