import 'package:flutter/material.dart';
import 'app.dart';

import 'app_config.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  var configuredApp = new AppConfig(
    appName: 'PGS Health DEV',
    flavorName: 'developement',
    // apiBaseUrl: 'http://192.168.0.14:5000/api/',
    apiBaseUrl: 'http://192.168.1.47:5000/api/',
    //  apiBaseUrl: 'http://192.168.8.102:5000/api/',
     
    child: new App(),
  );
  
  runApp(configuredApp);
}