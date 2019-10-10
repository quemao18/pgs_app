import 'package:flutter/material.dart';
import 'app.dart';

import 'app_config.dart';
//192.168.11.47 

void main() {
  var configuredApp = new AppConfig(
    appName: 'PGS Consulting DEV',
    flavorName: 'developement',
    email: 'servicioalcliente@pgs-consulting.com',
    phone1: '+584245881728',
    phone2: '+582512547777',
    apiBaseUrl: 'http://192.168.0.5:5000/api/',
    child: new App(),
  );
  
  runApp(configuredApp);
}