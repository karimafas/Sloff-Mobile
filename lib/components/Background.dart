import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AniPropsRect { height }
enum AniPropsCircle { height }

class Background extends StatelessWidget {
  final int page;

  const Background({Key key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .6,
      child: Transform.scale(
        scale: 2.3,
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      height: page == null
                          ? MediaQuery.of(context).size.height * 0.52
                          : page == 1
                              ? MediaQuery.of(context).size.height * 0.3
                              : 0,
                      width: 180),
                  SvgPicture.asset('assets/images/Home/violet_blurred.svg',
                      fit: BoxFit.contain, width: 180),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: page == null
                          ? MediaQuery.of(context).size.height * 0.2
                          : page == 1
                              ? MediaQuery.of(context).size.height * 0.55
                              : 0,
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
