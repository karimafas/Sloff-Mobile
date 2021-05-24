import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/Background.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:sloff/pages/cambiocausa.dart';
import 'package:sloff/pages/profile/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  GlobalKey<ScaffoldState> _drawerKey = new GlobalKey();
  String name = '';
  String uuidhere = '';
  String company;

  Stream stream;
  String cause;
  List<String> images = [
    'assets/images/Cause/1.jpeg',
    'assets/images/Cause/2.jpeg',
    'assets/images/Cause/3.jpeg',
    'assets/images/Cause/4.jpeg',
    'assets/images/Cause/5.jpeg',
    'assets/images/Cause/6.jpeg',
    'assets/images/Cause/7.jpeg',
    'assets/images/Cause/8.jpeg',
  ];

  ScrollController _controller = new ScrollController();

  void fetchname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = await prefs.getString('uuid');
    String companyh = await prefs.getString('company');

    setState(() {
      company = companyh;
      uuidhere = uuid;
    });
    print('fetchname');

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();
    DocumentSnapshot bb = await FirebaseFirestore.instance
        .collection('users_cause')
        .doc(uuid)
        .get();
    print('doc ' + aa.toString());

    setState(() {
      if (aa['name'].toString() == '') {
        name = '     ';
      } else {
        name = aa['name'].toString();
      }
      if (bb['cause'].toString() == '') {
        cause = '';
      } else {
        cause = bb['cause'].toString();
      }
      print('cause' + cause);
    });
  }


  void initState() {
    super.initState();
    fetchname();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: new Color(0xFFFFF8ED)),
        Background(),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Scaffold(
              key: _drawerKey,
              endDrawer: Theme(
                child: DrawerUiWidget(),
                data: Theme.of(context).copyWith(
                  canvasColor: Colors
                      .transparent,
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: SlideYFadeInBottom(
                  1, Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Profilo".tr(),
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontFamily: "GrandSlang",
                            fontSize: 24,
                            color: new Color(0xFF190E3B))),
                  ),
                ),
                centerTitle: false,
                actions: <Widget>[
                  SlideYFadeInBottom(
                    1.2, GestureDetector(
                      onTap: () => _drawerKey.currentState.openEndDrawer(),
                      child: Padding(
                          padding: new EdgeInsets.only(right: 15),
                          child: IconButton(
                              icon: SvgPicture.asset(
                            'assets/images/Profilo/Menu.svg',
                            fit: BoxFit.cover,
                            height: 16,
                          ))),
                      //onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
                elevation: 0,
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  controller: _controller,
                  //height: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SlideYFadeInBottom(
                        0.6, Container(
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

                                          var doc = FirebaseFirestore.instance
                                              .collection('users_cause')
                                              .doc(uuid).get().then((value) {
                                            print(value['cause']);

                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                builder: (context) => CambioCausa(
                                                  selectedCauseIndex: value['cause'],
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
                                              uuidhere != ''
                                                  ? StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'users_cause')
                                                          .doc(uuidhere)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Container();
                                                        } else if (!snapshot
                                                            .data.exists) {
                                                          return Container();
                                                        } else {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage: snapshot
                                                                            .data[
                                                                        'cause'] !=
                                                                    ''
                                                                ? AssetImage(
                                                                    images[snapshot
                                                                            .data[
                                                                        'cause']],
                                                                  )
                                                                : NetworkImage(
                                                                    'https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Animal_Equality.png?alt=media&token=d0fd5b14-6e68-4c22-b088-54bab84312be'),
                                                          );
                                                        }
                                                      })
                                                  : Container(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            child: Icon(Icons.photo_camera_outlined, color: Colors.white.withOpacity(.7)),
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.grey),
                                          ),
                                          onTap: () {
                                          },
                                        ),
                                        Container(
                                          height: 10,
                                        )
                                      ]),
                                  SizedBox(
                                    height: 130,
                                    width: 100,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                              StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users_company')
                                                      .doc(company)
                                                      .collection('challenge')
                                                      .where('elapsed_time',
                                                          isGreaterThan:
                                                              DateTime.now())
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                          ((0).toInt())
                                                                  .toString() +
                                                              " h",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold));
                                                    } else if (snapshot
                                                            .data.docs.length ==
                                                        0) {
                                                      return Text(
                                                          (0).toString() + "h",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold));
                                                    } else {
                                                      return StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users_company')
                                                              .doc(company)
                                                              .collection(
                                                                  'challenge')
                                                              .doc(snapshot.data
                                                                  .docs[0].id)
                                                              .collection('focus')
                                                              .doc(uuidhere)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshots) {
                                                            if (!snapshots
                                                                .hasData) {
                                                              return Text(
                                                                  ((0).toInt())
                                                                          .toString() +
                                                                      " h",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold));
                                                            } else {
                                                              if (!snapshots
                                                                  .data.exists) {
                                                                return Text(
                                                                    ((0).toInt())
                                                                            .toString() +
                                                                        " h",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold));
                                                              } else {
                                                                return Text(
                                                                    ((snapshots.data['available'] / 60)
                                                                                .toInt())
                                                                            .toString() +
                                                                        " h",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold));
                                                              }
                                                            }
                                                          });
                                                    }
                                                  }),
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
                      ),
                      Container(
                          child: Text(
                        name.trim() != '' ? name.capitalize() : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: new Color(0xFF190E3B),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 10),
                      SlideYFadeInBottom(
                        0.6, Container(
                          height: 40,
                          width: 270,
                          decoration: BoxDecoration(
                              color: new Color(0xFFFFE8C1).withOpacity(.5),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("CO1".tr(), style: TextStyle(fontSize: 13)),
                              Text("CO2".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13)),
                              Text("CO3".tr(), style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      SlideYFadeInBottom(
                        0.4, Container(
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
                      ),
                      Container(
                        height: 10,
                      ),
                      SlideYFadeInBottom(
                        0.2, Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width * 0.85,
                            color: Colors.grey.withOpacity(.2)),
                      ),
                      uuidhere != ''
                          ? SlideYFadeInBottom(
                            0, StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users_coupon')
                                    .doc(uuidhere)
                                    .collection(uuidhere)
                                    .orderBy('redeemed_at', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  if (snapshot.hasError) {
                                    return Container();
                                  } else {
                                    print(snapshot.data.docs.length);
                                    return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => buildItem(
                                          context, snapshot.data.docs[index]),
                                      itemCount: snapshot.data.docs.length,
                                    );
                                  }
                                }),
                          )
                          : Container(),
                      SizedBox(height: 10),
                      SlideYFadeInBottom(
                        0, Column(
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
                      ),
                      SizedBox(height: 30),
                    ],
                  ))),
        ),
      ],
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {


    useCoupon() {
      AlertDialog alert = AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                //height: MediaQuery.of(context).size.height * 0.53,
                child: Column(
                  children: [
                    SizedBox(
                        child: Image.asset('assets/images/Coupon/Unlock_prize.png'),
                        width: MediaQuery.of(context).size.width * 0.8),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "redeem-title"
                              .tr(namedArgs: {'brand': document['brand']}),
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 23,
                              fontFamily: 'GrandSlang',
                              color: new Color(0xFF190E3B)),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                      width: 240,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: new Color(0xFFFF6926), width: 2)),
                      child: Center(
                        child: Text(document['code'],
                            style: TextStyle(
                                color: new Color(0xFFFF6926),
                                fontSize: 16,
                                fontFamily: 'Poppins-Regular')),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    RectangleButton(
                      onTap: () => Navigator.pop(context),
                      text: "skip".tr(),
                      color: new Color(0xFFA4A0B2),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }

    deleteCoupon() {
      AlertDialog alert = AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "delete-reward"
                              .tr(),
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 23,
                              fontFamily: 'GrandSlang',
                              color: new Color(0xFF190E3B)),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Center(
                      child: Text("delete-sure".tr(),
                          style: TextStyle(
                              color: new Color(0xFF190E3B),
                              fontSize: 12,
                              fontFamily: 'Poppins-Regular')),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    RectangleButton(
                      onTap: () async {
                        var postID = document.id;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String uuid = prefs.getString('uuid');
                        FirebaseFirestore.instance
                            .collection('users_coupon')
                            .doc(uuid)
                            .collection(uuid)
                            .doc(postID)
                            .update({"visible": false}).then(
                                (value) => Navigator.of(context).pop());
                      },
                      text: "delete".tr().toUpperCase(),
                      color: new Color(0xFFFF6926),
                    ),
                    SizedBox(height: 10),
                    RectangleButton(
                      onTap: () => Navigator.pop(context),
                      text: "cancel".tr().toUpperCase(),
                      color: new Color(0xFFA4A0B2),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }

    if (document['visible']) {
      print("SIZE" + MediaQuery.of(context).size.height.toString());
      if (document['valid_until'] != null &&
          DateTime.now().isAfter(document['valid_until'].toDate())) {
        return Container();
      } else {
        return Container(
            color: Colors.transparent,
            child: Coupon(
                useCoupon: useCoupon,
                deleteCoupon: deleteCoupon,
                challengeID: '',
                status: 4,
                isGroup: document['group'],
                validUntil: document['valid_until'],
                title: document['title'],
                text: document['description'],
                brand: document['brand'],
                cardReward: document['type'] == 'Libero' ? false : true,
                value: !document['group'] ? document['value'].toString() : '0',
                total: document['total_focus'],
                userfocus: 0,
                id: document.id,
                totalnumber: document['total_coupon'],
                elapsed: document['elapsed_time'],
                uuid: uuidhere,
                fromProfile: true,
                code: document['code']));
      }
    } else {
      return Container();
    }
  }
}
