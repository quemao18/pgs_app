
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import '../app_config.dart';
import 'drawer.dart';

import 'package:http/http.dart' as http;


class ListPage extends StatefulWidget {
  final String userId;
  
  ListPage({Key key, this.title, this.userId}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List lessons;
  bool isCheck = false;
  List planIds = [];
  bool isLoading = false;
  var companies;

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

    ExpansionTile makeExpansion2(data) => ExpansionTile(
              leading: 
              Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: 
              CachedNetworkImage(
                  height: 50, width: 50,
                  imageUrl: data['company_logo'],
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.image),
              ),
              //Image.network(data['company_logo']),
              ),
              title: new ListTile(title:Text(data['company_name']), subtitle: Text(data['company_description']),),
                children: (data['plans'].length > 0 && data['plans'][0]['price'].length > 0) ?
                  data['plans'].map<Widget>((document) {
                  isCheck =  !document['status'];
                  return new CheckboxListTile(
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
                          if(value)
                          planIds.add(document['plan_id']);
                          else
                          planIds.remove(document['plan_id']);

                        });

                      },
                    );
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
      margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: isLoading?  
        Center(
        child: LoadingBouncingGrid.square(
        borderColor: Color(0xFF9e946b),
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
                        return 
                          Container(
                            child: Card(
                            elevation: 16,
                            //decoration: BoxDecoration(color: Color(0xFF9e946b),),
                            child: 
                            Container(child:
                            makeExpansion2(snapshot.data[index]),
                            ),
                            )
                          );
                          //return makeExpansion(lessons[index]);
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
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 50.0),
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
                  print(planIds);
                },
                
                child: Icon(Icons.navigate_next)//Text('Siguiente')
        ),
        visible: !isLoading && planIds.length > 0,
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