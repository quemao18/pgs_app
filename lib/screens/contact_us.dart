
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;

var data2 ;
final FirebaseAuth _auth = FirebaseAuth.instance;
var children = <Widget>[];
// var userLogged;

class ContactUs extends StatefulWidget {
//  final userLogged;
//   UserData({Key key, this.userLogged}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ContactUs();
  }
}

class _ContactUs extends State<ContactUs> {
  bool isLoadding = false;
  bool existUser = true;
  static String defaultMessage = "Información";
  bool existWhatsapp = false;
  @protected
  initState(){
    super.initState();
    // _getCurrentUser();
  Future.delayed(const Duration(milliseconds: 100), () {
    setState(() { 
     data2 = _getUserApi(context);
    });
  });

  }
  @override
  Widget build(BuildContext context){

    // this.data.then((val) {
    //   data = val;
    // });
    // data = widget.userLogged;
    // print(data);
    final ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    var config = AppConfig.of(context);
    // print(data['plans']);
    return new Scaffold(
        appBar: new AppBar(
        title: new Text(config.appName),
      ),
      drawer: DrawerOnly(), 
      body: 
      SingleChildScrollView(child: 
      Stack(
        children: <Widget>[
          // _buildCoverImage(screenSize),
          // _buildTitle(context, theme),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: data2,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //return Text(snapshot.data['name']);
                        // print(snapshot.data);
                        children = <Widget> [];
                        // children.add(Padding(padding: EdgeInsets.only(top:screenSize.height/10),));
                        children.add(buildHeader(context, config.appName, theme, screenSize));
                        children.add(buildInformation(config.phone1,config.phone2, config.email, config.appName, theme));

                        return Column(children: children);

                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return  Center(
                        child:Container(
                          padding: EdgeInsets.only(top: screenSize.height/3, left: screenSize.width/40),
                          child: LoadingBouncingGrid.square(
                            borderColor: theme.primaryColor,
                            borderSize: 1.0,
                            size: 70.0,
                            backgroundColor: Colors.transparent,
                            )
                            ),
                            );
                    },
                  )
                  ,

                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  
  }//WIdget main

  /*Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 6,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black87.withOpacity(0.8), BlendMode.dstATop),
          image: AssetImage('./assets/images/drawer1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage(photo) {
    return Center(
      child: Container(
        width: 120.0,
        height: 120.0,
        
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new CachedNetworkImageProvider(photo),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(60.0),
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          ),
        ),
      ),
    );
  }*/


  // Widget _buildFullName(name) {

  //   TextStyle _nameTextStyle = TextStyle(
  //     // fontFamily: 'Roboto',
  //     color: Colors.black87,
  //     fontSize: 18.0,
  //     height: 1.3,
  //     fontWeight: FontWeight.w600,
  //   );

  //   return Text(
  //     name,
  //     style: _nameTextStyle,
  //   );
  // }

  // Widget _buildTitle(BuildContext context, theme) {
  //   return Container(
  //           padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
  //           child: Column(
  //             children: <Widget>[
  //             ListTile(
  //               title: Text('Contacto', 
  //               style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20, height: 1.3),
  //               textAlign: TextAlign.center,
  //               ),
  //               subtitle: Text('No dudes en llamarnos o escribirnos.', 
  //               style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
  //               textAlign: TextAlign.center,
  //               ),
  //               ),
  //           ],
  //           ),
            
  //         );
  // }


  void whatsAppOpen(phoneNumber, message) async {
    // await FlutterLaunch.launchWathsApp(phone: phoneNumber, message: message);
  }

  _textMe(String number) async {
    // Android
    String uri = "sms:$number";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = "sms:$number";
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  _launchCaller(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

    _launchMail(String mail) async {
    String url = "mailto:$mail";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Container buildHeader(BuildContext context, String name, theme, screenSize) {
    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          SizedBox(height: 20),
           Container( 
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: 
            Image( 
                  color: Colors.white70.withOpacity(0.8),
                  image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                  width: (screenSize.width < 500)
                      ? 150.0
                      : (screenSize.width / 4) + 12.0,
                  height: screenSize.height / 6 + 0,
                )
          ),
          // Icon(
          //   Icons.person,
          //   color: Colors.white,
          //   size: 160,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white70, fontSize: 27),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildInformation(phoneNumber1, phoneNumber2, email, nome, theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
          onTap: () { _launchCaller(phoneNumber1); },
          child:
          Card(
            child: ListTile(
              title: Text(phoneNumber1.toString().isNotEmpty
                  ? phoneNumber1
                  : defaultMessage),
              subtitle: Text(
                "Teléfono móvil",
                style: TextStyle(color: Colors.black54),
              ),
              leading: IconButton(
                icon: Icon(Icons.phone, color: theme.primaryColor),
                onPressed: () {
                  _launchCaller(phoneNumber1);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  _textMe(phoneNumber1);
                },
              ),
            ),
          ),
          ),
          GestureDetector(onTap: () { _launchCaller(phoneNumber2); },
          child:
          Card(
            child: ListTile(
              title: Text(phoneNumber2.toString().isNotEmpty
                  ? phoneNumber2
                  : defaultMessage),
              subtitle: Text(
                "Teléfono de oficina",
                style: TextStyle(color: Colors.black54),
              ),
              leading: IconButton(
                icon: Icon(MdiIcons.phoneClassic, color: theme.primaryColor),
                onPressed: () {
                  _launchCaller(phoneNumber2);
                },
              ),
              // trailing: IconButton(
              //   icon: Icon(Icons.message),
              //   onPressed: () {
              //     _textMe(phoneNumber2);
              //   },
              // ),
            ),
          ),
          ),
          GestureDetector(
          onTap: () {  _launchMail(email); },
          child:
          Card(
            child: ListTile(
              title: Text(email.toString().isNotEmpty ? email : defaultMessage),
              subtitle: Text(
                "E-mail",
                style: TextStyle(color: Colors.black54),
              ),
              leading: IconButton(
                  icon: Icon(Icons.email, color: theme.primaryColor),
                  onPressed: () {
                    _launchMail(email);
                  }),
            ),
          ),
          ),
          GestureDetector(
          onTap: () { Share.share("""Nombre: $nome\nTel 1: $phoneNumber1\nTel 2: $phoneNumber2\nEmail: $email"""); },
          child:
          Card(
            child: ListTile(
              title: Text(
                "Enviar contacto",
              ),
              subtitle: Text(
                "Compartir",
                style: TextStyle(color: Colors.black54),
              ),
              leading: IconButton(
                  icon: Icon(Icons.share, color: theme.primaryColor),
                  onPressed: () {
                    Share.share("""Nombre: $nome\nTel 1: $phoneNumber1\nTel 2: $phoneNumber2\nEmail: $email""");
                  }),
            ),
          )
          ),
          Card(
            child: existWhatsapp
                ? ListTile(
                    title: Text(
                      "Abrir en Whatsapp",
                    ),
                    subtitle: Text(
                      "Whatsapp",
                      style: TextStyle(color: Colors.black54),
                    ),
                    leading: IconButton(
                        icon: Icon(MdiIcons.whatsapp,
                            color: theme.primaryColor),
                        onPressed: () {
                          whatsAppOpen(phoneNumber1.toString(), "");
                        }),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  // Widget _buildSeparator(Size screenSize, theme) {
  //   return Container(
  //     width: screenSize.width / 1.6,
  //     height: 2.0,
  //     color: theme.accentColor,
  //     margin: EdgeInsets.only(top: 4.0, bottom: 10),
  //   );
  // }

    _getUserApi(BuildContext context) async{
      try{
      final FirebaseUser user = await _auth.currentUser();
      setState(() {
      isLoading = true;  
      });

      String email='';
      if(user.providerData[0]!=null)
      email = user.providerData[0].email;
      if(user.providerData[1]!=null)
      email = user.providerData[1].email;

      var res2;
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/account/'+email+'/email_logged'), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);

        // print(resBody[0]);

        if (res.statusCode == 200) { 
          
          if(resBody[0]==null) {
          setState(() {
           this.existUser = false; 
          });
          res2 = null;
          }
          else
          if(resBody.length>0){
          res2 = resBody;
          setState(() {
            this.existUser = true;
          });
          
          }
          
        }else{
          res2 = null;
        }
        return res2;
      }catch(_){
        print('error in contact us');
        
           setState(() {
          isLoading = false;  
          });
        return null;
      }

  }
  


}
