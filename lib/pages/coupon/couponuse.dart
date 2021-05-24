import 'package:flutter/material.dart';

//import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponUse extends StatefulWidget {
  @override
  final String code;
  final String couponuid;
  final String brand;

  const CouponUse({Key key, this.code, this.couponuid, this.brand})
      : super(key: key);

  @override
  _CouponUse createState() => _CouponUse();
}

class _CouponUse extends State<CouponUse> {
  final tabs = ['Generale', 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'];
  String name = '';
  String uuidhere;

  void fetchname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = await prefs.getString('uuid');
    setState(() {
      uuidhere = uuid;
    });
    print('fetchname');

    DocumentSnapshot aa =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();
    print('doc ' + aa.toString());

    setState(() {
      if (aa['name'].toString() == '') {
        name = '     ';
      } else {
        name = aa['name'].toString();
      }
      print('ilname' + name);
    });
  }

  void initState() {
    super.initState();
    fetchname();
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    //fetchSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: Text(
            ('couponusa'.tr()).toUpperCase(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: 16),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: IconButton(
                  icon: SvgPicture.asset('assets/images/Profilo/Copia.svg',
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  text: 'CouponConfirm'.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: widget.brand,
                        style: new TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users_coupon')
                    .doc(uuidhere)
                    .collection(uuidhere)
                    .doc(widget.couponuid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var lalist = snapshot.data;
                    //print(snapshot.data.documents[0].toString());
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data),
                      itemCount: 1,
                    );
                  }
                }),
          ],
        ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
        color: Colors.white,
        child: CouponTaken(
            status: 5,
            title: document['title'],
            text: document['description'],
            brand: document['brand'],
            //!document['group']?'Singolo':'Gruppo',
            isGroup: document['group'],
            cardReward: document['type'] == 'Libero' ? false : true,
            endDate: document['elapsed_time'],
            value: document['value'] != null
                ? document['value'].toString()
                : '0',
            total: document['total_focus'],
            userfocus: 0,
            id: document.id,
            totalnumber: document['total_coupon'],
            code: document['code'],
            elapsed: document['elapsed_time'],
            isusing: true));
  }
}
