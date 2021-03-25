import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:easy_localization/easy_localization.dart' as e;

import 'package:carousel_slider/carousel_slider.dart';
import'package:sloff/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CambioCausa extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool inside;

  const CambioCausa({
    Key key,
    this.text,
    this.onTap,
    this.inside = false
  }) : super(key: key);

  @override
  _CambioCausa createState() => _CambioCausa();
}

class _CambioCausa extends State<CambioCausa>{


  @override
  void initState() {
    super.initState();

  }

int index=-1;
List<String> cause = [
  'Salvaguardia \nambientale',
  'Protezione \nanimali',
  'Salute',
  'Uguaglianza \nsociale',
  'Diritti \numanitari',
  'Economia \nsolidale',
  'Istruzione e \nformazione',
  'Civile ed \nemergenza',
];
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

  showpop(){
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Whycausetitle'.tr()),
      content: Text('Whycause'.tr()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text('Sceltacausa'.toUpperCase(),
          style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
      SafeArea(
          child:
          Container(padding: EdgeInsets.all(15),
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width:  MediaQuery.of(context).size.width,
              child:
                  Column(children: [
                    Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 26.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(
                                  text: e.tr('Sceltacausadomanda')+' ',
                                  style: TextStyle(
                                      fontSize: 21.0,
                                      letterSpacing: -0.8,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black
                                  ),                                ),

                              ]
                          )),
                    ),
                    Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                letterSpacing: -0.8,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',


                              ),
                              children:[
                                TextSpan(
                                  text: e.tr('Sceltacausaselezione')+' ',
                                ),

                              ]
                          )),
                    ),
                    Expanded(
                      //color: Colors.white30,
                      child:
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child:

                          GridView.builder(
                          itemCount: images.length,
                          padding: const EdgeInsets.all(4.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,),
                          itemBuilder: (BuildContext context, int index) {
                          return GridTile(
                              child:
                              /*GestureDetector(onTap: (){
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeInitialPage())
                                );



                            },
                            child:*/
                              GestureDetector(
                                  onTap: () async{
                                    Map<String, dynamic> providerId = new Map();
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String uuid = prefs
                                        .getString('uuid');

                                    FirebaseFirestore.instance
                                        .collection('users_cause')
                                        .doc(uuid)
                                        .set({
                                      "cause": index
                                    }).then((value) async{
                                      widget.inside?Navigator.of(context).pop()
                                      :Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomeInitialPage())
                                      );

                                    });


                                  },
                                  child:
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child:
                                      Stack(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(images[index]),
                                            ),
                                          ),
                                          //child:

                                          //Image.asset(url, fit: BoxFit.fill)
                                        ),
                                        Positioned(top: 5, right: 5, child: Icon(Icons.info_outline, color: Colors.white,)),
                                        Positioned(bottom: 5, left: 5, child: Text(cause[index],
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            letterSpacing: -0.8,
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,),))
                                      ],)))


                          );
                          },
                          ))
                      /*GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          padding: const EdgeInsets.all(4.0),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          children: <String>[
                                'assets/images/Cause/1.jpeg',
                            'assets/images/Cause/2.jpeg',
                            'assets/images/Cause/3.jpeg',
                            'assets/images/Cause/4.jpeg',
                            'assets/images/Cause/5.jpeg',
                            'assets/images/Cause/6.jpeg',
                            'assets/images/Cause/7.jpeg',
                            'assets/images/Cause/8.jpeg',

                                //'https://firebasestorage.googleapis.com/v0/b/sloff-1c2f2.appspot.com/o/Animal_Equality.png?alt=media&token=d0fd5b14-6e68-4c22-b088-54bab84312be',
                               ].map((String url) {
                                 index = index+1;
                            return GridTile(
                                child:
                                /*GestureDetector(onTap: (){
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeInitialPage())
                                );



                            },
                            child:*/
                                GestureDetector(
                                    onTap: () async{
                                      Map<String, dynamic> providerId = new Map();
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String uuid = prefs
                                          .getString('uuid');

                                      Firestore.instance
                                          .collection('users_cause')
                                          .document(uuid)
                                          .setData({
                                        "cause": index
                                      }).then((value) async{
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomeInitialPage())
                                        );

                                      });


                                    },
                                    child:
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child:
                                    Stack(children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(url),
                                                ),
                                              ),
                                              //child:

                                          //Image.asset(url, fit: BoxFit.fill)
                                  ),
                                      Positioned(top: 5, right: 5, child: Icon(Icons.info_outline, color: Colors.white,)),
                                      Positioned(bottom: 5, left: 5, child: Text(cause[index], style: TextStyle(fontWeight: FontWeight.bold),))
                                    ],)))


                            );
                          }).toList())*/,
                    ),
                    GestureDetector(
                      onTap: (){
                        showpop();
                      },
                        child:
                    Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      child: new RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                                  fontWeight: FontWeight.bold
                              ),
                              children:[
                                TextSpan(
                                  text: e.tr('Perchchiediamo')+' ',
                                  style: new TextStyle(
                                    fontFamily: 'Montserrat',
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ]
                          )),
                    )),
                  ],),


              )),
    );
  }


}







