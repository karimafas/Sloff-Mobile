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
      child: TheTextfield(
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


class TheTextfield extends StatefulWidget {
  final Widget title;
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool arrow;
  bool active;
  bool ispass;
  TextEditingController controller;

   TheTextfield({
    Key key,
    this.text,
    this.title,
    this.onTap,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.arrow = true,
    this.active= true,
     this.ispass=false,
     this.controller
  }) : super(key: key);
  _TheTextfield createState() => _TheTextfield();
}
class _TheTextfield extends State<TheTextfield>{


  final FocusNode f1 = FocusNode();

  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    Color ilcolor=widget.color;
    return GestureDetector(
      child: Container(
        height: 54,
        margin: EdgeInsets.only(bottom: 18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                  height: 54,
                  child: Image.asset(!widget.active?'assets/images/Accedi/compila_campo.png':'assets/images/Accedi/Campo_di_testo_attivo.png')
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 18.0,),
                  controller: widget.controller,
                  obscureText: widget.ispass?true:false,
                  focusNode: f1,
                decoration: InputDecoration.collapsed(),
              ),)
            ),
          ],
        ),
      ),
    );
  }

}


