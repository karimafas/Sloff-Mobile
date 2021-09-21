import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloff/services/SloffApi.dart';
import 'package:sloff/services/provider/TimerNotifier.dart';

class SloffMethods {
  static Future<void> sendNotification(
      String title, String description, String topic) async {
    final results = await FirebaseFunctions.instance
        .httpsCallable("sendNotification")
        .call({"title": title, "description": description, "topic": topic});
    print(results.data);
  }

  static Future<bool> isThereGroupChallenge(String company) async {
    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("challenge")
        .where("visible", isEqualTo: true)
        .where("group", isEqualTo: true)
        .get();

    if (query.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List> getCompanyUserIds(String company) async {
    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("users")
        .get();
    List users = query.docs;

    List userIds = [];
    await Future.forEach(users, (user) => userIds.add(user.reference.id));

    return userIds;
  }

  static Future<int> getUsersFocus(String company) async {
    int focusSum = 0;

    await getCompanyUserIds(company).then((userIds) async {
      await Future.forEach(userIds, (user) async {
        var query1 = await FirebaseFirestore.instance
            .collection("focus")
            .doc(user)
            .get();

        focusSum += query1["available"];
      });
    });

    return focusSum;
  }

  static Future<int> getCurrentChallengeFocus(String company) async {
    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("challenge")
        .where("visible", isEqualTo: true)
        .get();

    var minutes = 0;
    if (query.docs.length > 0) {
      var query2 = await FirebaseFirestore.instance
          .collection("users_company")
          .doc(company)
          .collection("challenge")
          .doc(query.docs[0].reference.id)
          .collection("coupon")
          .get();

      minutes = query2.docs[0]["total_focus"] * 60;
    } else {
      minutes = null;
    }

    return minutes;
  }

  static Future<DocumentSnapshot> getCurrentActiveChallenge(
      String company) async {
    var query = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('challenge')
        .where('visible', isEqualTo: true)
        .get();

    return query.docs[0];
  }

  static Future<bool> isThereActiveReward(String company) async {
    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("challenge")
        .where("visible", isEqualTo: true)
        .get();

    if (query.docs.length > 0) {
      List challenges = query.docs;

      var query1 = await FirebaseFirestore.instance
          .collection("users_company")
          .doc(company)
          .collection("challenge")
          .doc(challenges[0].reference.id)
          .collection("coupon")
          .get();

      if (query1.docs.length > 0) {
        if (query1.docs[0]["total_coupon"] > 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<File> getImage() async {
    final image = await ImagePicker().getImage(
      imageQuality: 5,
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static saveIndividualReward(String rewardId, DocumentSnapshot document,
      Function goToProfile, BuildContext context) async {
    int available;
    bool isGroup = false;

    Map<String, dynamic> rewardToWrite = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid');
    String company = prefs.getString('company');

    final DocumentSnapshot existingReward = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('challenge')
        .doc(rewardId)
        .collection('coupon')
        .doc(document.id)
        .get();

    if (existingReward.exists) {
      List<String> codes = List.from(existingReward['code']);
      isGroup = existingReward['group'];
      rewardToWrite['brand'] = existingReward['brand'];
      rewardToWrite['group'] = existingReward['group'];
      rewardToWrite['code'] =
          existingReward['type'] != 'Libero' ? codes[0] : '';
      rewardToWrite['created_at'] = existingReward['created_at'];
      rewardToWrite['description'] = existingReward['description'];
      rewardToWrite['elapsed_time'] = existingReward['elapsed_coupon_time'];
      rewardToWrite['logo'] = existingReward['logo'];
      rewardToWrite['type'] = existingReward['type'];
      rewardToWrite['title'] = existingReward['title'];
      rewardToWrite['total_coupon'] = existingReward['total_coupon'];
      rewardToWrite['total_focus'] = existingReward['total_focus'];
      rewardToWrite['visible'] = true;
      rewardToWrite['valid_until'] = null;
      rewardToWrite['redeemed_at'] = Timestamp.fromDate(DateTime.now());
      rewardToWrite['value'] =
          existingReward['value'] != null ? existingReward['value'] : '';
      if (codes.isNotEmpty) {
        codes.removeAt(0);
      }
      FirebaseFirestore.instance
          .collection('users_company')
          .doc(company)
          .collection('challenge')
          .doc(rewardId)
          .collection('coupon')
          .doc(document.id)
          .update({
        "total_coupon": !isGroup ? rewardToWrite['total_coupon'] - 1 : 0,
        "completed": rewardToWrite['total_coupon'] - 1 > 0 ? false : true,
        "visible": rewardToWrite['total_coupon'] - 1 > 0 ? true : false,
        "code": codes,
      }).then((value) async {
        final DocumentSnapshot query = await FirebaseFirestore.instance
            .collection("focus")
            .doc(uuid)
            .get();
        if (query.exists) {
          available = query['available'];
          final DocumentSnapshot query2 = await FirebaseFirestore.instance
              .collection('users_company')
              .doc(company)
              .get();
          if (query2.exists) {
            int used = query2['coupon_used'];
            FirebaseFirestore.instance
                .collection('users_company')
                .doc(company)
                .update({"coupon_used": used + 1}).then((value) async {
              FirebaseFirestore.instance.collection("focus").doc(uuid).update({
                "available": available - (rewardToWrite['total_focus'] * 60)
              }).then((value) async {
                if (!isGroup) {
                  FirebaseFirestore.instance
                      .collection('users_coupon')
                      .doc(uuid)
                      .collection(uuid)
                      .doc()
                      .set(rewardToWrite);
                }

                var token =
                    await FirebaseAuth.instance.currentUser.getIdToken();
                SloffApi.subtractFocus(
                    uuid, rewardToWrite['total_focus'] * 60, token);
              }).then((value) {
                Provider.of<TimerNotifier>(context, listen: false)
                    .loadRedeemedRewards()
                    .then((value) => goToProfile());
              });
            });
          }
        }
      });
    }
  }

  static writeGroupReward(
      DocumentSnapshot document, String company, String uuid) async {
    Map<String, dynamic> providerId = new Map();

    var now = DateTime.now();
    var validUntil = new DateTime(now.year, now.month, now.day + 14);
    Timestamp tsValidUntil = Timestamp.fromDate(validUntil);

    List<String> codes = List.from(document['code']);
    providerId['brand'] = document['brand'];
    providerId['group'] = true;
    providerId['code'] = document['type'] != 'Libero' ? codes[0] : '';
    providerId['created_at'] = document['created_at'];
    providerId['description'] = document['description'];
    providerId['elapsed_time'] = document['elapsed_coupon_time'];
    providerId['logo'] = document['logo'];
    providerId['type'] = document['type'];
    providerId['title'] = document['title'];
    providerId['total_coupon'] = document['total_coupon'];
    providerId['total_focus'] = document['total_focus'];
    providerId['visible'] = true;
    providerId['value'] = document['value'] != null ? document['value'] : '';
    providerId['valid_until'] = tsValidUntil;
    providerId['redeemed_at'] = Timestamp.fromDate(DateTime.now());

    final QuerySnapshot usersList = await FirebaseFirestore.instance
        .collection('users_company')
        .doc(company)
        .collection('users')
        .get();
    var users = usersList.docs;

    final query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("challenge")
        .doc(document.id)
        .collection("coupon")
        .get();

    String rewardID = query.docs[0].reference.id;

    Future.forEach(users, (user) {
      FirebaseFirestore.instance
          .collection('users_coupon')
          .doc(user.id)
          .collection(user.id)
          .doc()
          .set(providerId)
          .then((value) {
        FirebaseFirestore.instance.collection("focus").doc(user.id).update({
          "available": 0,
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection('users_company')
            .doc(company)
            .collection('challenge')
            .doc(document.id)
            .collection('coupon')
            .doc(rewardID)
            .update({'total_coupon': 0, "completed": true, "visible": false});
      });
    });
  }
}
