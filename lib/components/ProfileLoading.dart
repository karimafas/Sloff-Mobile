import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/LoadingChallenges.dart';
import 'package:sloff/pages/ChangeSocialCause.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<ProfileLoading> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: new Color(0xFFFFF8ED)),
        Background(),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Shimmer.fromColors(
            baseColor: new Color(0xFFB9B9B9),
            highlightColor: Colors.white.withOpacity(0.4),
            child: Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  backgroundColor: Colors.transparent,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontFamily: "GrandSlang",
                            fontSize: 24,
                            color: new Color(0xFF190E3B))),
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    Padding(
                        padding: new EdgeInsets.only(right: 15),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/Profilo/Menu.svg',
                            fit: BoxFit.cover,
                            height: 16,
                          ),
                        )),
                  ],
                  elevation: 0,
                ),
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 130,
                                width: 100,
                                child: GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String uuid = prefs.getString('uuid');

                                      FirebaseFirestore.instance
                                          .collection('users_cause')
                                          .doc(uuid)
                                          .get()
                                          .then((value) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CambioCausa(
                                                      selectedCauseIndex:
                                                          value['cause'],
                                                      inside: true,
                                                    )));
                                      });
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                          ),
                                          Container(
                                            height: 6,
                                          ),
                                          Text(
                                            'Causa'.tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: new Color(0xFF694EFF),
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ])),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey),
                                    ),
                                    Container(
                                      height: 10,
                                    )
                                  ]),
                              SizedBox(
                                height: 130,
                                width: 100,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(height: 17),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                              child: SvgPicture.asset(
                                                  "assets/images/Coupon/focus.svg",
                                                  height: 50,
                                                  width: 50)),
                                        ],
                                      ),
                                      Container(
                                        height: 6,
                                      ),
                                      Text(
                                        'Focus'.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: new Color(0xFF190E3B),
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ''.tr(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        )),
                    Container(
                        child: Text(
                      "Sloff",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: new Color(0xFF190E3B),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 10),
                    Container(
                        height: 40,
                        width: 270,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6))),
                    Container(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                  'assets/images/Profilo/Coupon_da_utilizzare.svg'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CouponProfilo'.tr() + ' ',
                                  style: TextStyle(
                                      color: new Color(0xFF190E3B),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )),
                          ],
                        )),
                    Container(
                      height: 10,
                    ),
                    Container(
                        height: 1.5,
                        width: MediaQuery.of(context).size.width * 0.85,
                        color: Colors.grey.withOpacity(.2)),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => MockReward(),
                      itemCount: 1,
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "profile-end-1".tr(),
                            style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: new Color(0xFF190E3B)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "profile-end-2".tr(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "profile-end-3".tr()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ))),
          ),
        ),
      ],
    );
  }
}
