import 'package:flutter/material.dart';
import 'package:flutter_realistic_forms/screens/home.dart';

import 'app_config.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call AppConfig.of(context) anywhere to obtain the 
    // environment specific configuration 
    var config = AppConfig.of(context);

    return new MaterialApp(
      title: config.appName,
      theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark, //#9e946b
          //primaryColor: Colors.brown[200],
          primaryColor:  Color(0xFF9e946b),
          //accentColor: Colors.cyan[600],
          
          // Define the default font family.
          fontFamily: 'Montserrat',

          buttonTheme: ButtonThemeData(
           buttonColor: Color(0xFF9e946b),
           //shape: RoundedRectangleBorder(),
           textTheme: ButtonTextTheme.primary,
          ),
          
          
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            body2: TextStyle(color: Color(0xFF9e946b)),
            
          ),
        ),
      home: new HomePage(),
    );
  }
}