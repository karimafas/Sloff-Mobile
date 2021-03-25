import 'package:flutter/material.dart';
//import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/coupontaken.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CouponConfirm extends StatefulWidget {
  @override
  final String id;
  final int focushour;
  final String couponid;



  const CouponConfirm({Key key, this.id, this.focushour, this.couponid}) : super(key: key);
  @override
  _CouponConfirm createState() => _CouponConfirm();
  //State<StatefulWidget> createState() {
    //return _CouponConfirm();
  //}
}
class _CouponConfirm extends State<CouponConfirm> {
  final tabs = ['Generale', 'Fashion', 'Cibo', 'Beauty', 'Sport', 'Travel'];
  String company='';
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }
  fetch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      company = prefs
          .getString('company');
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream stream = FirebaseFirestore.instance
    .collection('users_company').doc(company).collection('challenge').doc(widget.couponid).collection('coupon').doc(widget.id)
        .snapshots();
    print('CONFIRM ID');

    print(widget.id);
    return
      Scaffold(
          backgroundColor: Colors.white,
          appBar:new AppBar(title: Text(('couponusa'.tr()).toUpperCase(),
            style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),

          ),
            backgroundColor: Colors.white, elevation: 0,
            iconTheme: IconThemeData(color: Colors.black, size: 16),centerTitle: true,),
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
                    text: 'CouponUse'.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                      fontFamily: 'Montserrat',

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
                        return new RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            text: 'CouponCosto'.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              letterSpacing: -0.8,

                            ),
                            children: <TextSpan>[
                              new TextSpan(text: 'CouponCosto1'.tr(namedArgs: {'ore': snapshot.data['total_focus'].toString()}), style: new  TextStyle(
                                  fontSize: 18.0,
                                  letterSpacing: -0.8,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700, color: Colors.blueAccent
                              )),
                            ],
                          ),
                        );


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
              var postI = widget.couponid;
              var postID = widget.id;
              bool isgroup = false;

              Map<String, dynamic> providerId = new Map();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String uuid = prefs
                  .getString('uuid');
              String company = prefs
                  .getString('company');

              final DocumentSnapshot coupon =
              await FirebaseFirestore.instance.collection('users_company').doc(company).collection('challenge').doc(postI)
                  .collection('coupon').doc(postID).get();

              print('HELLO');

              if (coupon.exists) {
                List<String> codes = List.from(coupon['code']);
                isgroup = coupon['group'];
                providerId['brand']= coupon['brand'];
                providerId['group']= coupon['group'];
                providerId['code']= coupon['type']!='Libero'?codes[0]:'';
                providerId['created_at']= coupon['created_at'];
                providerId['description']= coupon['description'];
                providerId['elapsed_time']= coupon['elapsed_coupon_time'];
                providerId['logo']= coupon['logo'];
                providerId['type']= coupon['type'];
                providerId['title']= coupon['title'];
                providerId['total_coupon']= coupon['total_coupon'];
                providerId['total_focus']= coupon['total_focus'];
                providerId['visible']= true;
                if(codes.isNotEmpty){
                  var updatearr=codes.removeAt(0);
                }
                FirebaseFirestore.instance
                .collection('users_company').doc(company).collection('challenge')
                    .doc(postI).collection('coupon').doc(postID)
                    .update({
                  "total_coupon": providerId['total_coupon']-1,
                  "code": codes,

                }).then((value) async{

                  final DocumentSnapshot postRef1 =
                  await FirebaseFirestore.instance.collection('users_company').doc(company).collection('challenge').doc(widget.couponid).collection('focus').doc(uuid).get();
                  if (postRef1.exists) {
                    int available = postRef1['available'];
                    final DocumentSnapshot couponrisc =
                    await FirebaseFirestore.instance.collection('users_company').doc(company).get();
                      if (couponrisc.exists) {
                        int used = couponrisc['coupon_used'];
                        FirebaseFirestore.instance
                            .collection('users_company').doc(company)
                            .update({
                          "coupon_used": used+1
                        }).then((value) async{
                          FirebaseFirestore.instance
                              .collection('users_company').doc(company).collection('challenge').doc(widget.couponid).collection('focus')
                              .doc(uuid)
                              .update({
                            "available": available-(providerId['total_focus']*60)
                          }).then((value) async{
                            if(!isgroup){
                              await postsRef.doc(uuid).collection(uuid).doc().set(providerId).then((value) => Navigator.of(context).pop());
                            }else{
                              final QuerySnapshot userlist =
                              await
                              FirebaseFirestore.instance
                                  .collection('users_company').doc(company).collection('users').get();
                              var utenti = userlist.docs;
                              utenti.forEach((element) async{
                                await postsRef.doc(element.id).collection(element.id).doc().set(providerId);
                                await FirebaseFirestore.instance
                                    .collection('users_company').doc(company).collection('challenge').doc(widget.couponid).collection('focus')
                                    .doc(element.id)
                                    .update({
                                  "available": 0
                                });

                              });
                            }

                          });
                        });
                      }



                  }

                });
              }else{
                print('NANI?');
              }
                  },
                    child:
                    Container(
                      margin: EdgeInsets.only(top: 45),

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
                        margin: EdgeInsets.only(top: 45),

                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffFF0F5F),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border()
                      ),
                      child: Container(
                        margin: EdgeInsets.all(3),
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
    if (document['visible']) {
      if (document['total_focus']<=focushour) {
        return  Container(
            color: Colors.white,
            child: CouponTaken(status: 3, title: document['title'], text: document['description'],
              brand: document['brand'], //!document['group']?'Singolo':'Gruppo',
              total: document['total_focus'],
                totalnumber: document['total_coupon'],
                userfocus: focushour, id: document.id,)
        );
      }else{
        return Container(
            color: Colors.white,
            child:CouponTaken(status: 1, title: document['title'], text: document['description'],
                brand: document['brand'], //!document['group']?'Singolo':'Gruppo',
                total: document['total_focus'],
                totalnumber: document['total_coupon'],
                userfocus: focushour, id: 'ff')
        );
      }

    }

  }
}