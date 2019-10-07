import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  IconData iconSuf;
  String hintText;
  TextInputType keyboardType;
  Color textFieldColor, iconColor, iconColorSuf;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validator;
  var onSaved;
  var controller;
  var onChanged;
  var onPressedSuf;
  bool autovalidate = false;
  Key key;
  bool enabled;

  //passing props in the Constructor.
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.keyboardType,
      this.textFieldColor,
      this.icon,
      this.iconSuf,
      this.iconColorSuf,
      this.onPressedSuf,
      this.autovalidate,
      this.onChanged,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.enabled,
      this.validator,
      this.onSaved,
      this.controller,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
          child: new TextFormField(
            
            // style: textStyle,
            controller: controller,
            key: key,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onSaved: onSaved,
            enabled: enabled,
            onChanged: onChanged,
            autovalidate: autovalidate,
            
            // decoration: new InputDecoration(
            //   hintText: hintText,
            //   hintStyle: hintStyle,
            //   icon: new Icon(
            //     icon,
            //     color: iconColor,
            //   ),
            // ),
            decoration: new InputDecoration(
            //contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            labelText: hintText,
            hintStyle: hintStyle,
            prefixIcon: new Icon(
                icon,
                color: iconColor,
              ),
            suffixIcon: new IconButton(
              onPressed: onPressedSuf, 
              icon: Icon(
                iconSuf,
                color: iconColorSuf,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9e946b),),
              borderRadius: BorderRadius.circular(30),
             ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color(0xFF9e946b),),
              borderRadius: BorderRadius.circular(30),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
),
          ),
        )
    );
  }
}
