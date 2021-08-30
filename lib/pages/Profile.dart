import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/FadeNavigation.dart';
import 'package:sloff/components/SloffMethods.dart';
import 'package:sloff/components/Reward.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/components/SloffModals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/components/ProfileMenu.dart';
import 'package:sloff/pages/Charts.dart';
import 'package:sloff/services/SloffApi.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key, this.uuid, this.company}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }

  final String uuid;
  final String company;
}

class _Profile extends State<UserProfile> {
  GlobalKey<ScaffoldState> _drawerKey = new GlobalKey();
  String name;
  String surname;
  bool loadingImage = false;
  String cause;
  bool loading = true;
  bool visible = true;
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
  String profilePictureUrl = "";

  ScrollController _controller = new ScrollController();

  Future<void> uploadImage() async {
    final File _myImage = await SloffMethods.getImage();

    if (_myImage != null) {
      setState(() {
        loadingImage = true;
      });
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("/profile_pictures/" + widget.uuid);
      UploadTask uploadTask = ref.putFile(_myImage);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((url) async {
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.uuid)
              .update({"profile_picture": url});

          // Update API
          var token = await FirebaseAuth.instance.currentUser.getIdToken();
          SloffApi.checkIfUserExists(uuid: widget.uuid, token: token)
              .then((exists) {
            if (exists) {
              SloffApi.updateUser(
                  uuid: widget.uuid,
                  token: token,
                  body: jsonEncode({"profile_picture": url}));
            }
          });

          setState(() {
            loadingImage = false;
          });
        });
      });
    }
  }

  void fetchInfo() async {
    DocumentSnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uuid)
        .get();
    DocumentSnapshot query1 = await FirebaseFirestore.instance
        .collection('users_cause')
        .doc(widget.uuid)
        .get();

    if (query['name'].toString() == '') {
      name = '     ';
    } else {
      name = query['name'].toString();
    }
    if (query['surname'].toString() == '') {
      surname = '     ';
    } else {
      surname = query['surname'].toString();
    }
    if (query1['cause'].toString() == '') {
      cause = '';
    } else {
      cause = query1['cause'].toString();
    }
  }

  void initState() {
    super.initState();
    fetchInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void removeImage() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uuid)
        .update({"profile_picture": ""});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Scaffold(
              key: _drawerKey,
              endDrawer: Theme(
                child: DrawerUiWidget(company: widget.company),
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Profilo".tr(),
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
                        onPressed: () =>
                            _drawerKey.currentState.openEndDrawer(),
                      )),
                ],
                elevation: 0,
              ),
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  controller: _controller,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Social Causes
                                /* SizedBox(
                                  height: 130,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
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
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users_cause')
                                                    .doc(widget.uuid)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
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
                                                              images[
                                                                  snapshot.data[
                                                                      'cause']],
                                                            )
                                                          : NetworkImage(
                                                              'https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Animal_Equality.png?alt=media&token=d0fd5b14-6e68-4c22-b088-54bab84312be'),
                                                    );
                                                  }
                                                }),
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
                                ), */

                                // Profile picture
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.uuid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            } else if (snapshot.hasError) {
                                              return Container();
                                            } else {
                                              profilePictureUrl = snapshot
                                                  .data["profile_picture"];

                                              return GestureDetector(
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: snapshot.data[
                                                                        "profile_picture"] !=
                                                                    ""
                                                                ? new Color(
                                                                    0xFF190E3B)
                                                                : Colors
                                                                    .transparent,
                                                            width: 3.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Container(
                                                          child: snapshot.data[
                                                                      "profile_picture"] ==
                                                                  ""
                                                              ? Icon(
                                                                  Icons
                                                                      .photo_camera_outlined,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          .7))
                                                              : Container(),
                                                          height: 90,
                                                          width: 90,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      snapshot.data[
                                                                          "profile_picture"]),
                                                                  fit: BoxFit
                                                                      .cover),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                    loadingImage
                                                        ? SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      .7),
                                                              strokeWidth: 2,
                                                            ))
                                                        : Container(),
                                                  ],
                                                ),
                                                onTap: () =>
                                                    SloffModals.profilePicture(
                                                        context,
                                                        uploadImage,
                                                        removeImage),
                                              );
                                            }
                                          }),
                                      Container(
                                        height: 20,
                                      )
                                    ]),

                                // Available focus time
                                /* SizedBox(
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
                                                    .doc(widget.company)
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
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'focus')
                                                                .doc(
                                                                    widget.uuid)
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
                                                })
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
                                ) */
                              ],
                            ),
                          )),
                      Container(
                          child: name != null
                              ? Text(
                                  name.capitalize() +
                                      " " +
                                      surname.capitalize(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      color: new Color(0xFF190E3B),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              : Container()),
                      SizedBox(height: 15),

                      // User chart ranking
                      GestureDetector(
                        onTap: () => pushWithFade(
                            context,
                            Charts(
                              name: name.capitalize(),
                              surname: surname.capitalize(),
                              uuid: widget.uuid,
                            ),
                            300),
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: new Color(0xFFffe7c1).withOpacity(.5),
                                borderRadius: BorderRadius.circular(6)),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("focus")
                                    .doc(widget.uuid)
                                    .snapshots(),
                                builder: (context, lastSnapshot) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: 33,
                                                width: 33,
                                                child: SvgPicture.asset(
                                                    "assets/images/Charts/empty_star.svg"),
                                              ),
                                              Text("1",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      fontSize: 16))
                                            ],
                                          ),
                                          Container(width: 10),
                                          Text(
                                            "chart-place".tr(),
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: new Color(0xFF190E3B),
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "ranking".tr(),
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.bold,
                                            color: new Color(0xFFffac00),
                                            fontSize: 15),
                                      ),
                                    ],
                                  );
                                })),
                      ),

                      // CO2 savings
                      Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: new Color(0xFFd2f9e6),
                              borderRadius: BorderRadius.circular(6)),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("focus")
                                  .doc(widget.uuid)
                                  .snapshots(),
                              builder: (context, lastSnapshot) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("CO1".tr(),
                                        style: TextStyle(fontSize: 13)),
                                    Text(
                                        "CO2".tr(namedArgs: {
                                          "amount": lastSnapshot.data != null
                                              ? lastSnapshot.data != 0
                                                  ? 0.22 *
                                                              lastSnapshot.data[
                                                                  "total"] <
                                                          100
                                                      ? (0.22 *
                                                                  lastSnapshot
                                                                          .data[
                                                                      "total"])
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "g"
                                                      : (0.22 *
                                                                  lastSnapshot
                                                                          .data[
                                                                      "total"] /
                                                                  1000)
                                                              .toStringAsFixed(
                                                                  1) +
                                                          "kg"
                                                  : "0g"
                                              : "0g"
                                        }),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    Text("CO3".tr(),
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                );
                              })),
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
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users_coupon')
                              .doc(widget.uuid)
                              .collection(widget.uuid)
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
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => buildItem(
                                    context, snapshot.data.docs[index]),
                                itemCount: snapshot.data.docs.length,
                              );
                            }
                          }),
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
        /* AnimatedOpacity(
          opacity: loading ? 1 : 0,
          duration: Duration(milliseconds: 100),
          child: Visibility(
            visible: visible ? true : false,
            child: ProfileLoading(),
          ),
        ), */
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
                        child: Image.asset(
                            'assets/images/Coupon/Unlock_prize.png'),
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
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                                new ClipboardData(text: document["code"]))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Code copied to your clipboard! 🤩')));
                        });
                      },
                      child: Container(
                        width: 240,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: new Color(0xFFFF6926), width: 2)),
                        child: Center(
                          child: Text(document['code'],
                              style: TextStyle(
                                  color: new Color(0xFFFF6926),
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Regular')),
                        ),
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
                      child: Text("delete-reward".tr(),
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
                uuid: widget.uuid,
                fromProfile: true,
                code: document['code']));
      }
    } else {
      return Container();
    }
  }
}
