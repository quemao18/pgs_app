
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pgs_contulting/screens/plans_details.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  final String userId;
  final String title;
  final userData;
  
  ListPage({Key key, this.title, this.userId, this.userData}) : super(key: key);


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isCheck = false;
  List planIds = [];
  bool isLoading = false;
  var companies;

  List<Entry> dataResult2 = [];
  List companiesIds = [];

  @override
  void initState() {

    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        companies = getCompanies(context);
      });
    });


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    ExpansionTile makeExpansion(data) => ExpansionTile(
              leading: 
              CachedNetworkImage(
                  height: 40, 
                  width: 40,
                  imageUrl: data['company_logo'],
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.image),
              ),
              //Image.network(data['company_logo']),
              
              
              title: Container(
                width: 50,
                child: ListTile(
                title: Text(data['company_name'], 
                style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),), 
                subtitle: Text(data['company_description']),
                ),
              ),
                children: (data['plans'][0]['price'].length > 0) ?
                  data['plans'].map<Widget>((document) {
                    // print(data['plans'][1]);
                  //  print(document['name']);
                  isCheck =  !document['status'];
                  // var valueAdd;
                  // if(document['price'].length>1)
                  return new CheckboxListTile(
                  activeColor: theme.primaryColor,
                  title: new 
                  ListTile(title:Text(document['name'],
                  style: TextStyle(fontWeight: FontWeight.bold)
                  ), 
                  subtitle: Text(document['description'],
                  style: TextStyle(height: 1.5)
                  ),
                  ),
                  value: !document['status'],
                  onChanged: (bool value) {
                        setState(() {
                          //print(data['plans'][0]['price']);
                          document['status'] = !value;
                          if(value){
                          if(!companiesIds.contains(data['company_id']))
                          companiesIds.add(data['company_id']);
                          planIds.add(document['plan_id']);
                          // builData(data, document, true);
                          }else{
                          companiesIds.remove(data['company_id']);
                          planIds.remove(document['plan_id']);
                          // builData(data, document, false);
                          }

                        });

                      },
                    );
                  // return Container();
                }).toList()
                :
                <Widget>[
                ListTile(
                  title:Text('Ningún plan encontrado para tu perfil', 
                  style: TextStyle(height: 1.3),), 
                  subtitle: Text('Ponte en contacto con nosotros para conseguirte el plan ideal.', 
                  style: TextStyle(height: 1.3),),),
                ],
                

    ); 

    final makeBody = 
    
    Container(
      // height: screenSize.height,
      //width: 400,
      // padding: EdgeInsets.only(top:screenSize.height/14),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child:  isLoading?  
        Container(
        margin: EdgeInsets.only(top: screenSize.height/5, left: screenSize.width/4.5),
        child: Column(children: <Widget>[
          LoadingBouncingGrid.square(
        borderColor: theme.primaryColor,
        borderSize: 1.0,
        size: 70.0,
        backgroundColor: Colors.transparent,
        ),
        Text('\nBuscando los mejores planes...')
        ],)
        )
      :FutureBuilder(
        future: companies,
        builder: (context, snapshot) {
           switch (snapshot.connectionState) {
             case ConnectionState.waiting: return CircularProgressIndicator();
             default:
               if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
               else{

                 var children = <Widget>[];

                 for(var data in snapshot.data){
                   children.add(
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.primaryColor)
                        ),     
                        child:
                        makeExpansion(data),
                      )
                   );
                 }
                return Column(children: children);
                 
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
            SafeArea(child: 
            Container(
            // height: screenSize.height/1.2,
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 90.0),
            child:
              makeBody,
            ),
            )
          ]
      ),
        
    ),
        floatingActionButton:
        Visibility(child:                              
        FloatingActionButton(
                onPressed: (){   
                  //print(planIds);
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => 
                  //ExpansionTileSample(dataResult2, companiesIds),
                  PlansPage(plansIds: planIds, userId: widget.userId, userData: widget.userData)
                  ),
                  );
                },
                
                child: Icon(Icons.navigate_next)//Text('Siguiente')
        ),
        visible: !isLoading && planIds.length > 0,
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
                title: Text('Planes disponibles según tu perfil',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20, height: 1.3),
                textAlign: TextAlign.center,
                ),
                subtitle: Text('Selecciona al menos uno para continuar.', 
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
                ),
                ),
            ],
            ),
            
          );
  }

builData(data, plan, check){

Entry valueAdd=
    Entry(
      data['company_name'],
      data['company_logo'],
      data['company_id'],
      plan['plan_id'],
      plan['name'], 
      plan['description'],
      <Entry>[
        Entry(     
            data['company_name'],
            data['company_logo'],
            data['company_id'], 
            plan['plan_id'],
            'Pago USD '+(plan['price'][0]['price1'].toString()), 
            'Deducible 10' 
          ),
        
        ],
    );

int index = dataResult2.indexWhere((item) => item.planId == valueAdd.planId);
if(!check)
dataResult2.removeAt(index);
else
dataResult2.add(valueAdd);

}

getCompanies(BuildContext context) async {
  //print(widget.userId);
  setState(() {
      isLoading = true;
  });
  try{
  var config = AppConfig.of(context);
  //String userId = 'f77542ba-21aa-48ad-a2d9-fa68607166ae';
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/company/companies/'+widget.userId+'/options'), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
        // print(resBody);
        if (res.statusCode == 200) {
              setState(() {
                isLoading = false;
              });

            return resBody;
        }else{
          throw Exception('Failed to load post');
        }   
    }
    catch(_){
    print('error');
    // _showDialog2('Error de conexión', 3);
    }

}

}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(
    this.companyName,
    this.companyLogo,
    this.companyId,
    this.planId,
    this.title, 
    this.subTitle, [this.children = const <Entry>[]]);

  final String title;
  final String subTitle;
  final String planId;
  final String companyId;
  final String companyName;
  final String companyLogo;
  final List<Entry> children;
  // final String planId;

}
