import 'package:flutter/material.dart';

import 'app.dart';
import 'app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Consulting',
    flavorName: 'production',
    email: 'servicioalcliente@pgs-consulting.com',
    phone1: '+584245881728',
    phone2: '+582512547777',
    apiBaseUrl: 'https://pgs.nov9m.com/api/',
    child: new App(),
  );

  runApp(configuredApp);
}