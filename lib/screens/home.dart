
import 'package:flutter/material.dart';
import '../screens/user_login.dart';


class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: LoginPage()
    );
  }
}