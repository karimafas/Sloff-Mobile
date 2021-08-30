import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/pages/Onboarding.dart';
import 'package:toast/toast.dart';

class CambioCausa extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool inside;
  final int selectedCauseIndex;

  const CambioCausa(
      {Key key,
      this.text,
      this.onTap,
      this.inside = false,
      this.selectedCauseIndex})
      : super(key: key);

  @override
  _CambioCausa createState() => _CambioCausa();
}

class _CambioCausa extends State<CambioCausa> {
  @override
  initState() {
    super.initState();

    if (widget.selectedCauseIndex != null) {
      selectedCause[widget.selectedCauseIndex] = true;
    }
  }

  int index = -1;
  List<String> cause = [
    'Environmental\nprotection',
    'Animal\nprotection',
    'Health',
    'Social\nequality',
    'Human\nrights',
    'Fair\neconomy',
    'Education and\ntraining',
    'Civil and\nemergency',
  ];
  List<String> images = [
    'assets/images/Cause/1.jpeg',
    'assets/images/Cause/2.jpeg',
    'assets/images/Cause/3.jpeg',
    'assets/images/Cause/4.jpeg',
    'assets/images/Cause/5.jpeg',
    'assets/images/Cause/6.jpeg',
    'assets/images/Cause/7.jpeg',
    'assets/images/Cause/8.jpeg',
  ];
  List<bool> selectedCause = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  int _selectedCauseIndex = -1;
  bool hasSelectedCause = false;

  showpop() {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              //height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  SizedBox(
                      child: Image.asset(
                          'assets/images/Onboarding/Earth_illustration.png'),
                      width: MediaQuery.of(context).size.width * 0.9),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("whycausetitle".tr(),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 20,
                            fontFamily: 'GrandSlang',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("whycause".tr(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins-Light',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  RectangleButton(
                    onTap: () => Navigator.pop(context),
                    text: "thatsgood".tr().toUpperCase(),
                    color: new Color(0xFF694EFF),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ],
        ));

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
      backgroundColor: new Color(0xFFFFF8ED),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width :MediaQuery.of(context).size.width * 0.7,
                    child: new RichText(
                        textAlign: TextAlign.left,
                        text: new TextSpan(
                            style: new TextStyle(
                              fontSize: 26.0,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: e.tr('Sceltacausadomanda') + ' ',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontFamily: 'GrandSlang',
                                    color: new Color(0xFF190E3B)),
                              ),
                            ])),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    child: new RichText(
                        textAlign: TextAlign.left,
                        text: new TextSpan(
                            style: new TextStyle(
                              fontSize: 13,
                              color: new Color(0xFF190E3B),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins-Regular',
                            ),
                            children: [
                              TextSpan(
                                text: e.tr('Sceltacausaselezione') + ' ',
                              ),
                            ])),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                //color: Colors.white30,
                child: Container(
                    child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedCause[index] == true
                                  ? new Color(0xFF694EFF)
                                  : Colors.transparent,
                              width: 4),
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCause = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  selectedCause[index] = !selectedCause[index];
                                  _selectedCauseIndex = index;
                                });
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(images[index]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                          )),
                                      Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                            Colors.transparent,
                                            new Color(0xFF190E3B)
                                          ]))),
                                      Positioned(
                                          bottom: 10,
                                          left: 13,
                                          child: Text(
                                            cause[index],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'Poppins-Regular',
                                              color: Colors.white,
                                            ),
                                          )),
                                    ],
                                  )))),
                    );
                  },
                )),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  RectangleButton(
                    onTap: () async {
                      Map<String, dynamic> providerId = new Map();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String uuid = prefs.getString('uuid');

                      for (int i = 0; i < selectedCause.length; i++) {
                        if(selectedCause[i] == true){
                          _selectedCauseIndex = i;
                        }
                      }

                      FirebaseFirestore.instance
                          .collection('users_cause')
                          .doc(uuid)
                          .set({"cause": _selectedCauseIndex}).then(
                              (value) async {
                        if(widget.inside){
                          Navigator.pop(context);
                        }
                        else {
                          if(_selectedCauseIndex != -1)
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnboardingReady()));
                          }
                          else {
                            Toast.show("Seleziona una causa.", context);
                          }
                        }
                      });
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                    text: "save".tr().toUpperCase(),
                    color: new Color(0xFF694EFF),
                  ),
                  GestureDetector(
                      onTap: () {
                        showpop();
                      },
                      child: Container(
                        width: 327,
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: new RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: e.tr('Perchchiediamo') + ' ',
                                    style: new TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: 15,
                                        color: new Color(0xFF694EFF),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ])),
                      )),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
