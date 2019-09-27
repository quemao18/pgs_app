import 'package:flutter/material.dart';

import 'app.dart';
import 'app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Consulting',
    flavorName: 'production',
    email: 'info@pgs-consulting.com',
    phone: '+584245881728',
    apiBaseUrl: 'https://pgs.nov9m.com/api/',
    child: new App(),
  );

  runApp(configuredApp);
}