import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AnimatedTextBox extends StatelessWidget {
  const AnimatedTextBox({
    Key key,
    @required bool emailTapped,
    @required TextEditingController emailController,
    this.onTap,
    this.email,
    this.onSubmit,
    this.validator,
    this.errorText,
    this.onChanged,
    this.backgroundColor,
    this.textColor,
    this.keyboard,
    this.done,
    this.autofocus,
  })  : _emailTapped = emailTapped,
        _emailController = emailController,
        super(key: key);

  final bool _emailTapped;
  final TextEditingController _emailController;
  final Function onTap;
  final bool email;
  final Function onSubmit;
  final bool validator;
  final String errorText;
  final Function onChanged;
  final Color backgroundColor;
  final Color textColor;
  final keyboard;
  final bool done;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: 54,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: backgroundColor == null
                          ? _emailTapped && !validator
                              ? Border.all(
                                  color: new Color(0xFF694EFF), width: 2)
                              : _emailTapped && validator
                                  ? Border.all(color: Colors.red, width: 2)
                                  : Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.transparent),
                      color: backgroundColor == null
                          ? _emailTapped
                              ? Colors.transparent
                              : new Color(0xFFFFDFAD)
                          : backgroundColor,
                      borderRadius: BorderRadius.circular(4)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    autocorrect: false,
                      autofocus: autofocus == null ? false : true,
                      onChanged: onChanged,
                      onFieldSubmitted: onSubmit,
                      onTap: onTap,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      cursorColor: new Color(0xFF694EFF),
                      style: TextStyle(
                          color: textColor == null
                              ? new Color(0xFF190E3B)
                              : textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      controller: _emailController,
                      decoration: InputDecoration.collapsed(),
                      textInputAction: done == null
                          ? email
                              ? TextInputAction.next
                              : TextInputAction.go
                          : done == false
                              ? TextInputAction.next
                              : TextInputAction.go,
                      keyboardType: keyboard == null
                          ? email
                              ? TextInputType.emailAddress
                              : null
                          : null,
                      obscureText: email ? false : true,
                      textCapitalization: keyboard == null
                          ? TextCapitalization.none
                          : TextCapitalization.sentences),
                ),
                Positioned(
                  right: 5,
                  child: Visibility(
                    visible: _emailTapped ? true : false,
                    child: IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onPressed: () {
                        _emailController.clear();
                      },
                      icon: Icon(Icons.close_rounded, size: 20, color: new Color(0xFF190E3B)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: !validator ? 0 : 1,
                    child: Text(errorText,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.red,
                            fontFamily: 'Poppins-Regular'))),
              ],
            )
          ],
        ));
  }
}
