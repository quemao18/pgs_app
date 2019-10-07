
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pgs_contulting/screens/user_login.dart';
import '../screens/home_material.dart';
import '../screens/list_options.dart';
import '../screens/user_first.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


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
    new DrawerItem("Inicio", Icons.home, LoginPage()),
    new DrawerItem("Cotizar", Icons.account_box, UserFirst(userData: null)),
    //new DrawerItem("Aseguradoras", Icons.list, ListPage()),
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

String uid;
final FirebaseAuth _auth = FirebaseAuth.instance;
void userId() async {
    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid;
    // here you write the codes to input the data into firestore
  }

  Widget build (BuildContext context) {
    var config = AppConfig.of(context);
        print(uid);
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
        
                          //padding:new EdgeInsets.only(top: 190.0),
        
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
      
}