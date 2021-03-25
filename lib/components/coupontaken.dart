import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sloff/pages/coupon/coupondetail.dart';
import 'package:sloff/pages/coupon/couponuse.dart';
import 'package:sloff/pages/coupon/couponconfirm.dart';
import 'package:clipboard/clipboard.dart';
import 'package:sloff/pages/coupon/couponeliminate.dart';


class CouponTaken extends StatelessWidget {
  final String title;
  final String couponid;
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
  final int userfocusdetail;
  final bool isusing;


  const CouponTaken({
    Key key,
    this.text,
    this.couponid,
    this.userfocusdetail =0,
    this.id,
    this.title,
    this.onTap,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.arrow = true,
    this.mini=false,
    this.status,
    this.logo = '',
    this.elapsed,
    this.brand,
    this.total,
    this.userfocus,
    this.code,
    this.totalnumber=0,
    this.fromprofile = false,
    this.uuid='',
    this.isusing=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ilcolor=this.color;
    print('el FOCUS DETAIL'+userfocusdetail.toString());
    return
        GestureDetector(
      onTap: onTap,
      child:  Container(
        height: !isusing?230:300,
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
                    top: 0,
                    right: 0,
                    child:/* Hero(
                        tag: id,
                        child:*/Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: status==4?SvgPicture.asset('assets/images/Coupon/Coupon_da_riscattare.svg', fit: BoxFit.cover,):status==5?SvgPicture.asset('assets/images/Profilo/Coupon_aperto.svg', fit: BoxFit.cover,):
                      status==3?SvgPicture.asset('assets/images/Coupon/Coupon_da_riscattare.svg', fit: BoxFit.cover,):SvgPicture.asset('assets/images/Coupon/Coupon_grigio.svg', fit: BoxFit.cover,),
                    )//),
                  ),
              Align(
                alignment: Alignment.topCenter,
                child: new
                Container(
                    width: 250,
                    child:
                Column(children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.of(context).push( MaterialPageRoute<void>(
                      builder: (BuildContext context) => CouponDetail(
                          id: id,
                        uuid: uuid,
                        fromprofile: fromprofile,
                        status: status,
                        focushour: userfocus,
                        brand: brand,
                        //fromlogin: true,
                        //userName: user.user.uid,
                      ),
                    ),
                    ),
                    child:
                  CircleAvatar(
                    backgroundImage:  NetworkImage('https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Sloff_logo_Ottobre_2020.png?alt=media&token=ca23f1ac-a5f9-4deb-b8e6-e6b547cb4ba9'),
                    radius: 27.0,)
                  ),
                  //SizedBox.fromSize(),
                    new Container(
                      padding: EdgeInsets.only(top: 5),
                      child:
                      Text(
                    brand,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: status>=3?Colors.white:Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: -0.8,
                      //height: 1.15385,
                    ),
                  )),
                  SizedBox.fromSize(),
                    new Container(
                        padding: EdgeInsets.only(top:14),
                      child:
                      Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: -0.8,
                      height: 1.15385,
                    ),
                  )),
                  Container(height: 1,),
                    new Container(
                        padding: EdgeInsets.only(top: 2, left: 50, right: 50),
                      child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: status>=3?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      letterSpacing: -0.5,
                      height: 1.15385,
                    ),
                  )),
                    Container(height: 10,),
                    status==4?GestureDetector(
                      onTap:() =>Navigator.of(context).push( MaterialPageRoute<void>(
                        builder: (BuildContext context) => CouponUse(
                          code: code,
                            couponuid: id,
                          brand: brand
                          //fromlogin: true,
                          //userName: user.user.uid,
                        ),
                      ),
                      )
                        ,
                        child:
                        Container(
                      margin: EdgeInsets.only(top: 5),

                      width: 180,
                    height: 34,
                    decoration: BoxDecoration(
                    color: Color(0xffFF7E05),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Utilizza".tr().toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )):
                        status==3?
                    GestureDetector(
                        onTap:() =>
                            Navigator.of(context).push( MaterialPageRoute<void>(
                          builder: (BuildContext context) => CouponConfirm(
                            id: id,
                            focushour: userfocus,
                              couponid: couponid
                            //fromlogin: true,
                            //userName: user.user.uid,
                          ),
                        ),)
                        ,
                        child:
                        Container(
                          margin: EdgeInsets.only(top: 5),

                          width: 160,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Riscatta".tr().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )):
                    status==5?Container(
                        padding: EdgeInsets.only(top: 65),
                        child:code!=''?RaisedButton(
                          color: Color(0xffFF7E05),
                      child: Text(code, style: TextStyle(color: Colors.white,
                      fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.w700),),
                      onPressed: () {
                        FlutterClipboard.copy(
                            code)
                            .then((result) {
                          final snackBar = SnackBar(
                            content: Text('Codice copiato'),
                            action: SnackBarAction(
                              label: 'Annulla',
                              onPressed: () {},
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                      },
                    ):Container()):
                        Column(children: [
                          Container(height: 10,
                          ),
                          Text((userfocus/total*100).toStringAsPrecision(2).toString()+'%', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                          Container(height: 5,
                          ),
                          new
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child:LinearPercentIndicator(
                            //width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            lineHeight: 8.0,
                            animationDuration: 2000,
                            percent: (userfocus/total),
                            //center: Text("90.0%"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xff9BDB46),
                            backgroundColor: Colors.black,
                          )),
                        ],)

                ],))),
              Positioned(
                left: 0,//23.5,
                top: 25, //18,
                child:Container(
                  height: 10,
                  width: 10,
                  color: Colors.white,
                )),
                  status<4?Positioned(
                      right: 0,//23.5,
                      top: 25, //18,
                      child:Container(
                        height: 10,
                        width: 10,
                        color: Colors.white,
                      )):Container(),
                  status>3?Positioned(
                    left: 0,//23.5,
                    top: 25, //18,
                    child:
                    Container(
                      width: 110,
                      //margin: EdgeInsets.only(left: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffFF0F5F),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                      ),
                      //child:
                      // color: Colors.pink,
                      //new Flexible(
                    child: Text(
                      "Utilizza entro "+ elapsed.toDate().toString().substring(0, 10),
                      //totalnumber<20?"Restano solo "+totalnumber.toString()+" coupon":totalnumber.toString()+" coupon disponibili",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: -0.39,
                        height: 1.15385,
                      ),
                    )//),
                  ),):
                  Positioned(
                    left: 0,//23.5,
                    top: 25, //18,
                    child:
                    Container(
                        width: 100,
                        //margin: EdgeInsets.only(left: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: totalnumber<20?Color(0xffFF0F5F):Colors.blueAccent,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                        ),
                        //child:
                        // color: Colors.pink,
                        //new Flexible(
                        child: Text(
                          //"Utilizza entro\n5 g : 23 h : 59 m",
                          totalnumber<20?"Restano solo\n "+totalnumber.toString()+" coupon!":totalnumber.toString()+" coupon disponibili",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            letterSpacing: -0.39,
                            height: 1.15385,
                          ),
                        )//),
                    ),),
                  status<4?Positioned(
                    right: 0,//23.5,
                    top: 25, //18,
                    child:
                    Container(
                      //margin: EdgeInsets.only(left: 15),
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff9BDB46),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                      ),
                      //child:
                      // color: Colors.pink,
                     // new Flexible(
                          child: Text(
                            status<3 && total-userfocus>1?"Mancano "+(total-userfocus).toString()+"\nore di focus":
                            status<3 && total-userfocus<=1?"Mancano "+(60-userfocusdetail).toString()+"\nmin di focus":
                            "È ora di\nriscattarlo",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              letterSpacing: -0.39,
                              height: 1.15385,
                            ),
                          )//),
                    ),):fromprofile?Positioned(
                      right: 0,//23.5,
                      top: 25,
                      child: GestureDetector(
                      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => CouponEliminate(id: id, uuid: uuid))),
                      child: //18,
                          Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.cancel, color: Color(0xffFF0F5F))))):Container()

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }



}


