
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_contulting/screens/contact_us.dart';
import 'package:pgs_contulting/screens/user_data.dart';
import 'package:pgs_contulting/screens/user_login.dart';
import '../screens/home_material.dart';

import '../screens/user_first.dart';
import 'package:url_launcher/url_launcher.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FacebookLogin _facebookLogin = FacebookLogin();
var data;

bool isLoggedIn = false;
bool isLoading = false;
var profileData;
var userLogged ;
var userData;

class DrawerItem {
  String title;
  IconData icon;
  StatefulWidget page;

  DrawerItem(this.title, this.icon, this.page);

}

class DrawerOnly extends StatefulWidget{
  @override
  _DrawerOnly createState() => _DrawerOnly();

}

@override
class _DrawerOnly extends State<DrawerOnly> {

    @protected
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {

        _getCurrentUser();

    });
  }

  //int _selectedDrawerIndex = 0;
  final drawerItems = [
    new DrawerItem("Inicio", MdiIcons.homeOutline, LoginPage(message: null,)),
    new DrawerItem("¿Quiénes somos?", MdiIcons.accountMultipleOutline, HomeMaterial()),
    new DrawerItem("Nueva cotización", MdiIcons.calendarAccountOutline, UserFirst(userData: null)),
    new DrawerItem("Mis cotizaciones", MdiIcons.clipboardListOutline, UserData()),
    new DrawerItem("Contáctanos", MdiIcons.phoneOutline, ContactUs())

  ];

  final userFb = UserLogged();
  final userGoogle = UserLogged();

  _launchURL(url) async {
  //const url = 'https://pgs-consulting.com/somos-pgs/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// String uid;
// final FirebaseAuth _auth = FirebaseAuth.instance;
//   void userId() async {
//       final FirebaseUser user = await _auth.currentUser();
//       uid = user.uid;
//       // here you write the codes to input the data into firestore
//     }

  Widget build (BuildContext context) {
    // var config = AppConfig.of(context);
    // _getCurrentUser();
    // print(this.userGoogle.photo);
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    var drawerOptions = <Widget>[];
    
          for (var i = 0; i < this.drawerItems.length; i++) {
            var d = this.drawerItems[i];
            drawerOptions.add(
              new ListTile(
                leading: new Icon(d.icon),
                title: new Text(d.title, style: TextStyle(fontSize: 16),),
                // selected: i == _selectedDrawerIndex,
                onTap: () {
                  if(i==1) {
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

                            color: theme.primaryColor.withOpacity(0.2),
        
                              image: DecorationImage(
        
                                colorFilter: new ColorFilter.mode(Colors.black87.withOpacity(0.8), BlendMode.dstATop),
        
                                image: AssetImage("./assets/images/drawer1.jpg"),
                                
                                // image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fdrawer1.jpg?alt=media&token=65290dff-4e1a-45a0-9884-803635dd46ef'),

                                fit: BoxFit.cover,
        
                              ),
            
                            ),
        
                           currentAccountPicture:
                            this.userGoogle.photo != '' || this.userGoogle.photo!=null  ? Container(
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new CachedNetworkImageProvider(this.userGoogle.photo)
                                  )
                              )
                            ):Container(),
                            accountName: new Text(this.userGoogle.name), accountEmail: new Text(this.userGoogle.email)
        
                        ),
        
                        new Column(children: drawerOptions),

                        //padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),

                        // Container(
        
                        //   //padding:new EdgeInsets.only(top: 190.0),
        
                        //   child: new Align(
        
                        //       alignment: Alignment.bottomCenter,
        
                        //       child:
        
                        //           Container(
        
                        //             child:
        
                        //             ListTile(
        
                        //               title: Text('Llámanos'),
        
                        //               leading: Icon(MdiIcons.phoneOutline),
        
                        //               onTap: () => {
                        //                 Navigator.of(context).pop();
                        //                   Navigator.of(context).push(
                        //                       PageRouteBuilder(
                        //                         pageBuilder: (context, _, __) {
                        //                           return d.page;
                        //                         },
                        //                       ),
                        //                     );
                        //               } ,
                        //               // onTap: () => launch('tel://'+config.phone1),
        
                        //             ), 
        
                        //           ),
        
                        //         ),
        
                        //       ),
                          SizedBox(height: screenSize.height>700 ? screenSize.height/4.5 : screenSize.height/12,),
                          Container(
                          // margin: EdgeInsets.only(right: 10,),
                          // padding:new EdgeInsets.only(top: screenSize.height/9),
        
                          child: new Align(
        
                              alignment: Alignment.bottomCenter,
        
                              child:
        
                                  Container(
        
                                    child:
        
                                    ListTile(
        
                                      title: Text('Términos y condiciones de privacidad', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45),),
                                      onTap: () => _launchURL('https://pgs-consulting.firebaseapp.com/#/policity'),
                     
        
                                    ), 
        
                                  ),
        
                                ),
        
                              ),
                          
                          Container(
                          // padding:new EdgeInsets.only(top: 0),  
                          child: 
                          Divider(color: theme.primaryColor,),
                          ),
                          Container(
                          // margin:new EdgeInsets.only(bottom: 10.0),
                          // color: theme.accentColor,
                          child: new Align(
        
                              alignment: Alignment.bottomCenter,
        
                              child:
        
                                  Container(
        
                                    child:
        
                                    ListTile(
        
                                      title: Text('Salir', style: TextStyle(fontSize: 16),),
        
                                      leading: Icon(Icons.exit_to_app),
        
                                      onTap: () => _logout(context),
        
                                    ), 
        
                                  ),
        
                                ),
        
                              ),
               
        
                        ],
        
                    ),
      
          );


  }



  _getCurrentUser() async{
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final FirebaseUser user = await _auth.currentUser();
    // print(user.providerData[1]); 
    setState(() {
      if(user!=null){
        this.userGoogle.name = user.displayName;
        
        if(user.providerData[0]!=null)
        this.userGoogle.email = user.providerData[0].email;
        if(user.providerData[1]!=null)
        this.userGoogle.email = user.providerData[1].email;

        this.userGoogle.photo = user.photoUrl;
        isLoggedIn = true;
      }
      else
      isLoggedIn = false;
    });
    // print(this.userGoogle.email);
    // this.userLogged = this.userGoogle;
    
  }


  _logout(BuildContext context) async {
    print("Logged out");
    _googleSignIn.signOut();
    _facebookLogin.logOut();
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

 
      
}