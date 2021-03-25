
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:sloff/pages/cambiocausa.dart';
import 'package:sloff/pages/profile/drawer.dart';
import 'package:sloff/pages/coupon/couponeliminate.dart';

import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  List<String>images = [
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

    DocumentSnapshot aa =  await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid).get();
    DocumentSnapshot bb =  await FirebaseFirestore.instance
        .collection('users_cause')
        .doc(uuid).get();
    print('doc '+aa.toString());

    setState(() {
      if(aa['name'].toString()==''){
        name = '     ';
      }else{
        name = aa['name'].toString();

      }
      if(bb['cause'].toString()==''){
        cause = '';
      }else{
        cause = bb['cause'].toString();

      }
      print('cause' +cause);

    });

  }
  void initState() {
    super.initState();
    fetchname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        endDrawer: DrawerUiWidget(),
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: Text('Profilo'.tr(),
              style: new TextStyle(fontWeight: FontWeight.bold,  fontSize: 24, fontFamily: 'Montserrat',
                  letterSpacing: -0.8,
                  color: Colors.black)),
          centerTitle: false,

          /*leading: new IconButton(
          icon: SvgPicture.asset('assets/images/Notifiche/Notifiche.svg', fit: BoxFit.cover),
          //onPressed: () => Navigator.of(context).pop(),
        ),*/
          actions: <Widget>[
            new
            GestureDetector(
              onTap: () => _drawerKey.currentState.openEndDrawer(),
              child:
              Padding(
                  padding: new EdgeInsets.only(right: 15.0),
                  child:
              IconButton(
                  icon: Image.asset('assets/images/Profilo/Menu.png', fit: BoxFit.cover, height: 16,))),
              //onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _controller,
          //height: 600,
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CambioCausa(inside: true,))),
                      child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          uuidhere!=''?StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users_cause')
                              .doc(uuidhere)
                              .snapshots(),
                          builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                          return Container();
                          } else if (!snapshot.data.exists) {
                            return Container();
                          }else {
                            return CircleAvatar(backgroundImage: snapshot.data['cause']!=''?AssetImage(
                              images[snapshot.data['cause']],
                            )
                                :NetworkImage('https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Animal_Equality.png?alt=media&token=d0fd5b14-6e68-4c22-b088-54bab84312be'),);
                          }

                          }):Container(),
                          Container(height: 3,),
                          Text('Causa'.tr(), style: TextStyle(color: Colors.blueAccent, fontSize: 11,
                              fontFamily: 'Montserrat', letterSpacing: -0.8,
                              fontWeight: FontWeight.normal),),
                          Text('sociale'.tr(), style: TextStyle(color: Colors.blueAccent,
                              fontFamily: 'Montserrat', letterSpacing: -0.8,
                              fontSize: 11, fontWeight: FontWeight.normal),)
                        ]) ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Sloff_logo_Ottobre_2020.png?alt=media&token=ca23f1ac-a5f9-4deb-b8e6-e6b547cb4ba9'),),
                          Container(height: 10,)
                        ]),

                             Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                StreamBuilder(
                                stream:  FirebaseFirestore.instance
                                    .collection('users_company').doc(company).collection('challenge').where('elapsed_time', isGreaterThan: DateTime.now())
                                    .snapshots(),
                                builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                return
                                new CircularPercentIndicator(radius: 40,
                                //width: MediaQuery.of(context).size.width - 50,
                                animation: true,
                                animationDuration: 2000,
                                percent: 1.0,
                                center: Text(((0).toInt()).toString()+" h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                lineWidth: 2.0,
                                progressColor: Colors.blueAccent,
                                );
                                } else
                                if (snapshot.data.docs.length==0){
                                  return Text( (0).toString()+"h",
                                      style:TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold));
                                }else {
                                return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users_company').doc(company).collection('challenge').doc(snapshot.data.docs[0].id).collection('focus').doc(uuidhere)
                                    .snapshots(),
                                builder: (context, snapshots) {
                                if (!snapshots.hasData) {
                                return
                                new CircularPercentIndicator(radius: 40,
                                //width: MediaQuery.of(context).size.width - 50,
                                animation: true,
                                animationDuration: 2000,
                                percent: 1.0,
                                center: Text(((0).toInt()).toString()+" h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                lineWidth: 2.0,
                                progressColor: Colors.blueAccent,
                                );
                                } else {
                                  if (!snapshots.data.exists){
                                    return
                                      new CircularPercentIndicator(radius: 40,
                                        //width: MediaQuery.of(context).size.width - 50,
                                        animation: true,
                                        animationDuration: 2000,
                                        percent: 1.0,
                                        center: Text(((0).toInt()).toString()+" h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                        lineWidth: 2.0,
                                        progressColor: Colors.blueAccent,
                                      );
                                  }else{
                                    return
                                      new CircularPercentIndicator(radius: 40,
                                        //width: MediaQuery.of(context).size.width - 50,
                                        animation: true,
                                        animationDuration: 2000,
                                        percent: 1.0,
                                        center: Text(((snapshots.data['available']/60).toInt()).toString()+" h", style:TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                        lineWidth: 2.0,
                                        progressColor: Colors.blueAccent,
                                      );
                                  }


                                }
                                });
                                }

                                }),
                                  Container(height: 3,),
                                  Text('Focus', style: TextStyle(color: Colors.black87,
                                      fontFamily: 'Montserrat', letterSpacing: -0.8,
                                      fontSize: 11, fontWeight: FontWeight.normal),),
                                  Text(''.tr(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),)
                                ])



                  ],
                )),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child:
                Text(name, style: TextStyle(color: Colors.black, fontSize: 20,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.bold),)),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Impostazioni.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Container(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ModificaProfilo'.tr()+' ',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: -0.8),
                          textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),*/
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/Profilo/Coupon_da_utilizzare.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Container(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CouponProfilo'.tr()+' ', style: TextStyle(color: Colors.black,
                            letterSpacing: -0.8,
                            fontSize: 15, fontWeight: FontWeight.w600), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                )),
                  Container(height: 3,),
                  Container(height: 1, width: MediaQuery.of(context).size.width*0.9,color: Color(0xffF2F2F2)),
                  uuidhere!=''?
                  StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users_coupon').doc(uuidhere).collection(uuidhere)
                      .snapshots(),
                  builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                  return Container();
                  } else {
                  var lalist = snapshot.data;
                  print('length');

                  print(snapshot.data.docs.length);
                  //print(snapshot.data.documents[0].toString());
                  return ListView.builder(
                    //controller: _controller,

                    physics: const NeverScrollableScrollPhysics(), // new
                    scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index]),
                  itemCount: snapshot.data.docs.length,
                  );}
                  }):Container(),

              ],)

    ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['visible']) {
      return Container(
         // height: 400,
          child:Column(children: [
       /* Align(
          alignment: Alignment.centerRight, child: GestureDetector(
            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => CouponEliminate(id: document.id, uuid: uuidhere))),
            child:Container(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.cancel, color: Color(0xffFF0F5F)))),),*/
        Container(
            color: Colors.white,
            child: CouponTaken(status: 4, title: document['title'], text: document['description'], brand: !document['group']?'Singolo':'Gruppo', total: document['total_focus'], userfocus: 0,
                id:document.id,totalnumber: document['total_coupon'], elapsed: document['elapsed_time'], uuid: uuidhere, fromprofile: true,
                code: document['code'])
        )
      ],));
    }else{
      return Container();
    }





  }





}
