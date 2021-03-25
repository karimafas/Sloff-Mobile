import 'package:flutter/material.dart';
//import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CouponEliminate extends StatefulWidget {
  @override
  final String id;
  final int focushour;
  final String uuid;



  const CouponEliminate({Key key, this.id, this.focushour, this.uuid}) : super(key: key);
  @override
  _CouponEliminate createState() => _CouponEliminate();
//State<StatefulWidget> createState() {
//return _CouponConfirm();
//}
}
class _CouponEliminate extends State<CouponEliminate> {
  final tabs = ['Generale', 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'];


  @override
  Widget build(BuildContext context) {
    Stream stream = FirebaseFirestore.instance
        .collection('users_coupon').doc(widget.uuid).collection(widget.uuid).doc(widget.id)
        .snapshots();
    print(widget.id);
    return
      Scaffold(
          backgroundColor: Colors.white,
          appBar:new AppBar(title: Text(('Cancellacoupon'.tr()).toUpperCase(), style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: Colors.black),centerTitle: true,),
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(child:IconButton(
                  icon: SvgPicture.asset('assets/images/Coupon/Riscatta_coupon.svg', fit: BoxFit.cover)),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:
                new RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    text: 'Cancellacoupon1'.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[

                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:
                StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        var lalist = snapshot.data;
                        //print(snapshot.data.documents[0].toString());
                        return Container() /*new RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            text: 'Cancellacoupon1'.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              /*new TextSpan(text: 'CouponCosto1'.tr(namedArgs: {'ore': snapshot.data['total_focus'].toString()}), style: new  TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold, color: Colors.blueAccent
                              )),*/
                            ],
                          ),
                        )*/;


                      }
                    }),

              ),
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
                        itemBuilder: (context, index) => buildItem(context, snapshot.data, widget.focushour),
                        itemCount: 1,
                      );


                    }
                  }),
              /*Container(
                  color: Colors.white,
                  child: CouponTaken(status: 3,)
              ),*/

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async{
                        final CollectionReference postsRef = FirebaseFirestore.instance
                            .collection('users_coupon');
                        var postID = widget.id;
                        Map<String, dynamic> providerId = new Map();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String uuid = prefs
                            .getString('uuid');
                        FirebaseFirestore.instance
                            .collection('users_coupon')
                            .doc(uuid).collection(uuid).doc(postID)
                            .update({
                          "visible": false
                        }).then((value) => Navigator.of(context).pop());
                      },
                      child:
                      Container(
                        margin: EdgeInsets.only(top: 5),

                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff10EB50),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sí".tr().toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                          ],
                        ),
                      )),
                  GestureDetector(
                      onTap:() =>
                          Navigator.of(context).pop(),
                      /*push( MaterialPageRoute<void>(
                          builder: (BuildContext context) => CouponConfirm(
                            //fromlogin: true,
                            //userName: user.user.uid,
                          ),
                        ),)*/

                      child:
                      Container(
                          margin: EdgeInsets.only(top: 5),

                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xffFF0F5F),
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              border: Border()
                          ),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                border: Border()
                            ),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No".tr().toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:Color(0xffFF0F5F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),
                              ],
                            ),
                          )))

                ],)

            ],
          )
      );
  }



  Widget buildItem(BuildContext context, DocumentSnapshot document, int focushour) {
        return Container(
            color: Colors.white,
            child: CouponTaken(status: 4, title: document['title'], text: document['description'],
                brand: document['brand'], //!document['group']?'Singolo':'Gruppo',
                total: document['total_focus'],
                totalnumber: document['total_coupon'], elapsed: document['elapsed_time'],
                userfocus: focushour, id: 'dssad')
        );

/*
title: document['title'], text: document['description'], brand: document['brand'], total: document['total_focus'], userfocus: 0,
                id:document.id,totalnumber: document['total_coupon'], elapsed: document['elapsed_time'], uuid: uuidhere, fromprofile: true,
                code: document['code']
 */

  }
}