
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pgs_contulting/components/Buttons/roundedButton.dart';
import 'package:pgs_contulting/screens/user_login.dart';

import '../app_config.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;

var data2 ;
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
  bool isLoadding = false;
  bool existUser = true;
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

                        for(var data in snapshot.data){
                        // print(data);
                        children.add(SizedBox(height: screenSize.height / 26.4));
                        // children.add(_buildProfileImage(data['photo_logged']));
                        children.add(_buildFullName(data['name']));
                        children.add(_buildAge(context, data['age'].toString() + ' años', theme));
                        children.add(_buildSeparator(screenSize, theme));
                        children.add(_builPlans(context, data['plans'], theme));

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

                  // _buildProfileImage(data['photo']),
                  // _buildFullName(data['name']),
                  // _buildAge(context, data['age'].toString() + ' años', theme),
                  // _buildSeparator(screenSize, theme),
                  // _builPlans(context, data['plans'], theme),
                  // _buildStatContainer(),
                  // _buildBio(context),

                  // SizedBox(height: 10.0),
                  // _buildGetInTouch(context),
                  // SizedBox(height: 8.0),
                  // _buildButtons(),
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

  Widget _buildFullName(name) {

    TextStyle _nameTextStyle = TextStyle(
      // fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 20.0,
      height: 1.2,
      fontWeight: FontWeight.w700,
    );

    return Text(
      name,
      style: _nameTextStyle,
    );
  }

  Widget _buildAge(BuildContext context, age, theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        // color: theme.primaryColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        age,
        style: TextStyle(
          // fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _builPlans(context, plans, theme) {
  var children = <Widget>[];
  var childrenRev = <Widget>[];
  // print(plans);
  final formatter = NumberFormat("#,###.##");
  String priceUser = '';
  String priceSpouse = '';
  String priceDependents = '';
  String deductible = '';
  String transplant = '';
  String maternity = '';
  String costAdmin = '';
  double total = 0.0;
  for(var plan in plans){
  // print(plan['option_prices']);
  total = 0.0; priceUser = ''; priceSpouse = ''; priceDependents = ''; deductible = ''; transplant = ''; maternity =''; costAdmin='';
    // print(plan)
  if(plan['option_prices'].length>0)
  priceUser = plan['option_prices'][0]!=null ? 'Precio USD ' + formatter.format(plan['option_prices'][0]).toString():'';
  if(plan['option_prices'].length>1)
  priceSpouse = plan['option_prices'][1]!=null ? 'Precio Conyugue USD ' + formatter.format(plan['option_prices'][1]).toString():'';
  if(plan['option_prices'].length>2)
  priceDependents = plan['option_prices'][2]!=null ? 'Precio Dependientes USD ' + formatter.format(plan['option_prices'][2]).toString():'';

  deductible = plan ['deductible']!=null ? 'Deducible USD ' + formatter.format(plan['deductible']) : ''; 
  maternity = plan ['maternity']!=null && plan['maternity'] >0 ? 'Complicaciones por maternidad USD ' + formatter.format(plan['maternity']) : '';
  transplant = plan ['transplant']!=null && plan ['transplant'] >0 ? 'Transplante de organos USD ' + formatter.format(plan['transplant']) : ''; 
  costAdmin = plan ['cost_admin']!=null && plan ['cost_admin'] >0 ? 'Costos administrativos USD ' + formatter.format(plan['cost_admin']) : '';


  if(plan['option_prices'].length>0)
    for(var price in plan['option_prices']) 
      total += price;
  
  total = total + plan['maternity'] + plan['transplant'] + plan['cost_admin'];
  // print(total);
  // if(plan['option_prices'].length>0)
    children.add(
      Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.primaryColor)
        ),
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),  
        child: 
        ExpansionTile(
        title: 
        ListTile(

          trailing: Text('USD '+formatter.format(total).toString(), style: TextStyle(fontWeight: FontWeight.bold),) ,
          
          leading:    
          Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          child: 
          CachedNetworkImage(
              height: 50, width: 60,
              imageUrl: plan['company_logo'],
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.image),
          ),
          ),
          title:Text(plan['company_name'],
            style: TextStyle(fontWeight: FontWeight.bold)
            ), 
            subtitle: Text(plan['plan_name'],
            style: TextStyle(height: 1.5)
            ),
            ),
            children: <Widget>[
             
            Container(
              margin: EdgeInsets.all(10),
              child: 
              Column(children: <Widget>[
                 
                priceUser !='' ? Text(
                    priceUser,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 priceSpouse != '' ? Text(
                    priceSpouse,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 priceDependents !='' ? Text(
                    priceDependents,
                    style: TextStyle(height: 1.5,)
                  ):Container(),
                  
                 Text(
                    deductible,
                    style: TextStyle(height: 1.5,)
                  ),
                  
                  maternity !='' ? Text(
                    maternity,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 transplant !='' ? Text(
                    transplant,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 costAdmin !='' ? Text(
                    costAdmin,
                    style: TextStyle(height: 1.5,)
                  ):Container(),
              ],)
            
            ,),




          ],
      ), 
    )
    );
    
  } //end for plans
  // print(children.length);
  childrenRev = children.reversed.toList();
  // print(childrenRev.length);

    return Container(           
      child: Column(children: childrenRev),
      );

 
  }

  Widget _buildSeparator(Size screenSize, theme) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: theme.accentColor,
      margin: EdgeInsets.only(top: 4.0, bottom: 10),
    );
  }

    _getUserApi(BuildContext context) async{
      final FirebaseUser user = await _auth.currentUser();
      setState(() {
      isLoading = true;  
      });
      var res2;
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/account/'+user.providerData[1].email+'/email_logged'), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
        // print(resBody);
        if (res.statusCode == 200) { 
          if(resBody.length>0)
          res2 = resBody;
          else
          if(resBody['Error']) {
          setState(() {
           this.existUser = false; 
          });
          res2 = null;
          }
          
        }else{
          res2 = null;
        }
        return res2;

  }
  


}
