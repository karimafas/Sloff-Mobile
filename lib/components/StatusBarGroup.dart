import 'package:flutter/material.dart';

class StatusBarGroup extends StatelessWidget {
  const StatusBarGroup({
    Key key,
    @required this.challengeTitle,
    @required this.challengeStart,
    @required this.challengeEnd,
  }) : super(key: key);

  final String challengeTitle;
  final String challengeStart;
  final String challengeEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius
                    .circular(5),
            color: new Color(
                    0xFFFFE9C1)
                .withOpacity(.7)),
        margin:
            EdgeInsets.symmetric(
                horizontal: 20),
        child: Padding(
          padding:
              const EdgeInsets
                      .symmetric(
                  horizontal: 20),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(
                      challengeTitle,
                      style: TextStyle(
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color: new Color(
                              0xFF190E3B))),
                  Text("Group",
                      style: TextStyle(
                          fontSize:
                              12,
                          color: new Color(
                              0xFF190E3B))),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                          'Starts: ',
                          style: TextStyle(
                              fontSize:
                                  12,
                              color:
                                  new Color(0xFF190E3B))),
                      Text(
                          challengeStart,
                          style: TextStyle(
                              fontSize:
                                  12,
                              fontWeight:
                                  FontWeight.bold,
                              color: new Color(0xFF190E3B))),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          'Ends: ',
                          style: TextStyle(
                              fontSize:
                                  12,
                              color:
                                  new Color(0xFF190E3B))),
                      Text(
                          challengeEnd,
                          style: TextStyle(
                              fontSize:
                                  12,
                              fontWeight:
                                  FontWeight.bold,
                              color: new Color(0xFF190E3B))),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}