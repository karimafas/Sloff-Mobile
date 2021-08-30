import 'package:flutter/material.dart';

class AnimatedRectangleButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedRectangleButton({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedRectangleButtonState createState() =>
      _AnimatedRectangleButtonState();
}

class _AnimatedRectangleButtonState extends State<AnimatedRectangleButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  Color selected = Colors.blue;

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
  final double width;

  const RectangleButton(
      {Key key,
      this.text,
      this.title,
      this.onTap,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.arrow = true,
      this.mini = false,
      this.type = 1,
      this.inizia = false, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ilcolor = this.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 55,
        width: width == null ? 240: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: Center(
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              color: textColor == null ? Colors.white : textColor,
              fontSize: 15,
            ),
          ),
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
