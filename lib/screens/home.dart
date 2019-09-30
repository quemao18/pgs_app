
import 'package:flutter/material.dart';
import 'package:flutter_realistic_forms/screens/home_material.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Inicio", Icons.home),
    new DrawerItem("Cotizar", Icons.account_box),
    new DrawerItem("Aseguradoras", Icons.list),
    new DrawerItem("¿Quienes somos?", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: HomeMaterial()
    );
  }
}
