
import 'package:flutter/material.dart';
import 'package:flutter_realistic_forms/screens/home_material.dart';
import 'package:flutter_realistic_forms/screens/list_options.dart';
import 'package:flutter_realistic_forms/screens/user_first.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';

class DrawerItem {
  String title;
  IconData icon;
  StatefulWidget page;
  DrawerItem(this.title, this.icon, this.page);

}

@override
class DrawerOnly extends StatelessWidget  {

  //int _selectedDrawerIndex = 0;

    final drawerItems = [
    new DrawerItem("Inicio", Icons.home, HomeMaterial()),
    new DrawerItem("Cotizar", Icons.account_box, UserFirst()),
    new DrawerItem("Aseguradoras", Icons.list, ListPage()),
    new DrawerItem("¿Quienes somos?", Icons.info, HomeMaterial())
  ];

  _launchURL(url) async {
  //const url = 'https://pgs-consulting.com/somos-pgs/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}



  Widget build (BuildContext context) {
    var config = AppConfig.of(context);
      
          var drawerOptions = <Widget>[];
          for (var i = 0; i < this.drawerItems.length; i++) {
            var d = this.drawerItems[i];
            drawerOptions.add(
              new ListTile(
                leading: new Icon(d.icon),
                title: new Text(d.title),
                //selected: i == _selectedDrawerIndex,
                onTap: () {
                  if(i==3) {
                    _launchURL('https://pgs-consulting.com/somos-pgs/');
                    }
                  else{
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
                          return d.page;
                        },
                      ),
                    );
                  }
                  
                },
              )
            );
          }
      
          return 
      
          Drawer(
              
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
        
                          padding:new EdgeInsets.only(top: 190.0),
        
                          child: new Align(
        
                              alignment: Alignment.bottomCenter,
        
                              child:
        
                                  Container(
        
                                    child:
        
                                    ListTile(
        
                                      title: Text('¿Tienes una emergencia?'),
        
                                      leading: Icon(Icons.healing),
        
                                      onTap: () => launch('tel://'+config.phone1),
        
                                    ), 
        
                                  ),
        
                                ),
        
                              ),
        
               
        
                        ],
        
                    ),
      
          );
        }
      
        void setState(int Function() param0) {}
}