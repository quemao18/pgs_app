import 'package:flutter/material.dart';
import 'package:pgs_contulting/screens/home_material.dart';
import './screens/home.dart';
import 'screens/user_login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call AppConfig.of(context) anywhere to obtain the 
    // environment specific configuration 

    return new MaterialApp(

      routes: <String, WidgetBuilder>{
        // Set routes for using the Navigator.
        '/home': (BuildContext context) => new HomeMaterial(),
        '/login': (BuildContext context) => new LoginPage(),

      },
      //title: config.appName,
      theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark, //#9e946b
          //primaryColor: Colors.brown[200],
          primaryColor:  Color(0xFF9e946b), //Marron Ocre
          accentColor: Color(0xFF423C34), //Marron oscuro
          // primaryColor: Color(0xFF423C34), //Marron oscuro
          // accentColor:  Color(0xFF9e946b), //Marron ocre
          // Define the default font family.
          fontFamily: 'Vaud',

          buttonTheme: ButtonThemeData(
           buttonColor: Color(0xFF9e946b),
           //shape: RoundedRectangleBorder(),
           textTheme: ButtonTextTheme.primary,
          ),
          
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF9e946b),
          ),
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Vaud'),
            body2: TextStyle(color: Color(0xFF9e946b)),
            
          ),
        ),
      home: new HomePage(),
    );
  }
}