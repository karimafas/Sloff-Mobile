import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}
