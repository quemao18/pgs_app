# PGS HEALTH APP

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## pgs_app

`main_prod.dart` is config to server production and  `main_dev.dart` config to local o developement server 

## Build

Remember change version in pubspec.yaml before upload appbludle to play store
`flutter build appbundle -t lib/main_prod.dart --release`
`flutter build apk -t lib/main_prod.dart --release`
`flutter build ios -t lib/main_prod.dart --release` in iOS
