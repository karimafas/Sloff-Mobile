import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniPropsRect { height }
enum AniPropsCircle { height }

class AnimatedBackground extends StatefulWidget {
  final int duration;
  final int halfDuration;
  final bool animate;

  const AnimatedBackground({Key key, this.duration, this.animate, this.halfDuration}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _tweenRect = TimelineTween<AniPropsRect>()
      ..addScene(begin: Duration(seconds: 0), duration: Duration(seconds: widget.halfDuration))
          .animate(AniPropsRect.height,
          tween: Tween(
              begin: MediaQuery.of(context).size.height * 0.52,
              end: MediaQuery.of(context).size.height * 0.2))
      ..addScene(begin: Duration(seconds: widget.halfDuration), end: Duration(seconds: widget.duration))
          .animate(AniPropsRect.height,
          tween: Tween(
              begin: MediaQuery.of(context).size.height * 0.2,
              end: MediaQuery.of(context).size.height * 0.52));

    final _tweenCircle = TimelineTween<AniPropsCircle>()
      ..addScene(begin: Duration(seconds: 0), duration: Duration(seconds: widget.halfDuration))
          .animate(AniPropsCircle.height,
          tween: Tween(
              begin: MediaQuery.of(context).size.height * 0.2,
              end: MediaQuery.of(context).size.height * 0.52))
      ..addScene(begin: Duration(seconds: widget.halfDuration), end: Duration(seconds: widget.duration))
          .animate(AniPropsCircle.height,
          tween: Tween(
              begin: MediaQuery.of(context).size.height * 0.52,
              end: MediaQuery.of(context).size.height * 0.2));

    return Opacity(
      opacity: .6,
      child: Transform.scale(
        scale: 1.7,
        child: Container(
          color: new Color(0xFFFFF8ED),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  widget.animate
                      ? PlayAnimation<TimelineValue<AniPropsRect>>(
                    tween: _tweenRect,
                    duration: _tweenRect.duration,
                    builder: (context, child, value) {
                      return Container(
                          height: (value.get(AniPropsRect.height)).toDouble(),
                          width: 180);
                    },
                  )
                      : Container(
                      height: MediaQuery.of(context).size.height * 0.52,
                      width: 180),
                  SvgPicture.asset('assets/images/Home/violet_blurred.svg',
                      fit: BoxFit.contain, width: 180),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.animate
                      ? PlayAnimation<TimelineValue<AniPropsCircle>>(
                    tween: _tweenCircle,
                    duration: _tweenCircle.duration,
                    builder: (context, child, value) {
                      return Container(
                          height: (value.get(AniPropsCircle.height)).toDouble(),
                          width: 150);
                    },
                  )
                      : Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: 150),
                  SvgPicture.asset('assets/images/Home/orange_blurred.svg',
                      fit: BoxFit.contain, width: 150),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
