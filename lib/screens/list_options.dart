
import 'package:flutter/material.dart';
import 'package:flutter_realistic_forms/models/lesson.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List lessons;

  @override
  void initState() {
    lessons = getLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Card makeCard(Lesson lesson) => Card(
    //       elevation: 8.0,
    //       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    //       child: Container(
    //         //decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    //         child: makeListTile(lesson),
    //       ),
    //     );

    
    ExpansionTile makeExpansion(Lesson lesson) => ExpansionTile(
      
              title: Text(
                  lesson.title,
                  style: TextStyle(color: Colors.black87, ),
                ),
              ////backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
               children: lesson.plans.keys.map((String key) {
                //print(key);
                return new CheckboxListTile(
                  title: new Text(key),
                  value: lesson.plans[key],
                  onChanged: (bool value) {
                        setState(() {
                          lesson.plans[key] = value;
                        });
                      },
                    );
                  }).toList()

    ); 

    final makeBody = Container(
      //width: 400,
      margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        //   separatorBuilder: (context, index) => Divider(
        //   color: Colors.black45,
        // ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: lessons.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
            elevation: 16,
            //decoration: BoxDecoration(color: Color(0xFF9e946b),),
            child: makeExpansion(lessons[index]),
            )
          );
          //return makeExpansion(lessons[index]);
        },
      ),
    );

    // final makeBottom = Container(
    //   height: 55.0,
    //   child: BottomAppBar(
    //     color: Color.fromRGBO(58, 66, 86, 1.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.home, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.blur_on, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.hotel, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.account_box, color: Colors.white),
    //           onPressed: () {},
    //         )
    //       ],
    //     ),
    //   ),
    // );
    // final topAppBar = AppBar(
    //   elevation: 16,
    //   backgroundColor:  Color(0xFF9e946b),
    //   title: Text(config.appName),
    //   // actions: <Widget>[
    //   //   IconButton(
    //   //     icon: Icon(Icons.list),
          
    //   //     onPressed: () {

    //   //     },
    //   //   )
    //   // ],
    // );

    return Scaffold(
      //backgroundColor:  Color(0xFF9e946b),
      //appBar: topAppBar,
      body: 
          Container(
            padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 50.0),
            child: Column(
              children: <Widget>[
              Text(
                'Planes disponibles según tu perfil', 
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.left,
                ),
              // Text(
              //   'These are wise words, enterprising men quote \'em.',
              //   style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 10),
              // ),
              makeBody,
              RaisedButton(
                onPressed: () {

                },
                child: Text('Cotizar')
                )
            ],
            ),
            
          ),
        drawer: Drawer(child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('PGS'),
              decoration: BoxDecoration(
                color: Color(0xFF9e946b),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
        ),
      );

      //bottomNavigationBar: makeBottom,
  }
}

List getLessons() {
  
  return [
    Lesson(
        title: "Vumi",
        level: "Beginner",
        indicatorValue: 0.33,
        plans:{
          'plan 1 ':false, 
          'plan 2 ':false
        
        },
        price: 20,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Aser",
        level: "Beginner",
        indicatorValue: 0.33,
        plans:{'plan 1 ':false},
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Best Doctor",
        level: "Intermidiate",
        indicatorValue: 0.66,
        plans:{'plan 1 ':false},
        price: 30,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
 ];
}