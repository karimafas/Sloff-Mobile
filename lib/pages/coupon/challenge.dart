
import 'dart:convert';
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



class Challenge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Challenge();
  }
}
class _Challenge extends State<Challenge> with SingleTickerProviderStateMixin{
  final tabs = ['Challenge'
    /* , 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'*/];
  int focustime = 0;
  String uuidhere;
  String company='';
  int focus =0;
  String titolocchallenge;
  String startchallenge;
  String endchallenge;
  bool gruppo;

  Stream stream = FirebaseFirestore.instance
      .collection('coupon')
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
    String cc =await prefs.getString('company');

    String uuid = await prefs.getString('uuid');
    setState(() {
      uuidhere = uuid;
      company=cc;
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
                              company!=''?
                            StreamBuilder(
                                stream:  FirebaseFirestore.instance
                                .collection('users_company').doc(company).collection('challenge').where('elapsed_time', isGreaterThan: DateTime.now())
                                .snapshots(),
                            builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                return
                                  Text( (0).toString()+"h",
                                    style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));
                                } else
                                  if (snapshot.data.docs.length==0){
                                  return Text( (0).toString()+"h",
                                  style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));
                                  }else {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users_company').doc(company).collection('challenge').
                                          doc(snapshot.data.docs[0].id).collection('focus').doc(uuidhere)
                                          .snapshots(),
                                      builder: (context, snapshots) {
                                        if (!snapshots.hasData) {
                                          return Text( (0).toString()+"h",
                                              style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));}
                                        else {
                                          if (!snapshots.data.exists){
                                            return Text( (0).toString()+"h",
                                                style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));
                                          }else{
                                            return Text( (snapshots.data['available']~/60).toString()+"h",
                                                style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));
                                          }


                                        }
                                      });
                                }

                            }):Container(),

                              //Text(focushour.toString()+"h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                              // lineWidth: 2.0,
                              //progressColor: Colors.blueAccent,
                              //),
                              Container(height: 1,),
                              Text('Ore Focus', style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w500),),
                            ]))
                  ],
                  title: Text("Challenge",
                      textAlign: TextAlign.left,style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.8,  fontSize: 24, color: Colors.black)),
                  )
                ,
                preferredSize: Size.fromHeight(60),
              ),

              body:
              //TabBarView(
                  //children: <Widget>[
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('focus')
                            .doc(uuidhere)
                            .snapshots(),
                        builder: (context, firstsnap) {
                          print('ENTRANDO');

                          if (!firstsnap.hasData) {
                            print('ENTRANDO1');

                            return Container();
                          }
                          else {
                            print('ENTRANDO2');

                            return
                              StreamBuilder(
                                  stream:  FirebaseFirestore.instance
                                      .collection('users_company').doc(company).collection('challenge').where('elapsed_time', isGreaterThan: DateTime.now())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else if (snapshot.data.docs.length==0) {
                                      return Container();
                                    }else if (!snapshot.data.docs[0]['visible']) {
                                      return Container();
                                    } else
                                      titolocchallenge=snapshot.data.docs[0]['title'];
                                    gruppo =snapshot.data.docs[0]['group'];
                                      startchallenge=DateFormat('dd.MM.yyyy').format(snapshot.data.docs[0]['created_at'].toDate()).toString();
                                    endchallenge=DateFormat('dd.MM.yyyy').format(snapshot.data.docs[0]['elapsed_time'].toDate()).toString();


                                      {
                                      if(!snapshot.data.docs[0]['group']) {
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                //.collection('users_company').doc(company).collection('challenge').doc(snapshot.data.docs[0].id).collection('focus')
                                            .collection('users_company').doc(company).collection('challenge')
                                                .doc(snapshot.data.docs[0].id).collection('focus').doc(uuidhere)
                                                .snapshots(),
                                            builder: (context, thirdsnap) {
                                              var lalist = snapshot.data;
                                              var time;

                                              if (!thirdsnap.hasData) {
                                                 time =0;
                                              } else
                                              if (!thirdsnap.data.exists) {
                                                time =0;
                                              }else {
                                                time =thirdsnap.data['available'];

                                              }
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('users_company').doc(company).collection('challenge').doc(snapshot.data.docs[0].id).
                                                  collection('coupon')
                                                      .snapshots(),
                                                  builder: (context, couponsnap) {
                                                      if (!couponsnap.hasData) {
                                                      return Container();
                                                      } else if (couponsnap.data.docs.length==0) {
                                                        return Container();
                                                      }else {
                                                        int div=0;
                                                        if(time>0){
                                                           div = (time/60).toInt();
                                                        }else{
                                                           div =0;
                                                        }
                                                        return
                                                        Column(children: [
                                                          Container(color: Colors.black12,
                                                              padding: EdgeInsets.all(5),
                                                              margin: EdgeInsets.all(10),
                                                              child: Column(children: [
                                                                Text(titolocchallenge),
                                                                !gruppo?Text('Singola'):Text('Gruppo'),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                  Text('Start at: '+startchallenge),
                                                                  Text('End at: '+endchallenge)
                                                                ],)
                                                              ],)),
                                                          ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            shrinkWrap: true,
                                                            itemBuilder: (context, index) => index<couponsnap.data.docs.length?buildItem(
                                                                context,
                                                                couponsnap.data.docs[index],
                                                                div,
                                                                time,
                                                                time,
                                                                snapshot.data.docs[0].id):

                                                            Container(
                                                                padding: EdgeInsets.all(15),
                                                                child:
                                                                Text('Finelista'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,  fontSize: 15, color: Colors.black))),                                                            itemCount: couponsnap.data.docs.length+1,
                                                          )
                                                        ],)
                                                          ;
                                                      }


                                                  });

                                            });
                                      }
                                      else{
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users_company').doc(company).collection('challenge').doc(snapshot.data.docs[0].id).collection('focus')
                                                .snapshots(),
                                            builder: (context, fourthsnap) {
                                              var lalist = fourthsnap.data;
                                              //print(jsonDecode(lalist.toString()));
                                              var time =0;
                                              for(var u=0;u<lalist.docs.length;u++){
                                                time = time+lalist.docs[u]['available'];
                                              }

                                                  return StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('users_company').doc(company).collection('challenge').doc(snapshot.data.docs[0].id).
                                                      collection('coupon')
                                                      .snapshots(),
                                                  builder: (context, couponsnap) {
                                                    int div=0;
                                                    if(time>0){
                                                      div = (time/60).toInt();
                                                    }else{
                                                      div =0;
                                                    }
                                                  return
                                                    Column(children: [
                                                      Container(color: Colors.black12,
                                                          padding: EdgeInsets.all(5),
                                                          margin: EdgeInsets.all(10),

                                                          child: Column(children: [
                                                            Text(titolocchallenge),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text('Start at: '+startchallenge),
                                                                Text('End at: '+endchallenge)
                                                              ],)
                                                          ],)),
                                                      ListView.builder(
                                                      scrollDirection: Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) => index<couponsnap.data.docs.length?buildItem(context, couponsnap.data.docs[index],
                                                          div,
                                                          time.toInt(), time, snapshot.data.docs[0].id):
                                                      Center(child:
                                                          Container(
                                                            padding: EdgeInsets.all(15),
                                                            child:
                                                      Text('Finelista'.tr(), style:new TextStyle(fontWeight: FontWeight.normal,  fontSize: 15, color: Colors.black)))
                                                      ),
                                                      itemCount: couponsnap.data.docs.length+1,
                                                    )],)
                                                  ;

                                                  });



    });
                                      }




                                    }
                                  });
                          } }),
                    



                  //])



          );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int focushour, int focusdetail, int usertime, String couponid){

    print('QUI DETAIL'+usertime.toString());
    var usertimedivided= (usertime/60).round();
    //print(userfocus)
    if (document['visible']) {
      print('total_coupon' +document['total_coupon'].toString());
      if (document['total_coupon']<=0) {
        return Container();

      }
      else if (document['total_focus']<=usertimedivided) {
        return Container(
            color: Colors.white,
            child: CouponTaken(status: 3, title: document['title'], text: document['description'],
              brand: document['brand'],//!document['group']?'Singolo':'Gruppo',
                total: document['total_focus'], userfocus: usertimedivided, userfocusdetail: usertime,
              id:document.id, totalnumber: document['total_coupon'], couponid: couponid)
        );
      }else{
        return Container(
            color: Colors.white,
            child: CouponTaken(status: 1, title: document['title'], text: document['description'],
                brand: document['brand'],//!document['group']?'Singolo':'Gruppo',
                total: document['total_focus'], userfocus: usertimedivided, userfocusdetail: usertime,
                totalnumber: document['total_coupon'],
                id:document.id, couponid: couponid)
        );
      }
      //}


    }

  }




}
