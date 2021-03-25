
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
//import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sloff/models/coupon.dart';
//import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';



class Coupon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Coupon();
  }
}
class _Coupon extends State<Coupon> with SingleTickerProviderStateMixin{
  final tabs = ['Challenge'
   /* , 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'*/];
   int focustime = 0;
   String uuidhere;
  String company='';

  Stream stream = FirebaseFirestore.instance
      .collection('coupon')
      .snapshots();
  /*Stream streamchallenge = FirebaseFirestore.instance
      .collection('user_company').doc(company).challenge()
      .snapshots();*/
  Stream stream0 = FirebaseFirestore.instance
      .collection('coupon').where('tag', arrayContains: 'fashion')
      .snapshots();
  Stream stream1 = FirebaseFirestore.instance
      .collection('coupon').where('tag', arrayContains: 'cibo')
      .snapshots();
  Stream stream2 = FirebaseFirestore.instance
      .collection('coupon').where('tag', arrayContains: 'beauty')
      .snapshots();
  Stream stream3 = FirebaseFirestore.instance
      .collection('coupon').where('tag', arrayContains: 'sport')
      .snapshots();
  Stream stream4 = FirebaseFirestore.instance
      .collection('coupon').where('tag', arrayContains: 'travel')
      .snapshots();
  TabController _tabController;



  void initState() {
    super.initState();
    fetchname();
    didChangeDependencies();
    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  void fetchname() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String company =await prefs.getString('company');

    String uuid = await prefs.getString('uuid');
    setState(() {
      uuidhere = uuid;
    });
    print('fetchname');

    DocumentSnapshot aa =  await FirebaseFirestore.instance
        .collection('focus')
        .doc(uuid).get();
    print('doc '+aa.toString());

    setState(() {
      if(aa['available']==null){
        focustime = 0;
      }else{
        focustime = aa['available'];

      }
      print('ilname' +focustime.toString());

    });

  }

  @override
  Widget build(BuildContext context) {
    int focushour = (focustime/60).toInt();
    return
      DefaultTabController(
          length: tabs.length,
          child:
      Scaffold(
          backgroundColor: Colors.white,
          appBar: new PreferredSize(child: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Colors.white,
              leading: null,
              actions: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('focus')
                                  .doc(uuidhere)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return Text( ((snapshot.data['available']/60).toInt()).toString()+"h",
                                      style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));

                                }
                              }),
                          //Text(focushour.toString()+"h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                          // lineWidth: 2.0,
                          //progressColor: Colors.blueAccent,
                          //),
                          Container(height: 1,),
                          Text('Ore Focus', style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w500),),
                        ]))
              ],
              title: Text("Coupon",
                  textAlign: TextAlign.left,style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.8,  fontSize: 24, color: Colors.black)),
              bottom:TabBar(
                isScrollable: true,
                indicatorColor: Colors.blueAccent,
                labelColor: Colors.black87,
                unselectedLabelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color
                        : Colors.black87),
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color
                        : Colors.blueAccent),
                tabs: tabs.map((t) {
                  return Container(
                    //color: Colors.transparent,
                    child: Tab(
                      child: Text(
                        t,
                        /*style: TextStyle(
                          color:  _tabController.index == 1
                              ? Colors.blueAccent
                              : Colors.black87)*/
                        ),
                      ),
                  );
                }).toList(),))
            ,
            preferredSize: Size.fromHeight(100),),

          body:
           TabBarView(
                  children: <Widget>[
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream:  FirebaseFirestore.instance
                                      .collection('users_company').doc(company).collection('challenge')
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
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(),
                                            (firstsnap.data['available']/1).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );


                                    }
                                  });
                          } }),
                    /*StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream: stream0,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      var lalist = snapshot.data;
                                      //print(snapshot.data.documents[0].toString());
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(), (firstsnap.data['available']).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );
                                      /*ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 2,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 1,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 3,)
                    )
                  ],
                );*/

                                    }
                                  });
                          } }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream: stream1,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      var lalist = snapshot.data;
                                     // print(snapshot.data.documents[0].toString());
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(), (firstsnap.data['available']).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );
                                      /*ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 2,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 1,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 3,)
                    )
                  ],
                );*/

                                    }
                                  });
                          } }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream: stream2,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      var lalist = snapshot.data;
                                      //print(snapshot.data.documents[0].toString());
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(), (firstsnap.data['available']).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );
                                      /*ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 2,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 1,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 3,)
                    )
                  ],
                );*/

                                    }
                                  });
                          } }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream: stream3,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      var lalist = snapshot.data;
                                      //print(snapshot.data.documents[0].toString());
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(), (firstsnap.data['available']).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );
                                      /*ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 2,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 1,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 3,)
                    )
                  ],
                );*/

                                    }
                                  });
                          } }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          if (!firstsnap.hasData) {
                            return Container();
                          } else {

                            return
                              StreamBuilder(
                                  stream: stream4,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      var lalist = snapshot.data;
                                      //print(snapshot.data.documents[0].toString());
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index], (firstsnap.data['available']/60).toInt(), (firstsnap.data['available']).toInt()),
                                        itemCount: snapshot.data.docs.length,
                                      );
                                      /*ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 2,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 1,)
                    ),
                    Container(
                        color: Colors.white,
                        child: CouponTaken(status: 3,)
                    )
                  ],
                );*/

                                    }
                                  });
                          } })*/



                  ])



      ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int focushour, int focusdetail) {
    print('QUI DETAIL'+focusdetail.toString());
    if (document['visible']) {
      print('total_coupon' +document['total_coupon'].toString());
        if (document['total_coupon']<=0) {
          return Container();

        }
        else if (document['total_focus']<=focushour) {
          return Container(
              color: Colors.white,
              child: CouponTaken(status: 3, title: document['title'], text: document['description'],
                brand: document['brand'], total: document['total_focus'], userfocus: focushour, userfocusdetail: focusdetail,
                id:document.id, totalnumber: document['total_coupon'], )
          );
        }else{
          return Container(
              color: Colors.white,
              child: CouponTaken(status: 1, title: document['title'], text: document['description'],
                  brand: document['brand'], total: document['total_focus'], userfocus: focushour, userfocusdetail: focusdetail,
                  totalnumber: document['total_coupon'],
                  id:document.id)
          );
        }
      //}


    }

    }




}
