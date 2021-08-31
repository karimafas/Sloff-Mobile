import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sloff/services/SloffApi.dart';

class TimerNotifier extends ChangeNotifier {
  final String company;
  final String uuid;

  TimerNotifier(this.company, this.uuid);

  // INDIVIDUAL FOCUS
  int individualFocusMinutes = 0;

  Future<void> getIndividualFocus() async {
    individualFocusMinutes = 10;

    notifyListeners();
  }

  // GROUP FOCUS
  int groupFocusMinutes = 0;
  int groupRequiredMinutes = 0;
  bool groupChallengeCompletePopup = false;

  Future<void> getGroupFocus() async {
    groupFocusMinutes = await SloffApi.getCompanyGroupFocus(companyID: company);

    notifyListeners();
  }

  Future<void> getGroupRequiredMinutes() async {
    var query = await FirebaseFirestore.instance
        .collection("users_company")
        .doc(company)
        .collection("challenge")
        .where("visible", isEqualTo: true)
        .get();

    groupRequiredMinutes = query.docs[0]["total_focus"] * 60;

    checkPopup();
  }

  void checkPopup() {
    if (groupFocusMinutes >= groupRequiredMinutes) {
      groupChallengeCompletePopup = true;
    }

    notifyListeners();
  }
}
