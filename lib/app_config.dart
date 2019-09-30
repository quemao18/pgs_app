import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.appName,
    @required this.flavorName,
    @required this.apiBaseUrl,
    @required this.phone1,
    @required this.phone2,
    @required this.email,
    @required Widget child,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final String apiBaseUrl;
  final String phone1;
  final String phone2;
  final String email;
  

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}