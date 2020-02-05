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
    appName: 'PGS Health',
    flavorName: 'production',
    apiBaseUrl: 'https://pgs.nov9m.com:5000/api/',
    child: new App(),
  );

  runApp(configuredApp);
}