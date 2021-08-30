import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AniPropsRect { height }
enum AniPropsCircle { height }

class OnboardingBackground extends StatefulWidget {
  final int state;

  const OnboardingBackground({Key key, this.state}) : super(key: key);

  @override
  _OnboardingBackgroundState createState() => _OnboardingBackgroundState();
}

double width = 100;
double height = 100;
double position = 100;

class _OnboardingBackgroundState extends State<OnboardingBackground> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OnboardingBackground oldWidget) {
    position = MediaQuery.of(context).size.height * 0.3;

    super.didUpdateWidget(oldWidget);

    Future.delayed(Duration(milliseconds: 1300), () {
      if (widget.state == 2) {
        setState(() {
          print("DONE");
          width = 240;
          height = 240;
          position = MediaQuery.of(context).size.height * 0.22;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .6,
      child: Transform.scale(
        scale: 1.7,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              AnimatedPositioned(
                left: widget.state < 3 ? 0 : MediaQuery.of(context).size.width * 0.4,
                duration: Duration(milliseconds: 900),
                curve: Curves.easeInOutQuart,
                child: Column(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 900),
                        curve: Curves.easeInOutQuart,
                        height: widget.state == 0
                            ? MediaQuery.of(context).size.height * 0.52
                            : widget.state == 1
                                ? MediaQuery.of(context).size.height * 0.44
                                : widget.state == 2
                                    ? MediaQuery.of(context).size.height * 0.2
                                    : widget.state == 3
                                        ? MediaQuery.of(context).size.height *
                                            0.18
                                        : 0,
                        width: 230),
                    SvgPicture.asset('assets/images/Home/violet_blurred.svg',
                        fit: BoxFit.contain, width: 190),
                  ],
                ),
              ),
              AnimatedPositioned(
                left: widget.state < 3 ? MediaQuery.of(context).size.width * 0.6 : 0,
                duration: Duration(milliseconds: 900),
                curve: Curves.easeInOutQuart,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 900),
                        curve: Curves.easeInOutQuart,
                        height: widget.state == 0
                            ? MediaQuery.of(context).size.height * 0.3
                            : widget.state == 1
                                ? MediaQuery.of(context).size.height * 0.22
                                : widget.state == 2
                                    ? MediaQuery.of(context).size.height * 0.4
                                    : widget.state == 3
                                        ? MediaQuery.of(context).size.height * 0.5
                                        : 0,
                        width: 150),
                    SvgPicture.asset('assets/images/Home/orange_blurred.svg',
                        fit: BoxFit.contain, width: 150),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: widget.state == 2 ? .25 : 0,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOutQuart,
                child: Column(
                  children: [
                    AnimatedContainer(
                        height: position,
                        duration: Duration(milliseconds: 2000),
                        curve: Curves.easeInOutQuart),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.easeInOutQuart,
                      height: width,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.cyan),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
