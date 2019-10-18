
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pgs_contulting/screens/plans_details.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;

import 'plans_details2.dart';


class ListPage extends StatefulWidget {
  final String userId;
  final String title;
  
  ListPage({Key key, this.title, this.userId}) : super(key: key);


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
              Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: 
              CachedNetworkImage(
                  height: 60, width: 60,
                  imageUrl: data['company_logo'],
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.image),
              ),
              //Image.network(data['company_logo']),
              ),
              title: new ListTile(title:Text(data['company_name']), subtitle: Text(data['company_description']),),
                children: (data['plans'][0]['price'].length > 0) ?
                  data['plans'].map<Widget>((document) {
                    // print(data['plans'][1]);
                  // print(document['price'].length);
                  isCheck =  !document['status'];
                  // var valueAdd;

                  if(document['price'].length>1)
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
                          builData(data, document, true);
                          }else{
                          companiesIds.remove(data['company_id']);
                          planIds.remove(document['plan_id']);
                          builData(data, document, false);
                          }

                            
                        

                        // var over21s = dataResult2.where((user) => user.title == document['name'] );
                          // print(over21s.toList());
                                

                          // builData(data);
                        });

                      },
                    );
                  return Container();
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

    final makeBody = Container(
      //width: 400,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child:  isLoading?  
        Container(
        margin: EdgeInsets.only(top: screenSize.height/5),
        child: LoadingBouncingGrid.square(
        borderColor: theme.primaryColor,
        borderSize: 1.0,
        size: 70.0,
        backgroundColor: Colors.transparent,
        )
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
              //return new Text('Result: ${snapshot.data}');
              //print(snapshot.data);
              return ListView.builder(
                        //   separatorBuilder: (context, index) => Divider(
                        //   color: Colors.black45,
                        // ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data == null? 0: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                        if(snapshot.data[index]['plans'][0]['price'].length>1)
                        return 
                          // Container(
                            // child: Card(
                            // elevation: 16,
                            // //decoration: BoxDecoration(color: Color(0xFF9e946b),),
                            // child: 
                            Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.primaryColor)
                        ),     
                              child:
                            makeExpansion(snapshot.data[index]),
                            // ),
                            // )
                          );
                          return Container();
                        },
                      );
               }
              }//end builder
         },
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
            Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 30.0),
            child: Column(
              children: <Widget>[
              ListTile(
                title: Text('Planes disponibles según tu perfil', 
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
                ),
                subtitle: Text('Selecciona al menos uno para continuar.', 
                style: TextStyle(color: Colors.black54, fontSize: 13),
                textAlign: TextAlign.center,
                ),
                ),

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
                  //print(planIds);
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => 
                  //ExpansionTileSample(dataResult2, companiesIds),
                  PlansPage(plansIds: planIds, userId: widget.userId,)
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


builData(data, plan, check){

Entry valueAdd=
    Entry(
      data['company_id'],
      plan['plan_id'],
      plan['name'], 
      plan['description'],
      <Entry>[
        Entry(
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

//   final List<Entry> dataResult = <Entry>[
//   Entry(
//     'Company A',
//     <Entry>[
//       Entry('option 1'),
//       Entry('option 2'),
//       Entry('option 3'),
//     ],
//   ),
//   Entry(
//     'comp B',
//     <Entry>[
//       Entry('B0'),
//       Entry('B1'),
//       Entry('B2'),
//     ],
//   ),

// ];

checkPlans(plans){
  bool show = false;
  for(var plan in plans)
  // print(plan['price'].length);
    if(plan['price'].length > 1) show = true;
    // else
    return show;
}

getCompanies(BuildContext context) async {
  //print(widget.userId);
  setState(() {
      isLoading = true;
  });
  var config = AppConfig.of(context);
  //String userId = 'f77542ba-21aa-48ad-a2d9-fa68607166ae';
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/company/companies/'+widget.userId+'/options'), headers: {"Accept": "application/json"});
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

}