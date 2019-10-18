import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;


class PlansPage extends StatefulWidget {

  final plans;
  final List plansIds;
  final String userId;


  PlansPage({Key key, this.plans, this.plansIds, this.userId}) : super(key: key);

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool isCheck = false;
  List planIds = [];
  bool isLoading = false;
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
              title: new ListTile(title:Text(planName,  style: TextStyle(height: 1.3, fontWeight: FontWeight.bold)), 
              subtitle: Text(planDescription,  style: TextStyle(height: 1.3)),),
                children:<Widget>[
                    _getChildren(plan, theme),
                    // if(spouse <= 1 && plan['price'].length<1)
                    // Container(margin: EdgeInsets.only(bottom: 5),
                    // child:
                    // Text('No se encontró ningún plan para su conyugue.', ),
                    // ),
                    // if(dependent == 0 )
                    // Container(margin: EdgeInsets.only(bottom: 5),
                    // child:
                    // Text('No se encontró ningún plan para su hijo.', ),
                    // ),
                ]
                
              );
                

    final makeBody = Container(
      //width: 400,
      margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: isLoading?  
        Container(
        margin: EdgeInsets.only(top: screenSize.height/5),
        child: LoadingBouncingGrid.square(
        borderColor: theme.primaryColor,
        borderSize: 1.0,
        size: 70.0,
        backgroundColor: Colors.transparent,
        )
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
              //print(snapshot.data);
              return ListView.builder(
                    //   separatorBuilder: (context, index) => Divider(
                    //   color: Colors.black45,
                    // ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data == null? 0: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                 
                      final children = <Widget>[];
                      bool show = false; 
                      // pln++;
                      // for(var comp  in snapshot.data)
                      // print(comp['plans'][0]['plan_id']);
                      // if(widget.plansIds.contains(comp['plans'][0]['plan_id']) || widget.plansIds.contains(comp['plans'][1]['plan_id']))
                        children.add(
                          Container(child: 
                          ListTile(
                            leading:    
                            Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: 
                            CachedNetworkImage(
                                height: 50, width: 50,
                                imageUrl: snapshot.data[index]['company_logo'],
                                placeholder: (context, url) => new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(Icons.image),
                            ),),
                            title:Text(snapshot.data[index]['company_name'],
                              style: TextStyle(fontWeight: FontWeight.bold)
                              ), 
                              subtitle: Text(snapshot.data[index]['company_description'],
                              style: TextStyle(height: 1.5)
                              ),
                              ),
                              
                          ), 
                        );
                        // children.add(Divider(color:theme.primaryColor,));
                        show = false;

                        for(var plan in snapshot.data[index]['plans']){
                          if(widget.plansIds.contains(plan['plan_id'])){
                          // print(plan);
                          // print(plan['name']);
                          // pln++;
                          show = true;

                          children.add(
                            // Card(
                            // elevation: 8,  
                            // child: 
                            Container(child: 
                            makeExpansion(snapshot.data[index], plan['name'], plan['description'], plan['plan_id'], pln, plan),
                            //  ),
                            ),
                          );
                          pln++;
                          // children.add(Divider());
                          }
                      
                        }
                        // print(snapshot.data[index]);
                        pln = 0;
                        return show  ? Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.primaryColor)
                        ),               
                          child: Column(children: children),
                        ): Container();
                    //  }else
                    //     return Container();
                  
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
                title: Text('Planes seleccionados', 
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20, height: 1.3),
                textAlign: TextAlign.center,
                ),
                subtitle: Text('Verifica los precios y selecciona los que mas se adapten a tus necesidades.', 
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
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
                  print(selectedOptions);
                },
                
                child: Icon(Icons.navigate_next)//Text('Siguiente')
        ),
        visible: !isLoading && selectedOptions.length > 0,
        )
);

      //bottomNavigationBar: makeBottom,
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
    _getChildren(plan, theme){
    var price1 = []; 
    var price2 = [];
    var price3 = [];
    var dedu1, dedu2, dedu3 = 0;
// print(dependent);
    for(var p in plan['price']){ //print(p['age_range']);

      if(p['age_range'] == '1 dependiente'){
        print('1 dependiente');
        dependent++;
        price1.add(p['price1']); 
        price2.add(p['price2']);
        price3.add(p['price3']);
      }
      if(p['age_range'] == '2 dependientes'){
        print('2 dependientes');
        dependent++;
        price1.add(p['price1']); 
        price2.add(p['price2']);
        price3.add(p['price3']);
      }
      if(p['age_range'] == '3+ dependientes'){
        print('3 dependientes');
        dependent++;
        price1.add(p['price1']); 
        price2.add(p['price2']);
        price3.add(p['price3']);
      }
      //if(p!=null && p['age_range']!='Deducible' && p.length>1){
      if(p['age_range']!='Deducible' && (
        p['age_range'] != '1 dependiente' &&
        p['age_range'] != '2 dependientes'&&
        p['age_range'] != '3+ dependientes')
        ){ 
        print('Edades');
        spouse++;
        price1.add(p['price1']); 
        price2.add(p['price2']);
        price3.add(p['price3']);
      }
      if(spouse>2) spouse=0; 
      if(p['age_range']=='Deducible'){ 
        print('Deducible');
        dedu1 = p['price1']; 
        dedu2 = p['price2'];
        dedu3 = p['price3'];
      }
      
    }
    // print(spouse);
     var sum1 = price1.reduce((a, b) => a + b );
     var sum2 = price2.reduce((a, b) => a + b );
     var sum3 = price3.reduce((a, b) => a + b );

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
            var values = label.split(' ');
            setState(() {
              
              selectedOptions.removeWhere((item) => item['plan_id'] == plan['plan_id']);
              selectedOptions.add(
                {
                "plan_id": plan['plan_id'],
                "label" : label.toString(),
                'price': values[4],
                'deductible': values[7]
                }
              );
            });
            
            // print(selectedOptions.toList());
          },

          );
    }

/*
    _getChildren(data, planId, pln, _radioCompany) {
    print(pln);
    // optionPlan = planId;
    var price1 = []; 
    var price2 = [];
    var dedu1, dedu2, dedu3 = 0;
    var price1Tot;

    // print(data['company_id']);

    for(var p in data['plans'][0]['price'] ){ //print(p['plan_id']);
      if(p!=null && p['age_range']!='Deducible' && p.length>1){
        price1.add(p['price1']); 
        price2.add(p['price2']);
      }else{
        dedu1 = p['price1']; 
        dedu2 = p['price2'];
      }

    }


    // String companyId = data['company_id'];
    // print(companyId);
    var sum1 = price1.reduce((a, b) => a + b );
    var sum2 = price2.reduce((a, b) => a + b );
    // Plan plan1 = Plan(planId: planId, price1Total: sum1, companyId: companyId);
    // Plan plan2 = Plan(planId: planId, price1Total: sum2);
    // if(_radioValue.contains(companyId))
    // _radioValue.remove(companyId);
    // else
    // _radioValue.add(companyId);
    // print(_radioValue[pln]);

    // optionPlan = companyId;
    return [
        RadioListTile(
        title:  
        ListTile(title:Text('Pago UDS '+formatter.format(sum1),
        style: TextStyle(fontWeight: FontWeight.bold)
        ), 
        subtitle: Text('Deducible USD '+ formatter.format(dedu1).toString(),
        style: TextStyle(height: 1.5)
        ),
        ),
        value: pln,
        groupValue: _radioValue,
        onChanged: (currentPlan) {
              setState(() {
                //  print("Current Plan ${currentPlan.planId}");
                //  setSelectedPlan(currentPlan);
                _radioValue = currentPlan;
                print(currentPlan);

              });
            },
          // selected: selectedPlan.planId == plan1.planId,
        ),
        // RadioListTile(
        // title:  
        // ListTile(title:Text('Pago UDS '+formatter.format(plan2.price1Total),
        // style: TextStyle(fontWeight: FontWeight.bold)
        // ), 
        // subtitle: Text('Deducible USD'+ formatter.format(dedu2).toString(),
        // style: TextStyle(height: 1.5)
        // ),
        // ),
        // value: planId+'_option'+(pln-1+2).toString(),
        // groupValue: optionPlan,
        // onChanged: (currentPlan) {
        //       setState(() {
        //         //  print("Current Plan ${currentPlan.planId}");
        //         //  setSelectedPlan(currentPlan);
        //         optionPlan = currentPlan;
        //         print(currentPlan);

        //       });
        //     },
        //     // activeColor: Colors.green,
        // selected: optionPlan == planId+'option2',
        // )
      ];
}
*/

}
