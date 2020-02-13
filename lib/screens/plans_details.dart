import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_health/screens/drawer.dart';
import 'package:pgs_health/screens/user_login.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;


class PlansPage extends StatefulWidget {

  final plans;
  final List plansIds;
  final String userId;
  final userData;

  PlansPage({Key key, this.plans, this.plansIds, this.userId, this.userData}) : super(key: key);

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {

  bool isCheck = false;
  List planIds = [];
  bool isLoading = false;
  bool isSaving = false;
  var companies;
  int count=0;
  int dependent=0, spouse =0;
  String emailLogged = '';

  var data;
  @override
  void initState() {

    super.initState();
    companies = null;
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        companies = getCompanies(context);
        //companies = [];
      });
    });

    _getEmailLogged();

  }

  @override
  void dispose() {
    super.dispose();
  }

  int pln = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    // final formatter = NumberFormat("#,###.##");

    ExpansionTile makeExpansion(data, planName, planDescription, planId, pln, plan) => ExpansionTile(
              title: new ListTile(
                // leading: Icon(Icons.access_alarm),
                title:Text(planName,  style: TextStyle(height: 1.1, fontWeight: FontWeight.bold)), 
                subtitle: Text(planDescription,  style: TextStyle(height: 1.3)),
                trailing: plan['url_info'] !=null ? 

                Column(
                    children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:8.0, bottom:0),
                      child: Text('Detalles', style: TextStyle(fontSize: 12, height: 0)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:0.0),
                      child: IconButton(
                          
                          icon: Icon(MdiIcons.openInNew, 
                          size: 25, 
                          color: theme.primaryColor,), 
                          onPressed: () => _launchURL(plan['url_info']), 
                        ),
                    )
                  ])
         

                

                : null,
              ),
                children:<Widget>[
                    _getChildren(plan, theme, widget.userId, data, widget.userData),
                ]
                
              );
                

    final makeBody = Container(
      //width: 400,
      margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: isLoading || companies==null?  
        Container(
        margin: EdgeInsets.only(top: screenSize.height/5, left: screenSize.width/5),
        child: Column(children: <Widget>[
          LoadingBouncingGrid.square(
        borderColor: theme.primaryColor,
        borderSize: 1.0,
        size: 70.0,
        backgroundColor: Colors.transparent,
        ),
        isSaving ?  Text('\nEnviando solicitud...') : Text('\nBuscando los mejores precios...')
        ],)
        )
      :
      FutureBuilder(
        future: companies,
        builder: (context, snapshot) {
           switch (snapshot.connectionState) {
             case ConnectionState.waiting: return CircularProgressIndicator();
             default:
               if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
               else{
              //return new Text('Result: ${snapshot.data}');
              //print(snapshot.data);];
                var childrenMain = <Widget>[];
                var childrenExp = <Widget>[];
                var title =  Container() ;
                bool show = false; 
                
                for(var data in snapshot.data){

                 title = 
                      Container(
                      child: 
                        ListTile(
                          leading:    
                          Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: 
                          CachedNetworkImage(
                              height: 50, width: 50,
                              imageUrl: data['company_logo'],
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(Icons.image),
                          ),),
                          title:
                          Container(
                          padding: EdgeInsets.only(top: 20),
                          child: 
                          Text(data['company_name'],
                            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5, fontSize: 18)
                            )), 
                            subtitle: Text('',),
                          ),
                            
                      ); 


                        show = false;

                        for(var plan in data['plans']){
                          if(widget.plansIds.contains(plan['plan_id'])){
                          show = true;
                          childrenExp.add(
                            makeExpansion(data, plan['name'], plan['description'], plan['plan_id'], pln, plan),
                          );
                          pln++;
                          }
                          
                        }
                        
                  var c = Column(children: childrenExp,);

                  if(show)
                  childrenMain.add(
                  
                    Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.primaryColor)
                    ),               
                    child: Column(children: <Widget>[title, c],)
                    )
                  
                  );

                 childrenExp = [];
                 title = null;
                 pln = 0;
                 }

                  return Column(children: childrenMain);
                        
               }
               
              }
         },//end builder
        )


    );

    var config = AppConfig.of(context);
    return Scaffold(
        appBar: new AppBar(
          title: new Text(config.appName),
        ),
      drawer: DrawerOnly(), 
      body: 
      SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _buildTitle(context, theme, screenSize),
            Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 90.0),
            child: Column(
              children: <Widget>[
              makeBody,
            ],
            ),
            
          ),
          ]
      ),
        
    ),
    
    floatingActionButton: 
    Visibility(child:
      FloatingActionButton.extended(
        label: Text('Enviar'),
        // icon: Icon(MdiIcons.send),
        onPressed: () {
          // Add your onPressed code here!
          _saveData();
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => 
          //ExpansionTileSample(dataResult2, companiesIds),
          LoginPage(message: 'Cotización enviada con éxito. Comunícate con nosotros para cualquier pregunta que tengas, mientras enviamos la información a tu correo.')
          ),
          );
        },
            // backgroundColor: Colors.pink,
          ),
          visible: !isLoading && selectedOptions.length > 0,
        ),

);

      //bottomNavigationBar: makeBottom,
  }


  Widget _buildTitle(BuildContext context, theme, screenSize) {
    return Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: screenSize.height/55),
            child: Column(
              children: <Widget>[
              ListTile(
                title: Text('Planes seleccionados',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20, height: 1.3),
                textAlign: TextAlign.center,
                ),
                subtitle: Text('Verifica los precios y selecciona los que mas se adapten a tus necesidades.', 
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
                ),
                ),
            ],
            ),
            
          );
  }



getCompanies(BuildContext context) async {
  //print(widget.userId);
  try{
  setState(() {
      isLoading = true;
  });

    var config = AppConfig.of(context);
  //String userId = 'f77542ba-21aa-48ad-a2d9-fa68607166ae';
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/company/companies/'+widget.userId+'/options'), 
      headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
        //print(resBody);
        if (res.statusCode == 200) {
              setState(() {
                isLoading = false;
              });

            return resBody;
        }else{
          throw Exception('Failed to load post');
        }
    }catch(_){
      print('error in options details');
    }
      
  }

    final formatter = NumberFormat("#,###.##");
    var selectedOptions = [];

    _getChildren(plan, theme, userId, data, userData)  {
    var price1 = [0,0,0];
    var price2 = [0,0,0];
    var price3 = [0,0,0]; 
    var price4 = [0,0,0];
    var price5 = [0,0,0];
    var price6 = [0,0,0]; 
    var price7 = [0,0,0];
    var price8 = [0,0,0];   
    var price1Arr =[];
    var price2Arr =[];
    var price3Arr =[];
    var price4Arr =[];
    var price5Arr =[];
    var price6Arr =[];
    var price7Arr =[];
    var price8Arr =[];   
    List <String> optionsArr = new List();    
    var price = [], dedu = 0;

    var dedu1 = 0, dedu2 =0, dedu3 = 0,dedu4 = 0, dedu5 =0, dedu6 = 0,dedu7 = 0, dedu8 =0;
    var sum1 = 0.toDouble(), sum2 =0.toDouble(), sum3 = 0.toDouble(), sum4 = 0.toDouble(), sum5 =0.toDouble(), sum6 = 0.toDouble(),sum7 = 0.toDouble(), sum8 =0.toDouble();

    // print(userData.dependents);
    for(var p in plan['price']){ //print(p['age_range']);

      if(p['age_range'] == '1 dependiente'){
        print('1 dependiente');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
        price4[2] = (p['price4']); 
        price5[2] = (p['price5']);
        price6[2] = (p['price6']);
        price7[2] = (p['price7']); 
        price8[2] = (p['price8']);
      }
      if(p['age_range'] == '2 dependientes'){
        print('2 dependientes');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
        price4[2] = (p['price4']); 
        price5[2] = (p['price5']);
        price6[2] = (p['price6']);
        price7[2] = (p['price7']); 
        price8[2] = (p['price8']);
      }
      if(p['age_range'] == '3+ dependientes'){
        print('3 dependientes');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
        price4[2] = (p['price4']);
        price5[2] = (p['price5']);
        price6[2] = (p['price6']);
        price7[2] = (p['price7']);
        price8[2] = (p['price8']);

      }
      //if(p!=null && p['age_range']!='Deducible' && p.length>1){
      if(p['age_range']!='Deducible' && (
        p['age_range'] != '1 dependiente' &&
        p['age_range'] != '2 dependientes'&&
        p['age_range'] != '3+ dependientes')
        ){ 
        // print('Edades');
        print(p['age_range']);
        price1Arr.add(p['price1']);
        price2Arr.add(p['price2']);
        price3Arr.add(p['price3']);
        price4Arr.add(p['price4']);
        price5Arr.add(p['price5']);
        price6Arr.add(p['price6']);
        price7Arr.add(p['price7']);
        price8Arr.add(p['price8']);
      } 
       
      
      // if(spouse > 0) price1.add(0);
      // if(spouse>1) {spouse=0; price1 = price1.reversed.toList();  price2 = price2.reversed.toList();  price3 = price3.reversed.toList(); } 
      // else
      if(p['age_range']=='Deducible'){ 
        print('Deducible');
        dedu1 = p['price1']; 
        dedu2 = p['price2'];
        dedu3 = p['price3'];
        dedu4 = p['price4'];
        dedu5 = p['price5'];
        dedu6 = p['price6'];
        dedu7 = p['price7'];
        dedu8 = p['price8'];

      }
      
    }
    // print(price1Arr);
    if(price1Arr.length>1){
      price1[0] = price1Arr[1];
      price1[1] = price1Arr[0];
    }else{
      if(price1Arr.length>0)
      price1[0] = price1Arr[0];
      if(price1Arr.length>1)
      price1[1] = price1Arr[1];
    }

    if(price2Arr.length>1){
      price2[0] = price2Arr[1];
      price2[1] = price2Arr[0];
    }else{
      if(price2Arr.length>0)
      price2[0] = price2Arr[0];
      if(price2Arr.length>1)
      price2[1] = price2Arr[1];
    }

    if(price3Arr.length>1){
      price3[0] = price3Arr[1];
      price3[1] = price3Arr[0];
    }else{
      if(price3Arr.length>0)
      price3[0] = price3Arr[0];
      if(price3Arr.length>1)
      price3[1] = price3Arr[1];
    }

    if(price4Arr.length>1){
      price4[0] = price4Arr[1];
      price4[1] = price4Arr[0];
    }else{
      if(price4Arr.length>0)
      price4[0] = price4Arr[0];
      if(price4Arr.length>1)
      price4[1] = price4Arr[1];
    }

    if(price5Arr.length>1){
      price5[0] = price5Arr[1];
      price5[1] = price5Arr[0];
    }else{
      if(price5Arr.length>0)
      price5[0] = price5Arr[0];
      if(price5Arr.length>1)
      price5[1] = price5Arr[1];
    }

    if(price6Arr.length>1){
      price6[0] = price6Arr[1];
      price6[1] = price6Arr[0];
    }else{
      if(price6Arr.length>0)
      price6[0] = price6Arr[0];
      if(price6Arr.length>1)
      price6[1] = price6Arr[1];
    }

    if(price7Arr.length>1){
      price7[0] = price7Arr[1];
      price7[1] = price7Arr[0];
    }else{
      if(price7Arr.length>0)
      price7[0] = price7Arr[0];
      if(price7Arr.length>1)
      price7[1] = price7Arr[1];
    }

    if(price8Arr.length>1){
      price8[0] = price8Arr[1];
      price8[1] = price8Arr[0];
    }else{
      if(price8Arr.length>0)
      price8[0] = price8Arr[0];
      if(price8Arr.length>1)
      price8[1] = price8Arr[1];
    }

    var costAdmin = [], maternityArr = [], transplantArr = [] , sumCostAdmin = 0.0, sumMaternity = 0.0, sumTransplant = 0.0;

    for(var pln in data['plans']){
        if(plan['plan_id']==pln['plan_id']){
          costAdmin.add(pln['cost_admin']);
          if(userData.maternity) maternityArr.add(pln['maternity']);
          if(userData.transplant) transplantArr.add(pln['transplant']);
        }
    }

    if(costAdmin.length>0)
      sumCostAdmin = costAdmin.reduce((a, b) => a + b );
    if(maternityArr.length>0)
      sumMaternity = maternityArr.reduce((a, b) => a + b );
    if(transplantArr.length>0)
      sumTransplant = transplantArr.reduce((a, b) => a + b );
   
    // print(sumMaternity );
     
     if(price1[0]!=null && price1.length>0 && price1.reduce((a, b) => a + b )>0)
     sum1 = price1.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price2[0]!=null && price2.length>0 && price2.reduce((a, b) => a + b )>0)
     sum2 = price2.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price3[0]!=null && price3.length>0 && price3.reduce((a, b) => a + b )>0)
     sum3 = price3.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price4[0]!=null && price4.length>0 && price4.reduce((a, b) => a + b )>0)
     sum4 = price4.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price5[0]!=null && price5.length>0 && price5.reduce((a, b) => a + b )>0)
     sum5 = price5.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price6[0]!=null && price6.length>0 && price6.reduce((a, b) => a + b )>0)
     sum6 = price6.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price7[0]!=null && price7.length>0 && price7.reduce((a, b) => a + b )>0)
     sum7 = price7.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price8[0]!=null && price8.length>0 && price8.reduce((a, b) => a + b )>0)
     sum8 = price8.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;

          // ' Opción I \$'+(formatter.format(dedu1)).toString() +'\n'+' \$'+(formatter.format(sum1)).toString(),
          // ' Opción II \$'+(formatter.format(dedu2)).toString() +'\n'+' \$'+(formatter.format(sum2)).toString(),
          // ' Opción III \$'+(formatter.format(dedu3)).toString() +'\n'+' \$'+(formatter.format(sum3)).toString(),
          // ' Opción IV \$'+(formatter.format(dedu4)).toString() +'\n'+' \$'+(formatter.format(sum4)).toString(),
          // ' Opción V \$'+(formatter.format(dedu5)).toString() +'\n'+' \$'+(formatter.format(sum5)).toString(),
          // ' Opción VI \$'+(formatter.format(dedu6)).toString() +'\n'+' \$'+(formatter.format(sum6)).toString(),
          // ' Opción VII \$'+(formatter.format(dedu7)).toString() +'\n'+' \$'+(formatter.format(sum7)).toString(),
          // ' Opción VIII \$'+(formatter.format(dedu8)).toString() +'\n'+' \$'+(formatter.format(sum8)).toString(),
      optionsArr.length = 0;
      if(sum1>0)
        optionsArr.add(
        ' Opción I \$'+(formatter.format(dedu1)).toString() +'\n'+' \$'+(formatter.format(sum1)).toString()
        );
      if(sum2>0)
        optionsArr.add(
        ' Opción II \$'+(formatter.format(dedu2)).toString() +'\n'+' \$'+(formatter.format(sum2)).toString()
        );
      if(sum3>0)
        optionsArr.add(
        ' Opción III \$'+(formatter.format(dedu3)).toString() +'\n'+' \$'+(formatter.format(sum3)).toString()
        );
      if(sum4>0)
        optionsArr.add(
        ' Opción IV \$'+(formatter.format(dedu4)).toString() +'\n'+' \$'+(formatter.format(sum4)).toString()
        );
      if(sum5>0)
        optionsArr.add(
        ' Opción V \$'+(formatter.format(dedu5)).toString() +'\n'+' \$'+(formatter.format(sum5)).toString()
        );
      if(sum6>0)
        optionsArr.add(
        ' Opción VI \$'+(formatter.format(dedu6)).toString() +'\n'+' \$'+(formatter.format(sum6)).toString()
        );
      if(sum7>0)
        optionsArr.add(
        ' Opción VII \$'+(formatter.format(dedu7)).toString() +'\n'+' \$'+(formatter.format(sum7)).toString()
        );
      if(sum8>0)
        optionsArr.add(
        ' Opción VIII \$'+(formatter.format(dedu8)).toString() +'\n'+' \$'+(formatter.format(sum8)).toString()
        );
      //  if(sum1>0 && sum2>0 && sum3>0 || sum4>0 && sum5>0 && sum6>0 && sum7>0 && sum8>0)
    if(optionsArr.length>0)
     return RadioButtonGroup(
        // margin: EdgeInsets.only(left: 30),
        activeColor: theme.primaryColor,
        labels:  optionsArr ,

       itemBuilder: (Radio rb, Text txt, int i){
         
            return Row(
              
              children: <Widget>[ 
                // Icon(Icons.public),
                rb,
                txt,
              ],
            );
          },

          labelStyle: TextStyle(height: 1.3, fontWeight: FontWeight.normal,),
          //onSelected: (String selected) => print(selected),
          onChange: (String label, int index){ 
            // print("label: $label index: $plan");
            // var values = label.split(' ');
            if(index==0) {price = price1; dedu = dedu1;}
            if(index==1) {price = price2; dedu = dedu2;}
            if(index==2) {price = price3; dedu = dedu3;}
            if(index==3) {price = price4; dedu = dedu4;}
            if(index==4) {price = price5; dedu = dedu5;}
            if(index==5) {price = price6; dedu = dedu6;}
            if(index==6) {price = price7; dedu = dedu7;}
            if(index==7) {price = price8; dedu = dedu8;}

            setState(() {
             
              selectedOptions.removeWhere((item) => item['plan_id'] == plan['plan_id']);
              selectedOptions.add(
                {
                'plan_id': plan['plan_id'],
                'company_id':plan['company_id'],
                'company_name':data['company_name'],
                'company_logo':data['company_logo'],
                'plan_name': plan['name'],
                'user_id': userId, 
                'email_logged': emailLogged,
                'deductible': dedu,
                'dependents': userData.dependents,
                'spouse_age': userData.spouseAge,
                'spouse_gender': userData.spouseGender,
                'option_prices': price,
                'option_selected': index+1,
                'maternity': sumMaternity,
                'transplant': sumTransplant,
                'cost_admin': sumCostAdmin,
                'date': DateTime.now().toString(),
                }
              );
            });
            // print(user.s].email);
            print(selectedOptions.toList());
          },

          );
          else
          return  ListTile(
                title: Text('No califica para este producto',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15, height: 1.3),
                textAlign: TextAlign.center,
                ),
                subtitle: Text('Ponte en contacto con nosotros para mayor información', 
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
                ),
                );
      
    }

    _saveData() async {
        setState(() {
            isLoading = true;
            isSaving = true;
        });
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      // print(selectedOptions);
      data = {"plans":selectedOptions};
      String res2;
      // for(var i = 0; i < data.length; i++){
        var res = (await apiRequestPost(url+'v1/account/'+widget.userId+'/plans',data));
        res2 = res;
        // print(res);
      // }
      // print(res2);

      return res2;
    }

    apiRequestPost(String url, Map jsonMap) async {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();

      // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      //print(json.decode(reply)['result']);
      httpClient.close();
      if(response.statusCode == 200){
        setState(() {
            isLoading = false;
            isSaving = false;
        });
        return json.decode(reply)['result'] as String;
      }

      }

      _getEmailLogged() async{
      final FirebaseUser user = await _auth.currentUser();
      final email = await FlutterSecureStorage().read(key: "email");
      
      setState(() {
        if(user!=null || email!=null){
        // this.emailLogged = user.providerData[0].email;
        if(Platform.isIOS)
        this.emailLogged = email!=null ? email : user.providerData[0].email;
        else
        this.emailLogged = user.providerData[1].email;
        }
      });

      }
      
      _launchURL(url) async {
      //const url = 'https://pgs-consulting.com/somos-pgs/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

}
