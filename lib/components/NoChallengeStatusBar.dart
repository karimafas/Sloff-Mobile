import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NoChallengeStatusBar extends StatelessWidget {
  const NoChallengeStatusBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("nochallenge1".tr(),
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black)),
        SizedBox(height: 5),
        Text('nochallenge2'.tr(),
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.normal,
                fontSize: 10,
                color: Colors.black)),
      ],
    );
  }
}