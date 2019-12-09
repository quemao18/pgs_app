import 'package:flutter/material.dart';

import 'app.dart';
import 'app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Health',
    flavorName: 'production',
    apiBaseUrl: 'https://pgs.nov9m.com:5000/api/',
    child: new App(),
  );

  runApp(configuredApp);
}