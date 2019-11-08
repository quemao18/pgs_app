import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_contulting/screens/user_login.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;


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


  var data;
  @override
  void initState() {

    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        companies = getCompanies(context);
        //companies = [];
      });
    });


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
                title:Text(planName,  style: TextStyle(height: 1.3, fontWeight: FontWeight.bold)), 
                subtitle: Text(planDescription,  style: TextStyle(height: 1.3)),
                trailing: plan['url_info'] !=null ? 
                IconButton(
                  icon: Icon(MdiIcons.openInNew, 
                  size: 25, 
                  color: theme.primaryColor,), 
                  onPressed: () => _launchURL(plan['url_info']), 
                )
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
      child: isLoading?  
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
            _buildTitle(context, theme),
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
        FloatingActionButton(
                onPressed: (){
                  // Navigator.of(context).pop();   
                  // print(selectedOptions);
                  _saveData();
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => 
                  //ExpansionTileSample(dataResult2, companiesIds),
                  LoginPage(message: 'Cotización realizada con éxito, muy pronto te contactaremos para culminar la emisión.')
                  ),
                  );
                },
                
                child: Icon(Icons.navigate_next)//Text('Siguiente')
        ),
        visible: !isLoading && selectedOptions.length > 0,
        )
);

      //bottomNavigationBar: makeBottom,
  }


  Widget _buildTitle(BuildContext context, theme) {
    return Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
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
      
  }

    final formatter = NumberFormat("#,###.##");
    var selectedOptions = [];

    _getChildren(plan, theme, userId, data, userData){

    var price1 = [0,0,0];
    var price2 = [0,0,0];
    var price3 = [0,0,0]; 
    var price = [], dedu = 0;
    var spouse = 0;

    var dedu1 = 0, dedu2 =0, dedu3 = 0;
    var sum1 = 0.toDouble(), sum2 =0.toDouble(), sum3 = 0.toDouble();

    // print(data);
    for(var p in plan['price']){ //print(p['age_range']);

      if(p['age_range'] == '1 dependiente'){
        print('1 dependiente');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
      }
      if(p['age_range'] == '2 dependientes'){
        print('2 dependientes');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
      }
      if(p['age_range'] == '3+ dependientes'){
        print('3 dependientes');
        dependent++;
        price1[2] = (p['price1']); 
        price2[2] = (p['price2']);
        price3[2] = (p['price3']);
      }
      //if(p!=null && p['age_range']!='Deducible' && p.length>1){
      if(p['age_range']!='Deducible' && (
        p['age_range'] != '1 dependiente' &&
        p['age_range'] != '2 dependientes'&&
        p['age_range'] != '3+ dependientes')
        ){ 
        print('Edades');
        if(spouse == 0)
        {
        price1[0] = (p['price1']); 
        price2[0] = (p['price2']);
        price3[0] = (p['price3']);
        }else{
        price1[1] = (p['price1']); 
        price2[1] = (p['price2']);
        price3[1] = (p['price3']);
        }

        spouse++;
      }

      // if(spouse > 0) price1.add(0);
      // if(spouse>1) {spouse=0; price1 = price1.reversed.toList();  price2 = price2.reversed.toList();  price3 = price3.reversed.toList(); } 
      // else
      if(p['age_range']=='Deducible'){ 
        print('Deducible');
        dedu1 = p['price1']; 
        dedu2 = p['price2'];
        dedu3 = p['price3'];
      }
      
    }

    var costAdmin = [], maternityArr = [], transplantArr = [] , sumCostAdmin = 0.0, sumMaternity = 0.0, sumTransplant = 0.0;

    for(var pln in data['plans']){
        // print(pln['maternity']);
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
     if(price1.length>0)
     sum1 = price1.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price2.length>0)
     sum2 = price2.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;
     if(price3.length>0)
     sum3 = price3.reduce((a, b) => a + b ) + sumTransplant + sumMaternity + sumCostAdmin;

     return RadioButtonGroup(
        // margin: EdgeInsets.only(left: 30),
        activeColor: theme.primaryColor,
        labels: <String>[
          ' Opción 1 UDS '+(formatter.format(sum1)).toString() +'\n'+' Deducible UDS '+(formatter.format(dedu1)).toString(),
          ' Opción 2 UDS '+(formatter.format(sum2)).toString() +'\n'+' Deducible UDS '+(formatter.format(dedu2)).toString(),
          ' Opción 3 UDS '+(formatter.format(sum3)).toString() +'\n'+' Deducible UDS '+(formatter.format(dedu3)).toString()
          ],

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
                'deductible': dedu,
                'option_prices': price,
                'option_selected': index+1,
                'maternity': sumMaternity,
                'transplant': sumTransplant,
                'cost_admin': sumCostAdmin,
                'date': DateTime.now().toString(),
                }
              );
            });
            
            print(selectedOptions.toList());
          },

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

      _launchURL(url) async {
      //const url = 'https://pgs-consulting.com/somos-pgs/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

}
