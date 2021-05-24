import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponDetail extends StatefulWidget {
  @override
  final String id;
  final int focushour;
  final String uuid;
  final bool fromprofile;
  final int status;
  final String brand;
  final String company;
  final String challengeID;

  const CouponDetail(
      {Key key,
      this.id,
      this.focushour,
      this.uuid,
      this.fromprofile,
      this.status,
      this.brand, this.company, this.challengeID})
      : super(key: key);

  @override
  _CouponDetail createState() => _CouponDetail();
//State<StatefulWidget> createState() {
//return _CouponConfirm();
//}
}

class _CouponDetail extends State<CouponDetail> {

  final tabs = ['Generale', 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'];
  List<Widget> images = [
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/Cause/1.jpeg'),
        ),
      ),
      //child:

      //Image.asset(url, fit: BoxFit.fill)
    ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/Cause/2.jpeg'),
        ),
      ),
      //child:

      //Image.asset(url, fit: BoxFit.fill)
    ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/Cause/3.jpeg'),
        ),
      ),
      //child:

      //Image.asset(url, fit: BoxFit.fill)
    ),
  ];

  CarouselController buttonCarouselController = CarouselController();

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Stream stream;
    !widget.fromprofile
        ? stream = FirebaseFirestore.instance
            .collection('users_company')
            .doc(widget.company)
            .collection('challenge')
            .doc(widget.challengeID)
            .collection('coupon')
            .doc(widget.id)
            .snapshots()
        : stream = FirebaseFirestore.instance
            .collection('users_coupon')
            .doc(widget.uuid)
            .collection(widget.uuid)
            .doc(widget.id)
            .snapshots();
    print(widget.id);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Share.share(
                  'Sto riscattando questo coupon su Sloff!',
                  subject: 'Coupon di ' + widget.brand),
              child: IconButton(
                  icon: Icon(
                Icons.share,
                color: Colors.black,
              )),
              //onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var lalist = snapshot.data;
                    //print(snapshot.data.documents[0].toString());
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildItem(
                          context,
                          snapshot.data,
                          widget.focushour,
                          widget.id,
                          widget.status),
                      itemCount: 1,
                    );
                  }
                }),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CarouselSlider(
                  items: images,
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.5,
                    aspectRatio: 2.0,
                    initialPage: 0,
                  ),
                )),
            Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Descrizione lunga',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: -0.39,
                  ),
                )),
            Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Descrizione lunga Descrizione lunga Descrizione lunga Descrizione lunga Descrizione lunga '
                  'Descrizione lunga Descrizione lunga Descrizione lunga Descrizione lunga Descrizione lunga',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    letterSpacing: -0.39,
                    height: 1.15385,
                  ),
                ))
          ],
        ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document,
      int focushour, String id, int status) {
    return Container(
        color: Colors.white,
        child: Hero(
            tag: id,
            child: CouponTaken(
                status: status,
                title: document['title'],
                text: document['description'],
                brand: document['brand'],
                total: document['total_focus'],
                isGroup: document['group'],
                totalnumber: document['total_coupon'],
                elapsed: document['elapsed_time'],
                cardReward: document['type'] == 'Libero' ? false : true,
                endDate: document['elapsed_time'],
                value: document['value'] != null
                    ? document['value'].toString()
                    : '0',
                id: document.id,
                userfocus: focushour)));
  }
}

/*class CouponTaken extends StatelessWidget {
  final String title;
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
  final bool fromprofile;
  final String uuid;

  const CouponTaken(
      {Key key,
      this.text,
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
      this.fromprofile = false,
      this.uuid = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ilcolor = this.color;
    print('el ' + elapsed.toString());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 270,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                  Positioned(
                    left: 0,
                    top: 27,
                    right: 0,
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 25),
                      child: status == 4
                          ? SvgPicture.asset(
                              'assets/images/Coupon/Coupon_da_riscattare.svg',
                              fit: BoxFit.cover,
                            )
                          : status == 5
                              ? SvgPicture.asset(
                                  'assets/images/Profilo/Coupon_aperto.svg',
                                  fit: BoxFit.cover,
                                )
                              : status == 3
                                  ? SvgPicture.asset(
                                      'assets/images/Coupon/Coupon_da_riscattare.svg',
                                      fit: BoxFit.cover,
                                    )
                                  : SvgPicture.asset(
                                      'assets/images/Coupon/Coupon_grigio.svg',
                                      fit: BoxFit.cover,
                                    ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: new Container(
                          width: 250,
                          child: Column(
                            children: [
                              GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              CouponDetail(
                                            id: id,
                                            uuid: uuid,
                                            //fromlogin: true,
                                            //userName: user.user.uid,
                                          ),
                                        ),
                                      ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Sloff_logo_Ottobre_2020.png?alt=media&token=ca23f1ac-a5f9-4deb-b8e6-e6b547cb4ba9'),
                                    radius: 30.0,
                                  )),
                              //SizedBox.fromSize(),
                              new Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    brand,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: status >= 3
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      letterSpacing: -0.39,
                                      //height: 1.15385,
                                    ),
                                  )),
                              SizedBox.fromSize(),
                              new Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: -0.39,
                                      height: 1.15385,
                                    ),
                                  )),
                              Container(
                                height: 5,
                              ),
                              new Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 50, right: 50),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: status >= 3
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      letterSpacing: -0.39,
                                      height: 1.15385,
                                    ),
                                  )),
                              Container(
                                height: 10,
                              ),
                              status == 4
                                  ? GestureDetector(
                                      onTap: null,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5),
                                        width: 180,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFF7E05),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Utilizza".tr().toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : status == 3
                                      ? GestureDetector(
                                          onTap: null,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5),
                                            width: 180,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
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
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : status == 5
                                          ? Container()
                                          : Column(
                                              children: [
                                                Container(
                                                  height: 10,
                                                ),
                                                Text(
                                                  (userfocus / total * 100)
                                                          .toString() +
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
                                                new LinearPercentIndicator(
                                                  //width: MediaQuery.of(context).size.width - 50,
                                                  animation: true,
                                                  lineHeight: 10.0,
                                                  animationDuration: 2000,
                                                  percent: (userfocus / total),
                                                  //center: Text("90.0%"),
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                  progressColor:
                                                      Color(0xff9BDB46),
                                                  backgroundColor: Colors.black,
                                                ),
                                              ],
                                            )
                            ],
                          ))),
                  Positioned(
                      left: 0, //23.5,
                      top: 25, //18,
                      child: Container(
                        height: 10,
                        width: 10,
                        color: Colors.white,
                      )),
                  status < 4
                      ? Positioned(
                          right: 0, //23.5,
                          top: 25, //18,
                          child: Container(
                            height: 10,
                            width: 10,
                            color: Colors.white,
                          ))
                      : Container(),
                  status > 3
                      ? Positioned(
                          left: 0, //23.5,
                          top: 25, //18,
                          child: Container(
                              width: 110,
                              //margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xffFF0F5F),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(5.0)),
                              ),
                              //child:
                              // color: Colors.pink,
                              //new Flexible(
                              child: Text(
                                "Utilizza entro " +
                                    elapsed
                                        .toDate()
                                        .toString()
                                        .substring(0, 10),
                                //totalnumber<20?"Restano solo "+totalnumber.toString()+" coupon":totalnumber.toString()+" coupon disponibili",
                                textAlign: TextAlign.center,
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
                      : Positioned(
                          left: 0, //23.5,
                          top: 25, //18,
                          child: Container(
                              width: 110,
                              //margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: totalnumber < 20
                                    ? Color(0xffFF0F5F)
                                    : Colors.blueAccent,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(5.0)),
                              ),
                              //child:
                              // color: Colors.pink,
                              //new Flexible(
                              child: Text(
                                //"Utilizza entro\n5 g : 23 h : 59 m",
                                totalnumber < 20
                                    ? "Restano solo " +
                                        totalnumber.toString() +
                                        " coupon"
                                    : totalnumber.toString() +
                                        " coupon disponibili",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  letterSpacing: -0.39,
                                  height: 1.15385,
                                ),
                              ) //),
                              ),
                        ),
                  status < 4
                      ? Positioned(
                          right: 0, //23.5,
                          top: 25, //18,
                          child: Container(
                              //margin: EdgeInsets.only(left: 15),
                              width: 110,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff9BDB46),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(5.0)),
                              ),
                              //child:
                              // color: Colors.pink,
                              // new Flexible(
                              child: Text(
                                status < 3
                                    ? "Mancano " +
                                        (total - userfocus).toString() +
                                        " ore\ndi focus"
                                    : "E' ora di\nriscattarlo",
                                textAlign: TextAlign.center,
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
                      : fromprofile
                          ? Positioned(
                              right: 0, //23.5,
                              top: 25,
                              child: GestureDetector(
                                  onTap: null,
                                  child: //18,
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(Icons.cancel,
                                              color: Color(0xffFF0F5F)))))
                          : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
