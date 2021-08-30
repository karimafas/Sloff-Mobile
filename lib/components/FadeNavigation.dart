import 'package:flutter/material.dart';

void pushWithFade(BuildContext context, Widget widget, int duration) {
  Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, anotherAnimation) {
        return widget;
      },
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation =
            CurvedAnimation(curve: Curves.easeOutQuad, parent: animation);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }));
}

void pushReplacementWithFade(BuildContext context, Widget widget, int duration) {
  Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, anotherAnimation) {
        return widget;
      },
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation =
            CurvedAnimation(curve: Curves.easeOutQuad, parent: animation);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }));
}