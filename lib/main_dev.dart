import 'package:flutter/material.dart';
import 'app.dart';

import 'app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Consulting DEV',
    flavorName: 'developement',
    email: 'info@pgs-consulting.com',
    phone: '+584245881728 / :+582512547777',
    apiBaseUrl: 'http://192.168.0.5:5000/api/',
    child: new App(),
  );
  
  runApp(configuredApp);
}