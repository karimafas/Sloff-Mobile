import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ListFooterIndividual extends StatelessWidget {
  const ListFooterIndividual({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets
            .symmetric(
                horizontal:
                    50,
                vertical:
                    30),
        child: Column(
          children: [
            Text(
                'Finelista1'
                    .tr(),
                textAlign: TextAlign
                    .center,
                style: new TextStyle(
                    fontFamily:
                        'Poppins-Regular',
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize:
                        10,
                    color: Colors
                        .black)),
            SizedBox(
                height: 3),
            Text(
                'Finelista2'
                    .tr(),
                textAlign: TextAlign
                    .center,
                style: new TextStyle(
                    fontFamily:
                        'Poppins-Regular',
                    fontWeight:
                        FontWeight
                            .normal,
                    fontSize:
                        10,
                    color: Colors
                        .black)),
          ],
        ));
  }
}