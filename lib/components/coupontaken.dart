import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sloff/pages/coupon/coupondetail.dart';
import 'package:sloff/pages/coupon/couponuse.dart';
import 'package:sloff/pages/coupon/couponconfirm.dart';
import 'package:clipboard/clipboard.dart';
import 'package:sloff/pages/coupon/couponeliminate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponTaken extends StatelessWidget {
  final String title;
  final String couponid;
  final String text;
  final String logo;
  final Timestamp elapsed;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool arrow;
  final bool mini;
  final int status;
  final String brand;
  final int total;
  final int userfocus;
  final String id;
  final String code;
  final int totalnumber;
  final bool fromProfile;
  final String uuid;
  final int userfocusdetail;
  final bool isusing;
  final bool cardReward;
  final String value;
  final String challengeID;
  final bool isGroup;
  final Timestamp endDate;
  final Timestamp validUntil;
  final Function callback;
  final Function redeemCallback;

  const CouponTaken(
      {Key key,
      this.text,
      this.couponid,
      this.userfocusdetail = 0,
      this.id,
      this.title,
      this.onTap,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.arrow = true,
      this.mini = false,
      this.status,
      this.logo = '',
      this.elapsed,
      this.brand,
      this.total,
      this.userfocus,
      this.code,
      this.totalnumber = 0,
      this.fromProfile = false,
      this.uuid = '',
      this.isusing = false,
      this.cardReward,
      this.value,
      this.challengeID,
      this.isGroup,
      this.endDate,
      this.validUntil,
      this.callback,
      this.redeemCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String differenceDisplay = "";
    final formatter = new DateFormat('dd-MM-yyyy');

    if (endDate != null) {
      DateTime dtEnd = endDate.toDate();
      Duration difference = dtEnd.difference(DateTime.now());

      if (difference.inHours > 48) {
        differenceDisplay = "Giorni-rimanenti"
            .tr(namedArgs: {'days': difference.inDays.toString()});
      } else {
        differenceDisplay = "Ore-rimanenti"
            .tr(namedArgs: {'hours': difference.inHours.toString()});
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: !isusing ? 280 : 300,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 0,
              top: 27,
              right: 0,
              bottom: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      height: 200,
                      width: 350,
                      child: SvgPicture.asset(
                        'assets/images/Coupon/Coupon_grigio.svg',
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(.2),
                      ),
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 300,
                        width: 500,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: status == 4
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 23),
                                child: SvgPicture.asset(
                                    'assets/images/Coupon/Coupon_da_riscattare.svg',
                                    fit: BoxFit.cover,
                                    color: new Color(0xFF190E3B)),
                              )
                            : status == 5
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 23),
                                    child: SvgPicture.asset(
                                      'assets/images/Profilo/Coupon_aperto.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : status == 3
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 23),
                                        child: SvgPicture.asset(
                                            'assets/images/Coupon/Coupon_da_riscattare.svg',
                                            fit: BoxFit.cover,
                                            color: new Color(0xFF190E3B)),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 23),
                                        child: SvgPicture.asset(
                                          'assets/images/Coupon/Coupon.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: new Container(
                          width: 300,
                          child: Column(
                            children: [
                              GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String company = prefs.getString('company');
                                    String user = prefs.getString('uuid');

                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            CouponDetail(
                                          challengeID: challengeID,
                                          id: id,
                                          company: company,
                                          uuid: user,
                                          fromprofile: fromProfile,
                                          status: status,
                                          focushour: userfocus,
                                          brand: brand,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 55,
                                    width: 55,
                                    child: SvgPicture.asset('assets/images/Coupon/Star.svg'),
                                    decoration: BoxDecoration(
                                        color: new Color(0xFF694EFF),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  )),
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
                                    child: AutoSizeText(
                                      brand,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        color: status >= 3
                                            ? Colors.white
                                            : new Color(0xFF190E3B),
                                        fontWeight: FontWeight.w800,
                                        //height: 1.15385,
                                      ),
                                    ),
                                  )),
                              SizedBox.fromSize(),
                              Container(
                                height: 10,
                              ),
                              cardReward
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          top: 2, left: 50, right: 50),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Gift card",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: status >= 3
                                                    ? Colors.white
                                                    : new Color(0xFF190E3B),
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "worth  ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: status >= 3
                                                        ? Colors.white
                                                        : new Color(0xFF190E3B),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'Poppins-Regular'),
                                              ),
                                              Text(
                                                "€$value",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        new Color(0xFFFF6926),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'Poppins-Regular'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                  : Container(
                                      height: 50,
                                      padding: EdgeInsets.only(
                                          top: 2, left: 50, right: 50),
                                      child: Text(
                                        text,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: status >= 3
                                                ? Colors.white
                                                : new Color(0xFF190E3B),
                                            fontSize: 13,
                                            fontFamily: 'Poppins-Regular'),
                                      ),
                                    ),
                              Container(
                                height: 10,
                              ),
                              status == 4
                                  ? AnimatedSwitcher(
                                      duration: Duration(milliseconds: 400),
                                      child: !isGroup && cardReward
                                          ? GestureDetector(
                                              onTap: callback,
                                              child: Container(
                                                margin: EdgeInsets.only(top: 5),
                                                width: 180,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF6926),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Utilizza"
                                                          .tr()
                                                          .toUpperCase(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          : isGroup && validUntil != null
                                              ? Text(
                                                  "Valido".tr() +
                                                      formatter.format(
                                                          validUntil.toDate()),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white))
                                              : Container(),
                                    )
                                  : status == 3
                                      ? GestureDetector(
                                          onTap: redeemCallback == null
                                              ? () {}
                                              : redeemCallback,

                                          /*return Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                  builder: (BuildContext
                                                          context) =>
                                                      CouponConfirm(
                                                          id: id,
                                                          focushour: userfocus,
                                                          couponid: couponid
                                                          //fromlogin: true,
                                                          //userName: user.user.uid,
                                                          ),
                                                ),
                                              );*/
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5),
                                            width: 160,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: new Color(0xFFFF6926),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Riscatta".tr().toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : status == 5
                                          ? Container(
                                              padding: EdgeInsets.only(top: 65),
                                              child: code != ''
                                                  ? RaisedButton(
                                                      color: Color(0xffFF7E05),
                                                      child: Text(
                                                        code,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      onPressed: () {
                                                        FlutterClipboard.copy(
                                                                code)
                                                            .then((result) {
                                                          final snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'Codice copiato'),
                                                            action:
                                                                SnackBarAction(
                                                              label: 'Annulla',
                                                              onPressed: () {},
                                                            ),
                                                          );
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        });
                                                      },
                                                    )
                                                  : Container())
                                          : Column(
                                              children: [
                                                Container(
                                                  height: 10,
                                                ),
                                                Text(
                                                  ((userfocusdetail * 100) /
                                                              (total * 60))
                                                          .toStringAsFixed(1) +
                                                      '%',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                new Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child:
                                                        LinearPercentIndicator(
                                                      //width: MediaQuery.of(context).size.width - 50,
                                                      animation: true,
                                                      lineHeight: 8.0,
                                                      animationDuration: 2000,
                                                      percent:
                                                          ((userfocusdetail *
                                                                      100) /
                                                                  (total *
                                                                      60)) /
                                                              100,
                                                      //center: Text("90.0%"),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor:
                                                          Color(0xFFA8E35A),
                                                      backgroundColor:
                                                          Colors.black,
                                                    )),
                                              ],
                                            )
                            ],
                          ))),
                  Positioned(
                      left: 0, //23.5,
                      top: 25, //18,
                      child: Container()),
                  status < 4 ? Container() : Container(),
                  status > 3
                      ? Container()
                      : Positioned(
                          left: 23,
                          top: 30,
                          child: Container(
                            width: 100,
                            //margin: EdgeInsets.only(left: 15),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: totalnumber < 20
                                  ? Color(0xffFF0F5F)
                                  : Colors.blueAccent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0)),
                            ),
                            child: !isGroup
                                ? Text(
                                    //"Utilizza entro\n5 g : 23 h : 59 m",
                                    totalnumber < 20
                                        ? "only-rewards".tr(namedArgs: {
                                            "number": totalnumber.toString()
                                          })
                                        : "rewards-left".tr(namedArgs: {
                                            "number": totalnumber.toString()
                                          }),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.15385,
                                    ),
                                  )
                                : Text(
                                    differenceDisplay.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.15385,
                                    ),
                                  ), //),
                          ),
                        ),
                  status < 4
                      ? Positioned(
                          right: 23,
                          top: 30,
                          child: Container(
                              width: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff9BDB46),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0)),
                              ),
                              //child:
                              // color: Colors.pink,
                              // new Flexible(
                              child: Text(
                                status < 3 &&
                                        (total * 60) - userfocusdetail >= 120 &&
                                        (total * 60) - userfocusdetail > 0
                                    ? "hours-missing".tr(namedArgs: {
                                        "hours": (total - userfocus).toString()
                                      })
                                    : status < 3 &&
                                            (total * 60) - userfocusdetail <
                                                120 &&
                                            (total * 60) - userfocusdetail > 0
                                        ? "minutes-missing".tr(namedArgs: {
                                            "minutes":
                                                ((total * 60) - userfocusdetail)
                                                    .toString()
                                          })
                                        : ((total * 60) - userfocusdetail) <= 0
                                            ? "time-unlock"
                                            : "",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  letterSpacing: -0.39,
                                  height: 1.15385,
                                ),
                              ) //),
                              ),
                        )
                      : fromProfile
                          ? Positioned(
                              right: 30, //23.5,
                              top: 36,
                              child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => CouponEliminate(
                                              id: id, uuid: uuid))),
                                  child: //18,
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(Icons.cancel,
                                              color: Color(0xFFFF6926)))))
                          : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Coupon extends StatelessWidget {
  final String title;
  final String couponid;
  final String text;
  final String logo;
  final Timestamp elapsed;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool arrow;
  final bool mini;
  final int status;
  final String brand;
  final int total;
  final int userfocus;
  final String id;
  final String code;
  final int totalnumber;
  final bool fromProfile;
  final String uuid;
  final int userfocusdetail;
  final bool isusing;
  final bool cardReward;
  final String value;
  final String challengeID;
  final bool isGroup;
  final Timestamp endDate;
  final Timestamp validUntil;
  final Function useCoupon;
  final Function redeemCallback;
  final Function deleteCoupon;

  const Coupon(
      {Key key,
      this.text,
      this.couponid,
      this.userfocusdetail = 0,
      this.id,
      this.title,
      this.onTap,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.arrow = true,
      this.mini = false,
      this.status,
      this.logo = '',
      this.elapsed,
      this.brand,
      this.total,
      this.userfocus,
      this.code,
      this.totalnumber = 0,
      this.fromProfile = false,
      this.uuid = '',
      this.isusing = false,
      this.cardReward,
      this.value,
      this.challengeID,
      this.isGroup,
      this.endDate,
      this.validUntil,
      this.useCoupon,
      this.redeemCallback,
      this.deleteCoupon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String differenceDisplay = "";
    final formatter = new DateFormat('dd-MM-yyyy');

    if (endDate != null) {
      DateTime dtEnd = endDate.toDate();
      Duration difference = dtEnd.difference(DateTime.now());

      if (difference.inHours > 48) {
        differenceDisplay = "Giorni-rimanenti"
            .tr(namedArgs: {'days': difference.inDays.toString()});
      } else {
        differenceDisplay = "Ore-rimanenti"
            .tr(namedArgs: {'hours': difference.inHours.toString()});
      }
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/images/Coupon/Coupon.svg',
            fit: BoxFit.fill, color: Colors.black.withOpacity(.14)),
        ClipRect(
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
                    child: GestureDetector(
                      onTap: onTap,
                      child: Transform.scale(
                        scale: MediaQuery.of(context).size.width * 0.0024,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            status == 4
                                ? SvgPicture.asset(
                                    'assets/images/Coupon/Coupon.svg',
                                    fit: BoxFit.fill,
                                    color: new Color(0xFF190E3B))
                                : status == 5
                                    ? SvgPicture.asset(
                                        'assets/images/Profilo/Coupon.svg',
                                        fit: BoxFit.fill,
                                      )
                                    : status == 3
                                        ? SvgPicture.asset(
                                            'assets/images/Coupon/Coupon.svg',
                                            fit: BoxFit.fill,
                                            color: new Color(0xFF190E3B))
                                        : SvgPicture.asset(
                                            'assets/images/Coupon/Coupon.svg',
                                            fit: BoxFit.fill,
                                          ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: new Container(
                                    width: 300,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String company =
                                                  prefs.getString('company');
                                              String user =
                                                  prefs.getString('uuid');

                                              Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CouponDetail(
                                                    challengeID: challengeID,
                                                    id: id,
                                                    company: company,
                                                    uuid: user,
                                                    fromprofile: fromProfile,
                                                    status: status,
                                                    focushour: userfocus,
                                                    brand: brand,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 54,
                                              width: 54,
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: SvgPicture.asset('assets/images/Coupon/Star.svg', color: Colors.white),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: new Color(0xFF694EFF),
                                                  borderRadius:
                                                  BorderRadius.circular(100)),
                                            )),
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
                                              child: AutoSizeText(
                                                brand,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  color: status >= 3
                                                      ? Colors.white
                                                      : new Color(0xFF190E3B),
                                                  fontWeight: FontWeight.w800,
                                                  //height: 1.15385,
                                                ),
                                              ),
                                            )),
                                        SizedBox.fromSize(),
                                        Container(
                                          height: 10,
                                        ),
                                        cardReward
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    top: 2,
                                                    left: 50,
                                                    right: 50),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Gift card",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: status >= 3
                                                              ? Colors.white
                                                              : new Color(
                                                                  0xFF190E3B),
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "worth  ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: status >= 3
                                                                  ? Colors.white
                                                                  : new Color(
                                                                      0xFF190E3B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Poppins-Regular'),
                                                        ),
                                                        Text(
                                                          "€$value",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: new Color(
                                                                  0xFFFF6926),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Poppins-Regular'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                            : Container(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    top: 2,
                                                    left: 50,
                                                    right: 50),
                                                child: Text(
                                                  text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: status >= 3
                                                          ? Colors.white
                                                          : new Color(
                                                              0xFF190E3B),
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'Poppins-Regular'),
                                                ),
                                              ),
                                        Container(
                                          height: 10,
                                        ),
                                        status == 4
                                            ? AnimatedSwitcher(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                child: !isGroup && cardReward
                                                    ? GestureDetector(
                                                        onTap: useCoupon,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          width: 180,
                                                          height: 34,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFFF6926),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Utilizza"
                                                                    .tr()
                                                                    .toUpperCase(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    : isGroup &&
                                                            validUntil != null
                                                        ? Text(
                                                            "Valido".tr() +
                                                                formatter.format(
                                                                    validUntil
                                                                        .toDate()),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white))
                                                        : Container(),
                                              )
                                            : status == 3
                                                ? GestureDetector(
                                                    onTap: redeemCallback,
                                                    /*() => Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext context) => CouponConfirm(
                                                                    id: id,
                                                                    focushour:
                                                                        userfocus,
                                                                    couponid:
                                                                        couponid
                                                                    //fromlogin: true,
                                                                    //userName: user.user.uid,
                                                                    ),
                                                              ),
                                                            ),*/
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      width: 160,
                                                      height: 34,
                                                      decoration: BoxDecoration(
                                                        color: new Color(
                                                            0xFFFF6926),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    6)),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Riscatta"
                                                                .tr()
                                                                .toUpperCase(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : status == 5
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 65),
                                                        child: code != ''
                                                            ? RaisedButton(
                                                                color: Color(
                                                                    0xffFF7E05),
                                                                child: Text(
                                                                  code,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                                onPressed: () {
                                                                  FlutterClipboard
                                                                          .copy(
                                                                              code)
                                                                      .then(
                                                                          (result) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                      content: Text(
                                                                          'Codice copiato'),
                                                                      action:
                                                                          SnackBarAction(
                                                                        label:
                                                                            'Annulla',
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                                    );
                                                                    Scaffold.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  });
                                                                },
                                                              )
                                                            : Container())
                                                    : Column(
                                                        children: [
                                                          Container(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            ((userfocusdetail *
                                                                            100) /
                                                                        (total *
                                                                            60))
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                '%',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Container(
                                                            height: 5,
                                                          ),
                                                          new Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child:
                                                                  LinearPercentIndicator(
                                                                //width: MediaQuery.of(context).size.width - 50,
                                                                animation: true,
                                                                lineHeight: 8.0,
                                                                animationDuration:
                                                                    2000,
                                                                percent: ((userfocusdetail *
                                                                            100) /
                                                                        (total *
                                                                            60)) /
                                                                    100,
                                                                //center: Text("90.0%"),
                                                                linearStrokeCap:
                                                                    LinearStrokeCap
                                                                        .roundAll,
                                                                progressColor:
                                                                    Color(
                                                                        0xff9BDB46),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                              )),
                                                        ],
                                                      )
                                      ],
                                    ))),
                            Positioned(
                                left: 0, //23.5,
                                top: 25, //18,
                                child: Container()),
                            status < 4 ? Container() : Container(),
                            status > 3
                                ? Container()
                                : Positioned(
                                    left: 0,
                                    top: 22.5,
                                    child: Container(
                                      width: 110,
                                      height: 52,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: totalnumber < 20
                                            ? Color(0xFFFF4E4E)
                                            : Colors.blueAccent,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      child: !isGroup
                                          ? Center(
                                              child: Text(
                                                //"Utilizza entro\n5 g : 23 h : 59 m",
                                                totalnumber < 20
                                                    ? "only-rewards".tr(namedArgs: {
                                                  "number": totalnumber.toString()
                                                })
                                                    : "rewards-left".tr(namedArgs: {
                                                  "number": totalnumber.toString()
                                                }),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  height: 1.15385,
                                                ),
                                              )
                                            )
                                          : Center(
                                              child: Text(
                                                differenceDisplay.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  height: 1.15385,
                                                ),
                                              ),
                                            ), //),
                                    ),
                                  ),
                            status < 4
                                ? Positioned(
                                    right: 0,
                                    top: 22.5,
                                    child: Container(
                                        width: 110,
                                        height: 52,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFA8E35A),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                        //child:
                                        // color: Colors.pink,
                                        // new Flexible(
                                        child: Center(
                                          child: Text(
                                            status < 3 &&
                                                    (total * 60) -
                                                            userfocusdetail >=
                                                        120 &&
                                                    (total * 60) -
                                                            userfocusdetail >
                                                        0
                                                ? "hours-missing".tr(namedArgs: {
                                              "hours": (total - userfocus).toString()
                                            })
                                                : status < 3 &&
                                                (total * 60) - userfocusdetail <
                                                    120 &&
                                                (total * 60) - userfocusdetail > 0
                                                ? "minutes-missing".tr(namedArgs: {
                                              "minutes":
                                              ((total * 60) - userfocusdetail)
                                                  .toString()
                                            })
                                                : ((total * 60) - userfocusdetail) <= 0
                                                ? "time-unlock".tr()
                                                : "",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              height: 1.15385,
                                            ),
                                          ),
                                        ) //),
                                        ),
                                  )
                                : fromProfile
                                    ? Positioned(
                                        right: 20, //23.5,
                                        top: 40,
                                        child: GestureDetector(
                                            onTap: deleteCoupon,
                                            child: //18,
                                                Container(
                                                    child: Icon(Icons.cancel,
                                                        color: Color(
                                                            0xFFFF6926)))))
                                    : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
