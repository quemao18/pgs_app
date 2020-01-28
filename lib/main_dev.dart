import 'package:flutter/material.dart';
import 'app.dart';

import 'app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Health DEV',
    flavorName: 'developement',
    apiBaseUrl: 'http://192.168.0.14:5000/api/',
    // apiBaseUrl: 'http://192.168.11.47:5000/api/',
    //  apiBaseUrl: 'http://192.168.43.125:5000/api/',
     
    child: new App(),
  );
  
  runApp(configuredApp);
}