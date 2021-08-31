import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sloff/components/Animations.dart';
import 'package:sloff/components/RectangleButton.dart';
import 'package:sloff/components/SloffMethods.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class SloffModals {
  SloffModals.focusCompleted(BuildContext context, int minutes, String name,
      Function callback, String company) {
    AlertDialog alert;

    SloffMethods.isThereActiveReward(company).then((activeReward) {
      alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                children: [
                  SizedBox(
                      child: Image.asset(
                          'assets/images/Coupon/Thank_you_image.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Text("Completo1".tr(namedArgs: {'name': name.capitalize()}),
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 20,
                          fontFamily: 'GrandSlang',
                          color: new Color(0xFF190E3B)),
                      textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Completo2"
                            .tr(namedArgs: {'minutes': minutes.toString()}),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 13,
                            fontFamily: 'Poppins-Light',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  activeReward
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04)
                      : Container(),
                  activeReward
                      ? RectangleButton(
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 200), () {
                              callback();
                            });
                          },
                          text: "go-to-rewards".tr(),
                          color: new Color(0xFFFF6926),
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RectangleButton(
                    onTap: () => Navigator.pop(context),
                    text: activeReward ? "skip".tr() : "COOL!",
                    color: activeReward
                        ? new Color(0xFFA4A0B2)
                        : new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ],
        ),
      );
    }).then((value) {
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SlideYFadeInBottom(0.5, alert);
        },
      );
    });
  }

  SloffModals.focusLost(
      BuildContext context, int minutes, String name, Function callback) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.78,
            child: Column(
              children: [
                SizedBox(
                    child: Image.asset('assets/images/Coupon/focus_lost.png'),
                    width: MediaQuery.of(context).size.width * 0.8),
                SizedBox(height: 20),
                Text("focuslost1".tr(),
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 20,
                        fontFamily: 'GrandSlang',
                        color: new Color(0xFF190E3B)),
                    textAlign: TextAlign.center),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("focuslost2".tr(),
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 13,
                          fontFamily: 'Poppins-Light',
                          color: new Color(0xFF190E3B)),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("focuslost3".tr(),
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 13,
                          fontFamily: 'Poppins-Light',
                          color: new Color(0xFF190E3B)),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                RectangleButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "sure".tr(),
                  color: new Color(0xFFFF6926),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SlideYFadeInBottom(0.5, alert);
      },
    );
  }

  SloffModals.unlockIndividualReward(
      BuildContext context,
      String couponid,
      int usertime,
      var document,
      Function(String, DocumentSnapshot) saveReward) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child:
                          Image.asset('assets/images/Coupon/Unlock_prize.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("unlock-title".tr(),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 23,
                            fontFamily: 'GrandSlang',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        "reward-cost".tr(namedArgs: {
                          "hours-spent":
                              (document['total_focus'] * 60).toString(),
                          "hours-left":
                              (usertime - (document['total_focus'] * 60))
                                  .round()
                                  .toString()
                        }),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular'),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RectangleButton(
                    onTap: () async {
                      saveReward(couponid, document);
                      Navigator.pop(context);
                    },
                    text: "im-sure".tr().toUpperCase(),
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 10),
                  RectangleButton(
                    onTap: () => Navigator.pop(context),
                    text: "NO",
                    color: new Color(0xFFA4A0B2),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ));

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  SloffModals.unlockGroupReward(BuildContext context, Function(bool) callback) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child:
                          Image.asset('assets/images/Coupon/Unlock_prize.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("teamreward-title".tr(),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 23,
                            fontFamily: 'GrandSlang',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("teamreward-text".tr(),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular'),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 30),
                  RectangleButton(
                    onTap: () {
                      Navigator.pop(context);
                      callback(true);
                    },
                    text: "SHOW ME MORE!",
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 20),
                  RectangleButton(
                    onTap: () {
                      Navigator.pop(context);
                      callback(false);
                    },
                    text: "skip".tr(),
                    color: new Color(0xFFA4A0B2),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ));

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SlideYFadeInBottom(0.5, alert);
        });
  }

  SloffModals.congratsPopUp(BuildContext context) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              //height: MediaQuery.of(context).size.height * 0.53,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child: Image.asset(
                          'assets/images/Coupon/Reward_compliment.png'),
                      width: MediaQuery.of(context).size.width * 0.8),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("congrats".tr(),
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 23,
                            fontFamily: 'GrandSlang',
                            color: new Color(0xFF190E3B)),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("use-card".tr(),
                        style: TextStyle(
                            color: new Color(0xFF190E3B),
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular'),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RectangleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "awesome".tr().toUpperCase(),
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ));

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  SloffModals.profilePicture(
      BuildContext context, Function uploadPicture, Function removePicture) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RectangleButton(
                    onTap: () {
                      uploadPicture();
                      Navigator.pop(context);
                    },
                    text: "change-picture".tr().toUpperCase(),
                    color: new Color(0xFFFF6926),
                  ),
                  SizedBox(height: 10),
                  RectangleButton(
                    onTap: () {
                      removePicture();
                      Navigator.pop(context);
                    },
                    text: "remove-picture".tr().toUpperCase(),
                    color: new Color(0xFFA4A0B2),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ));

    showDialog(
        context: context,
        builder: (context) {
          return SlideYFadeInBottom(0.5, alert);
        });
  }
}
