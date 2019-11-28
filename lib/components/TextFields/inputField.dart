import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final IconData iconSuf;
  final String hintText;
  final TextInputType keyboardType;
  final Color textFieldColor, iconColor, iconColorSuf;
  final bool obscureText;
  final double bottomMargin;
  final TextStyle textStyle, hintStyle;
  final validator;
  final onSaved;
  final controller;
  final onChanged;
  final onPressedSuf;
  final bool autovalidate;
  final Key key;
  final bool enabled;
  final bool textCapitalization;

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
      this.hintStyle, 
      this.textCapitalization=false});

  @override
  Widget build(BuildContext context) {
  final ThemeData theme = Theme.of(context);

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
            textCapitalization: textCapitalization ? TextCapitalization.sentences: TextCapitalization.none,
            
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
              borderSide: BorderSide(color: theme.primaryColor,),
              borderRadius: BorderRadius.circular(30),
             ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor,),
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
