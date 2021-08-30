import 'package:flutter/material.dart';

class SloffButton extends StatelessWidget {
  const SloffButton({
    Key key,
    this.onTap, this.text,
  }) : super(key: key);
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 230,
          height: 60,
          decoration: BoxDecoration(
              color: new Color(0xFFFF6926),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins-Right',
                      fontSize: 20)))),
    );
  }
}