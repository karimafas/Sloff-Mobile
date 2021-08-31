import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sloff/services/SloffApi.dart';

class TimerNotifier extends ChangeNotifier {
  final String company;
  final String uuid;

  TimerNotifier(this.company, this.uuid);

  // INTERFACE
  int rankingProgression =
      -1; // -1 = loading, 0 = stable, 1 = descending, 2 = ascending

  void setRanking(int initialRanking, int finalRanking) {
    Future.delayed(Duration(seconds: 2));

    if (initialRanking > finalRanking) {
      rankingProgression = 1;
    } else if (initialRanking < finalRanking) {
      rankingProgression = 2;
    } else if (initialRanking == finalRanking) {
      rankingProgression = 0;
    }

    notifyListeners();
  }

  void resetRanking() {
    rankingProgression = -1;

    notifyListeners();
  }

  // INDIVIDUAL FOCUS
  int individualFocusMinutes = 0;

  Future<void> getIndividualFocus(token) async {
    //var minutes = jsonDecode(await SloffApi.getFocus(uuid, token))['available'];

    var minutes =
        await FirebaseFirestore.instance.collection("focus").doc(uuid).get();

    individualFocusMinutes = minutes['available'];

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
