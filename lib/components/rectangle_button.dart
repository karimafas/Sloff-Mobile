//import 'package:sloff/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AnimatedRectangleButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedRectangleButton({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedRectangleButtonState createState() => _AnimatedRectangleButtonState();
}

class _AnimatedRectangleButtonState extends State<AnimatedRectangleButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected=Colors.blue;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      //vsync: this,
      duration: const Duration(milliseconds: 200),

    );

    _offsetFloat = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,

      ),
    );

    _offsetFloat.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: RectangleButton(
        color: selected,
        text: widget.text,
        onTap: () async {
          selected = Colors.blue;
          //await _controller.forward();
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.onTap();

            // _controller.animateBack(0);


          });
          //_controller.reverse();
        },
      ),
    );
  }
}

class RectangleButton extends StatelessWidget {
  final Widget title;
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool arrow;
  final bool mini;
  final int type;
  final bool inizia;

  const RectangleButton({
    Key key,
    this.text,
    this.title,
    this.onTap,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.arrow = true,
    this.mini=false,
    this.type =1,
    this.inizia=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ilcolor=this.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        margin: EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 54,
                child: SvgPicture.asset(!this.mini?'assets/images/Accedi/Coupon_Accedi.svg':
                this.type==1?'assets/images/Accedi/Accedi_attivo_Log_In.svg':
                this.type==2?'assets/images/Accedi/Coupon_Accedi_Google.svg':
                this.type==3?'assets/images/Home/Stop.svg':
                this.type==4?'assets/images/Home/Inizia_Attivo.svg':
                this.type==5?'assets/images/Home/Inizia.svg':
                this.type==6?'assets/images/Accedi/Registrati.svg':'')
              ),
            ),
            Positioned(
                left: -230,
                right: 0,
                child:
                    this.type==2?Container(
                        margin:EdgeInsets.symmetric(horizontal: 5),
                        child:Image.asset('assets/images/google.png')):Container()
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  this.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: this.type==2?Colors.black:Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],)
            ),
          ],
        ),
      ),
    );
  }

  factory RectangleButton.dark({
    text = 'Færdig',
    title,
    onTap,
    color = Colors.blue,
    textColor = Colors.white,
    arrow = false,
  }) {
    return RectangleButton(
      text: text,
      title: title,
      onTap: onTap,
      color: color,
      textColor: textColor,
      arrow: arrow,
    );
  }


}


