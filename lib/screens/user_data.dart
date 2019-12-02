
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_contulting/components/Buttons/roundedButton.dart';
import 'package:pgs_contulting/screens/user_login.dart';

import '../app_config.dart';
import 'detail_page.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;

var data2;
final FirebaseAuth _auth = FirebaseAuth.instance;
var children = <Widget>[];
// var userLogged;

class UserData extends StatefulWidget {
//  final userLogged;
//   UserData({Key key, this.userLogged}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new UserDataState();
  }
}

class UserDataState extends State<UserData> {
  // final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  bool isLoadding = false;
  bool existUser = true;
  @protected
  initState(){
    super.initState();
    // _getCurrentUser();
  data2 = null;
  Future.delayed(const Duration(milliseconds: 1000), () {
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
          _buildTitle(context, theme),
          SafeArea(
            child: SingleChildScrollView(
              child: this.existUser == true ? Column(
                children: <Widget>[
                  FutureBuilder(
                    future: data2,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //return Text(snapshot.data['name']);
                        // print(snapshot.data);
                        children = <Widget> [];
                        children.add(Padding(padding: EdgeInsets.only(top:screenSize.height/12),));
                        for(var data in snapshot.data){
                        // print(data);
                        // children.add(SizedBox(height: screenSize.height / 6.4));
                        // children.add(_buildProfileImage(data['photo_logged']));
                        children.add(_makeCard(data, theme));
                        // children.add(_buildExpansion(data, theme));
                        // children.add(_buildFullName(data['name']));
                        // children.add(_buildAge(context, data['age'].toString() + ' años', theme));
                        // children.add(_buildSeparator(screenSize, theme));
                        // children.add(_builPlans(context, data['plans'], theme));

                        }
                        

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
              ):
              Container(
                padding: EdgeInsets.only(top:200),
                child: 
                Column(children: <Widget>[
                  ListTile(
                        title: Text( 'No tienes ninguna contización realizada.', 
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                        textAlign: TextAlign.center,
                        ),
                        subtitle: Text('\nIntenta realizar una cotización\n', style: TextStyle(color: Colors.black45, fontSize: 15, height: 1.3),
                        textAlign: TextAlign.center,
                        ),
                        ),
                        RoundedButton(
                        buttonName: "Volver",
                        onTap:  () {
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(message: null,)
                                    ),
                            );
                        },
                            width: screenSize.width/2,
                            height: 50.0,
                            bottomMargin: 10.0,
                            borderWidth: 1.0,
                            buttonColor: theme.primaryColor,
                        )  
                ],)
              )
            ),
          ),
        ],
      ),
      ),
    );
  
  }//WIdget main


        Widget _makeCard(data, theme){

        return  Card(
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
              // color: Color.fromRGBO(64, 75, 96, .9),
              border: Border.all(color: theme.primaryColor),
              borderRadius: BorderRadius.circular(10.0),
              ),
              child: _makeListTile(data, theme),
            ),
          );

        }

       Widget _makeListTile(data, theme) {
        String age = data['age'].toString() + ' años. ';
        String spouse = data['spouse_age']!=null && data['spouse_age']>0 ? ' Conyugue: '+ data['spouse_age'].toString() + ' años. ': '';
        String dependents = data['dependents']!=null && data['dependents']>0 ? ' '+ data['dependents'].toString() + ' dependiente(s).': '';
 
        return  
        Container(
        height: 80,
        child:
        ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: theme.accentColor))),
          child: Icon(data['gender'] == 'male' ?  MdiIcons.humanMale:MdiIcons.humanFemale, color: theme.accentColor, size:35,),
        ),
        title: 
        Container(
        padding: EdgeInsets.only(top:10),
        child:
        Text(
          (data['name']),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ),
        // subtitle: Text(age + spouse + dependents,),

        subtitle: Container(
          padding: EdgeInsets.only(top: 5),
          child:
            // Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Text(age + spouse + dependents, style: TextStyle(height: 1.2))

        ),
        trailing:
          Icon(Icons.keyboard_arrow_right, size: 30.0, color: theme.accentColor,),

        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DetailPage(data: data)));
        },
        )
      );
      }

  Widget _buildTitle(BuildContext context, theme) {
    return Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Column(
              children: <Widget>[
              ListTile(
                title: Text('Mis Cotizaciones', 
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20, height: 1.3),
                textAlign: TextAlign.center,
                ),
                // subtitle: Text('Últimas 3 cotizaciones realizadas por usuario.', 
                // style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                // textAlign: TextAlign.center,
                // ),
                ),
            ],
            ),
            
          );
  }

  //   _showDialog2(text, tempo){
  // _scaffoldstate.currentState.showSnackBar(
  //   new SnackBar(
  //       duration: new Duration(seconds: tempo),
  //       content: new Text(text),
  //     )
  //     );
  // }

    _getUserApi(BuildContext context) async{
      final FirebaseUser user = await _auth.currentUser();
      setState(() {
      isLoading = true;  
      });
      try{

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
        print('error');
        // _showDialog2('Error de conexión', 3);

      }

  }
  


}
