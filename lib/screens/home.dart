
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_realistic_forms/app_config.dart';
import 'package:flutter_realistic_forms/screens/home_material.dart';
import 'package:flutter_realistic_forms/screens/list_options.dart';
import 'package:flutter_realistic_forms/screens/user_first.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Inicio", Icons.home),
    new DrawerItem("Registro", Icons.account_box),
    new DrawerItem("Aseguradoras", Icons.list),
    new DrawerItem("¿Quienes somos?", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeMaterial();
      case 1:
        return new UserFirst();
      case 2:
         return new ListPage();
      case 3:
         return _launchURL();

      default:
        return new Text("Error");
    }
  }
  
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _launchURL() async {
  const url = 'https://pgs-consulting.com/somos-pgs/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () {
            if(i==3) _launchURL();
            else
            _onSelectItem(i);
            
          },
        )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        //title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        title: new Text(config.appName),
      ),
      drawer: new Drawer(
  
        child: new Column(
          children: <Widget>[

            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                
                color: Color(0xFF9e946b).withOpacity(0.2),
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(Colors.black87.withOpacity(0.8), BlendMode.dstATop),
                    image: AssetImage("./assets/images/screen2.jpg"),
                    fit: BoxFit.cover,
                    
                  ),
                ),
                
                // currentAccountPicture: Image.network('./assets/images/logo.png'),
                accountName: new Text(config.appName), accountEmail: new Text(config.email)
            
            ),
            new Column(children: drawerOptions),
       
            //padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
            Container(
              padding:new EdgeInsets.only(top: 200.0),
              child: new Align(
                //alignment: Alignment.bottomCenter,
                child: 
                new Text(config.phone,  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12),),
                    ),
                  ),
   
            ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
