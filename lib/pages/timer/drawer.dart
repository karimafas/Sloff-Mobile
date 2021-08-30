import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class DrawerUiWidget extends StatelessWidget {


  const DrawerUiWidget(
      {Key key,
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        elevation: 0,

          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new AppBar(
                  backgroundColor: Colors.white,
                  title: Text('Notifiche'.tr().toUpperCase(),
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),),
                  centerTitle: true,
                leading:
                new
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child:new IconButton(
                    iconSize: 16,
                icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                  )),
                  elevation: 0,
                ),

                /*Row(
                  children: <Widget>[
                    Container(
                      child: Builder(builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                      }),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      child:
                    Text('Notifiche'.tr().toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20,),)),
                  ],
                ),*/
          //)
            Expanded(child:
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child:
            ListView(

              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notifichetitle'.tr()+' Adidas ', style: TextStyle(color: Color(0xff1D1D1B), fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                        Container(height: 4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         // crossAxisAlignment: CrossAxisAlignment.s,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [                        Text('Notifichetext'.tr(), style: TextStyle(color: Color(0xff1D1D1B), fontSize: 12), textAlign: TextAlign.left,),
                                Container(height: 6,)]),
                          Text('12:44', style: TextStyle(color: Color(0xffC6C6C6), fontSize: 12),)


                          ]),
                      ],
                    )),
                  ],
                ),
                Container(height: 10, width: MediaQuery.of(context).size.width,),
                Container(height: 1, width: MediaQuery.of(context).size.width*0.9,color: Color(0xffF2F2F2)),
                Container(height: 10, width: MediaQuery.of(context).size.width,),

                //2
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notifichetitle'.tr()+' Adidas ', style: TextStyle(color: Color(0xff1D1D1B), fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                        Container(height: 4,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.s,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [                        Text('Notifichetext'.tr(), style: TextStyle(color: Color(0xff1D1D1B), fontSize: 12), textAlign: TextAlign.left,),
                                    Container(height: 6,)]),
                              Text('12:44', style: TextStyle(color: Color(0xffC6C6C6), fontSize: 12),)


                            ]),
                      ],
                    )),
                  ],
                )
              ],
            )))


              ],
            ),
          )),
    );
  }
}