import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/OnboardingBackground.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/pages/Loader.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';
import 'ChangeSocialCause.dart';

class Onboarding extends StatefulWidget {
  final String name;

  const Onboarding({Key key, this.name}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  Artboard _riveArtboard1;
  RiveAnimationController _controller1;
  Artboard _riveArtboard2;
  RiveAnimationController _controller2;
  Artboard _riveArtboard3;
  RiveAnimationController _controller3;
  Artboard _riveArtboard4;
  RiveAnimationController _controller4;

  createArtboard2() {
    rootBundle.load('assets/images/Onboarding/On_boarding_focus.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        setState(() => _riveArtboard2 = artboard);

        _riveArtboard2
            .addController(_controller2 = SimpleAnimation('Select_tempo'));
      },
    );
  }

  createArtboard3() {
    rootBundle.load('assets/images/Onboarding/On_boarding_focus.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        setState(() => _riveArtboard3 = artboard);

        _riveArtboard3.addController(_controller3 = SimpleAnimation('Focus'));
      },
    );
  }

  createArtboard4() {
    rootBundle.load('assets/images/Onboarding/coupon_animation.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        setState(() => _riveArtboard4 = artboard);

        _riveArtboard4
            .addController(_controller4 = SimpleAnimation('Animation 1'));
      },
    );
  }

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/images/Onboarding/On_boarding_focus.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller1 = SimpleAnimation('Bolla_loop'));
        setState(() => _riveArtboard1 = artboard);
      },
    );
  }

  PageController _pageController = new PageController();
  PageController _pageController1 = new PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            color: _currentIndex >= 2
                ? new Color(0xFFFFF8ED)
                : new Color(0xFF190E3B),
            duration: Duration(milliseconds: 500)),
        FadeIn(2, OnboardingBackground(state: _currentIndex)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  FadeIn(
                    1.5,
                    _riveArtboard1 == null
                        ? Container()
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.38,
                            width: MediaQuery.of(context).size.height * 0.38,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 400),
                              child: _currentIndex < 3
                                  ? Transform.scale(
                                      child: Stack(
                                        children: [
                                          Rive(artboard: _riveArtboard1),
                                          _riveArtboard2 == null
                                              ? Container()
                                              : Opacity(
                                                  child: Rive(
                                                      artboard: _riveArtboard2),
                                                  opacity: _currentIndex == 1
                                                      ? 1
                                                      : 0),
                                          _riveArtboard3 == null
                                              ? Container()
                                              : Rive(artboard: _riveArtboard3),
                                        ],
                                      ),
                                      scale: 1.4)
                                  : _riveArtboard4 == null
                                      ? Container()
                                      : Rive(artboard: _riveArtboard4),
                            )),
                  ),
                  SlideYFadeInBottom(
                    0.5,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: [
                          Page(
                              index: _currentIndex,
                              widget: widget,
                              title: "welcome".tr() + widget.name + ",",
                              text: "show-spa".tr()),
                          Page(
                              index: _currentIndex,
                              widget: widget,
                              title: "relax".tr(),
                              text: "relax-text".tr()),
                          Page(
                              index: _currentIndex,
                              widget: widget,
                              title: "improvefocus".tr(),
                              text: "improvefocus-text".tr()),
                          Page(
                              index: _currentIndex,
                              widget: widget,
                              title: "efforts".tr(),
                              text: "efforts-text".tr()),
                        ],
                      ),
                    ),
                  ),
                  SlideYFadeInBottom(
                    1,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: DotsIndicator(
                        dotsCount: 4,
                        position: _currentIndex.toDouble(),
                        decorator: DotsDecorator(
                          color: _currentIndex < 2
                              ? Colors.white24
                              : new Color(0xFF190E3B)
                                  .withOpacity(.4), // Inactive color
                          activeColor: _currentIndex < 2
                              ? Colors.white
                              : new Color(0xFF190E3B),
                        ),
                      ),
                    ),
                  ),
                  SlideYFadeInBottom(
                    1.5,
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 66,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          controller: _pageController1,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RectangleButton(
                                width: MediaQuery.of(context).size.width * 0.8,
                                onTap: () {
                                  _currentIndex = 1;
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);
                                  _pageController1.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);

                                  createArtboard2();
                                },
                                color: new Color(0xFFFF6926),
                                text: "curious".tr().toUpperCase(),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RectangleButton(
                                onTap: () {
                                  _currentIndex = 2;
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);
                                  _pageController1.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);

                                  _riveArtboard2.remove();
                                  createArtboard3();
                                },
                                color: new Color(0xFFFF6926),
                                text: "sweet".tr().toUpperCase(),
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RectangleButton(
                                onTap: () {
                                  _currentIndex = 3;
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);
                                  _pageController1.nextPage(
                                      duration: Duration(milliseconds: 650),
                                      curve: Curves.easeInOutQuad);

                                  createArtboard4();
                                },
                                color: new Color(0xFFFF6926),
                                text: "mind-ready".tr().toUpperCase(),
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RectangleButton(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OnboardingReady()));
                                },
                                color: new Color(0xFFFF6926),
                                text: "letsdoit".tr().toUpperCase(),
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    Key key,
    @required this.widget,
    this.title,
    this.text,
    this.index,
  }) : super(key: key);

  final Onboarding widget;
  final String title;
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      0.6,
      Column(
        children: [
          AutoSizeText(title,
              style: TextStyle(
                  fontFamily: "GrandSlang",
                  fontSize: 23,
                  color: index < 2 ? Colors.white : new Color(0xFF190E3B))),
          SizedBox(height: 40),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(text,
                  maxLines: 5,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins-Light",
                      color: index < 2 ? Colors.white : new Color(0xFF190E3B)),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class OnboardingReady extends StatefulWidget {
  @override
  _OnboardingReadyState createState() => _OnboardingReadyState();
}

class _OnboardingReadyState extends State<OnboardingReady> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/images/Onboarding/welcome_bolla.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color(0xFFFFF8ED),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FadeIn(3, Background()),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 60, sigmaX: 60),
            child: Stack(
              children: [
                _riveArtboard == null
                    ? Container()
                    : SlideYFadeInBottom(
                        2,
                        Transform.scale(
                            child: Rive(artboard: _riveArtboard),
                            scale: MediaQuery.of(context).size.width * 0.004)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SlideYFadeInBottom(
                        1,
                        Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.18),
                            Text("ready".tr(),
                                style: TextStyle(
                                    fontFamily: "GrandSlang",
                                    fontSize: 23,
                                    color: new Color(0xFF190E3B))),
                            SizedBox(height: 15),
                            Text("ready-text".tr(),
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 12,
                                    color: new Color(0xFF190E3B)),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    SlideYFadeIn(
                      1.5,
                      Column(
                        children: [
                          RectangleButton(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              pushWithFade(
                                  context,
                                  Loader(
                                      uuid: prefs.getString("uuid"),
                                      company: prefs.getString("company")),
                                  500);
                            },
                            text: "explore".tr().toUpperCase(),
                            color: new Color(0xFFFF6926),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
