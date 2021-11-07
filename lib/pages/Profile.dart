import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
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
import 'package:sloff/services/provider/TimerNotifier.dart';
import 'package:transparent_image/transparent_image.dart';

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
  bool loadingImage = false;
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

          await Provider.of<TimerNotifier>(context, listen: false)
              .loadUserData();

          setState(() {
            loadingImage = false;
          });
        });
      });
    }
  }

  void initState() {
    super.initState();
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
    return Stack(children: [
      Consumer<TimerNotifier>(builder: (context, data, index) {
        return Scaffold(
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
                      onPressed: () => _drawerKey.currentState.openEndDrawer(),
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
                              // Profile picture
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: new Color(0xFF190E3B),
                                                  width: 3.5),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: PhysicalModel(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: Colors.grey,
                                                        shape: BoxShape.circle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: data.profile_picture !=
                                                                ""
                                                            ? FadeInImage
                                                                .memoryNetwork(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                                image: data
                                                                    .profile_picture,
                                                                placeholder:
                                                                    kTransparentImage,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Icon(Icons.person,
                                                                color: new Color(
                                                                    0xFF190E3B))))),
                                          ),
                                          loadingImage
                                              ? SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white
                                                        .withOpacity(.7),
                                                    strokeWidth: 2,
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                      onTap: () => SloffModals.profilePicture(
                                          context, uploadImage, removeImage),
                                    ),
                                    Container(
                                      height: 20,
                                    )
                                  ]),
                            ],
                          ),
                        )),
                    Container(
                        child: Text(
                      data.first_name.capitalize() +
                          " " +
                          data.last_name.capitalize(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: new Color(0xFF190E3B),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 15),

                    // User chart ranking
                    GestureDetector(
                        onTap: () => pushWithFade(
                            context,
                            Charts(
                              name: data.first_name.capitalize(),
                              surname: data.last_name.capitalize(),
                              uuid: widget.uuid,
                            ),
                            300),
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                color: new Color(0xFFffe7c1).withOpacity(.5),
                                borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 33,
                                          width: 33,
                                          child: data.initialRanking == 1
                                              ? SvgPicture.asset(
                                                  "assets/images/Charts/empty_star.svg")
                                              : Container(),
                                        ),
                                        Text(
                                            data.initialRanking != 1
                                                ? "#" +
                                                    data.initialRanking
                                                        .toString()
                                                : data.initialRanking
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: data.initialRanking == 1
                                                    ? Colors.white
                                                    : Color(0xFFF2610C),
                                                fontFamily: "Poppins-Regular",
                                                fontSize: 16))
                                      ],
                                    ),
                                    Container(width: 10),
                                    /* Text(
                                      "chart-place".tr(),
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: new Color(0xFF190E3B),
                                          fontSize: 15),
                                    ), */
                                  ],
                                ),
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xFF190E3B),
                                  ),
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
                            ))),

                    // CO2 savings
                    /* Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: new Color(0xFFd2f9e6),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("CO1".tr(), style: TextStyle(fontSize: 13)),
                            Text(
                                "CO2".tr(namedArgs: {
                                  "amount": data.individualTotalFocusMinutes !=
                                          null
                                      ? data.individualTotalFocusMinutes != 0
                                          ? 0.22 * data.individualTotalFocusMinutes <
                                                  100
                                              ? (0.22 * data.individualTotalFocusMinutes)
                                                      .toStringAsFixed(1) +
                                                  "g"
                                              : (0.22 *
                                                          data.individualTotalFocusMinutes /
                                                          1000)
                                                      .toStringAsFixed(1) +
                                                  "kg"
                                          : "0g"
                                      : "0g"
                                }),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            Text("CO3".tr(), style: TextStyle(fontSize: 13)),
                          ],
                        )), */
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
                      itemBuilder: (context, index) =>
                          buildItem(context, data.redeemedRewards[index]),
                      itemCount: data.redeemedRewards.length,
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: data.redeemedRewards.length <
                                  data.redeemedRewardsQuantity &&
                              data.redeemedRewards.length > 0
                          ? true
                          : false,
                      child: GestureDetector(
                        onTap: () =>
                            Provider.of<TimerNotifier>(context, listen: false)
                                .loadMoreRewards(),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                              child: Text("Load more...",
                                  style: TextStyle(color: Colors.white))),
                          decoration: BoxDecoration(
                              color: new Color(0xFFFF6926),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
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
                )));
      })
    ]);
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
                            .update({"visible": false}).then((value) => Provider
                                    .of<TimerNotifier>(context, listen: false)
                                .loadRedeemedRewards()
                                .then((value) => Navigator.of(context).pop()));
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
}
