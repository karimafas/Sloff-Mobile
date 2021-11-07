import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sloff/services/SloffApi.dart';

class TimerNotifier extends ChangeNotifier {
  String company;
  String uuid;

  void setUserCompany({@required u, @required c}) {
    company = c;
    uuid = u;
  }

  Future<void> initialise() async {
    await loadUserData();
    await getIndividualFocus();
    await loadRedeemedRewards();
    await getRedeemedRewardsQuantity();
  }

  // User Data
  String first_name;
  String last_name;
  String profile_picture = "";
  DateTime userCreationDt;
  int loadedRewards = 5;
  List redeemedRewards;
  int redeemedRewardsQuantity = 0;
  int initialRanking;
  int finalRanking;

  Future<void> loadUserData() async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(uuid).get();

    first_name = user['name'];
    last_name = user['surname'];
    profile_picture = user['profile_picture'];
    userCreationDt = DateTime.fromMillisecondsSinceEpoch(user['created_date']);

    notifyListeners();
  }

  void loadMoreRewards() {
    loadedRewards += 5;

    loadRedeemedRewards();
  }

  Future<void> getInitialRanking(String uuid) async {
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    initialRanking =
        jsonDecode(await SloffApi.findRanking(uuid: uuid, token: token));

    notifyListeners();
  }

  Future<void> getFinalRanking(String uuid) async {
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    finalRanking =
        jsonDecode(await SloffApi.findRanking(uuid: uuid, token: token));

    notifyListeners();
  }

  Future<void> getRedeemedRewardsQuantity() async {
    var query1 = await FirebaseFirestore.instance
        .collection('users_coupon')
        .doc(uuid)
        .collection(uuid)
        .get();

    redeemedRewardsQuantity = query1.docs.length;

    print("total rewards $redeemedRewardsQuantity");
  }

  Future<void> loadRedeemedRewards() async {
    var query = await FirebaseFirestore.instance
        .collection('users_coupon')
        .doc(uuid)
        .collection(uuid)
        .orderBy('redeemed_at', descending: true)
        .limit(loadedRewards)
        .get();

    redeemedRewards = query.docs;

    // Redeemed rewards have to be visible and not past expiry date

    List filteredRewards = [];

    redeemedRewards.forEach((element) {
      if (element['visible'] == true &&
          (element['valid_until'] == null ||
          DateTime.now().isBefore(element['valid_until'].toDate()))) {
        filteredRewards.add(element);
      }
    });

    redeemedRewards = filteredRewards;

    notifyListeners();
  }

  // Focus
  int individualAvailableFocusMinutes = 0;
  int individualTotalFocusMinutes = 0;

  Future<void> getIndividualFocus() async {
    var minutes =
        await FirebaseFirestore.instance.collection("focus").doc(uuid).get();

    individualAvailableFocusMinutes = minutes['available'];
    individualTotalFocusMinutes = minutes['total'];

    notifyListeners();
  }
}
