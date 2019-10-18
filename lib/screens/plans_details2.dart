import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import '../app_config.dart';
import 'drawer.dart';

class ExpansionTileSample extends StatelessWidget {
  final companies;
  final List companiesIds;
  ExpansionTileSample(this.companies, this.companiesIds);
  


  @override
  Widget build(BuildContext context) {
  final ThemeData theme = Theme.of(context);
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('ExpansionTile'),
    //     ),
    //     body: ListView.builder(
    //       itemBuilder: (BuildContext context, int index) =>
    //           EntryItem(companies[index]),
    //       itemCount: companies.length,
    //     ),
    //   ),
    // );

  final makeBody =
      Container(
  child: 
      ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {



           return 
           Column(
             children: <Widget>[
             Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(0.0),
                decoration: 
                BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.primaryColor)
                ),    
               child: 
              EntryItem(companies[index], companiesIds)
             ),
            ],
           );
          },
        itemCount: companies.length,
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
                padding:new EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
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
                    
   
                        //  Expanded(child: SizedBox(
                        //   height: 200.0,
                        //   child: 
                        //   ListTile(
                        //     leading:    
                        //     Padding(
                        //     padding: EdgeInsets.only(top: 4, bottom: 4),
                        //     child: 
                        //     CachedNetworkImage(
                        //         height: 50, width: 50,
                        //         imageUrl: '',
                        //         placeholder: (context, url) => new CircularProgressIndicator(),
                        //         errorWidget: (context, url, error) => new Icon(Icons.image),
                        //     ),
                        //     ),
                        //     title:Text('company',
                        //       style: TextStyle(fontWeight: FontWeight.bold)
                        //       ), 
                        //       subtitle: Text('company_description',
                        //       style: TextStyle(height: 1.5)
                        //       ),
                        //       ),
                        //  ),
                        //  ),

                makeBody
                
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
                  
                },
                
                child: Icon(Icons.navigate_next)//Text('Siguiente')
        ),
            visible: false,
            )
    );

  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(
    this.companyId,
    this.planId,
    this.title, 
    this.subTitle, [this.children = const <Entry>[]]);

  final String title;
  final String subTitle;
  final String planId;
  final String companyId;
  final List<Entry> children;
  // final String planId;

}


// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  
  const EntryItem(this.entry, this.companiesIds);
  

  final Entry entry;
  final List companiesIds;

  Widget _buildTiles(Entry root, List companiesIds, theme) {
    // print(companiesIds);
    //if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return 

    Container(

      child: 
           Column(children: <Widget>[

          Container(

            child: 
          ExpansionTile(
              key: PageStorageKey<Entry>(root),
              // title: Text(root.title),
              title: new ListTile(title:Text(root.title,  style: TextStyle(height: 1.3, fontWeight: FontWeight.bold, color: theme.primaryColor)), 
              subtitle: Text(root.subTitle,  style: TextStyle(height: 1.3)),),
              children: <Widget>[

                RadioButtonGroup(
                    activeColor: theme.primaryColor,
                    labels: root.children.map((child) { 
                      return child.title +'\n'+child.subTitle;
                    }).toList(),
                    labelStyle: TextStyle(height: 1.2, fontWeight: FontWeight.normal, color: theme.primaryColor ),
                    onSelected: (String selected) => print(selected)
                    ),

              ],
            ),
            //root.children.map(_buildTiles).toList(),
            )
          
            ],
          ),
           
      );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _buildTiles(entry, companiesIds, theme);
  }
}
