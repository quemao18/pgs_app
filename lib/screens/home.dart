
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import '../screens/user_login.dart';
import "dart:ui" as ui;

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) changeStatusBar();
    Size s = ui.window.physicalSize/ui.window.devicePixelRatio;
    bool landscape = s.width>s.height;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (landscape) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return new Scaffold(
      body: LoginPage(message: null,)
    );
  }

    changeStatusBar() async{
    // Color statusbarColor = await FlutterStatusbarcolor.getStatusBarColor();
    // print(statusbarColor);
    // change the status bar color to material color [green-400]
      await FlutterStatusbarcolor.setStatusBarColor(Color(0xFF9e946b));
      if (useWhiteForeground(Color(0xFF9e946b))) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      }
  }

}
