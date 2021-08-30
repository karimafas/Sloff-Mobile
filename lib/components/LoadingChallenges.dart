import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class LoadingChallenges extends StatelessWidget {
  const LoadingChallenges({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(.3),
      highlightColor: Colors.white.withOpacity(.05),
      child: Column(
        children: [
          MockChallengesTitle(),
          Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.grey),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [MockReward(), MockReward()],
            ),
          )
        ],
      ),
    );
  }
}

class MockChallengesTitle extends StatelessWidget {
  const MockChallengesTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Reward",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontFamily: "GrandSlang",
                  fontSize: 24,
                  color: new Color(0xFF190E3B))),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {},
                            child: SizedBox(
                                height: 56,
                                width: 56,
                                child: SvgPicture.asset(
                                    "assets/images/Coupon/focus.svg")),
                          ),
                        ],
                      ),
                    )
                  ])),
        ],
      ),
    );
  }
}

class MockReward extends StatelessWidget {
  const MockReward({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: Container(
          width: 600,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: 375,
                child: Transform.scale(
                  scale: MediaQuery.of(context).size.width * 0.0024,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Coupon/Coupon.svg',
                        fit: BoxFit.fill,
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: new Container(
                              width: 300,
                              child: Column(
                                children: [
                                  Container(
                                    height: 54,
                                    width: 54,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          'assets/images/Coupon/Star.svg',
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: new Color(0xFF694EFF),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 0.0,
                                            maxWidth: 160.0,
                                            minHeight: 20.0,
                                            maxHeight: 100.0,
                                          ),
                                          child: Text("1"))),
                                  SizedBox.fromSize(),
                                  Container(
                                    height: 10,
                                  ),
                                ],
                              ))),
                      Positioned(left: 0, top: 25, child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
