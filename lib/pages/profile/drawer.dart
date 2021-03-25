import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/pages/prelogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class DrawerUiWidget extends StatelessWidget {


  const DrawerUiWidget(
      {Key key,
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      child: Drawer(
        elevation: 0,

          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new AppBar(
                  leading: null,
                  backgroundColor: Colors.white,
                  title: Text("Menù", textAlign: TextAlign.left,style: new TextStyle(fontWeight: FontWeight.bold,  fontSize: 25, color: Colors.black)),
                  centerTitle: true,
                  actions: <Widget>[
                    new
                    GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child:new IconButton(
                          icon: Icon(Icons.clear),color: Colors.black,)),
                  ],

                  elevation: 0,
                ),
            Expanded(child:
            Container(
                margin: EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                child:
            ListView(

              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Impostazioni.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Impostazioni'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),
                Container(height: 30, width: MediaQuery.of(context).size.width,),
                //2
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Gestione_account.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GestioneAccount'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),
                Container(height: 30, width: MediaQuery.of(context).size.width,),
                //2
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Servizio_Clienti.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ServizioClienti'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),
                Container(height: 30, width: MediaQuery.of(context).size.width,),
                //3
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Segnala.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Segnala'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),
                Container(height: 30, width: MediaQuery.of(context).size.width,),
              //4
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Privacy_policy.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                ),
                Container(height: 30, width: MediaQuery.of(context).size.width,),
                GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('uuid', null);
                    FirebaseAuth.instance.signOut();
                    final GoogleSignIn googleSignIn = await GoogleSignIn();
                    googleSignIn.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => PreLogin(
                          ),
                        ),
                            (Route<dynamic> route) => false);

                  },
                  child:
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/menu/Esci.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Esci'.tr()+' ', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                      ],
                    )),
                  ],
                )),
              ],
            )))


              ],
            ),
          )),
    );
  }
}