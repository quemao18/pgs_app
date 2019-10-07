import 'dart:ui';

import 'package:flutter/material.dart';
import '../screens/user_first.dart';
import '../app_config.dart';
import 'drawer.dart';

class HomeMaterial extends StatefulWidget {
  @override
  _HomeMaterialState createState() => _HomeMaterialState();
}

              
class _HomeMaterialState extends State<HomeMaterial> {

  @override
    Widget build(BuildContext context){
    var config = AppConfig.of(context);
    return Scaffold(
            appBar: new AppBar(
              title: new Text(config.appName),
            ),
            drawer: DrawerOnly(), 
            body: 
            //SingleChildScrollView(child: 
            Container(
            //padding:new EdgeInsets.symmetric(horizontal: 50, vertical: 50.0),
            //margin: ,
            child:  Container(
              
                    decoration: BoxDecoration(
                      image: DecorationImage(
                                image: AssetImage("./assets/images/screen1.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                      child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding:new EdgeInsets.symmetric(horizontal: 50, vertical: 70.0),
                                        child: 
                                    Text(
                                        'No vendemos pólizas, te damos razones para tenerla.', 
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18),
                                        textAlign: TextAlign.center,
                              
                                        ),
                                      ),

                                      Container(
                                      padding:new EdgeInsets.only(top: 300.0),
                                      child: 
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                          child: 
                                          RaisedButton(
                                            onPressed: () {
                                             Navigator.push(context,
                                              new MaterialPageRoute(builder: (ctxt) => new UserFirst()));
                                            // Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) => UserFirst()
                                            //         ),
                                            //     );
                                            },
                                            child: Text('Cotizar')
                                            )
                                      ),
                                      ),
                                    ],
                                    ),
                                
                        ),
                      ),
                    
                    ),
            //),
          ),
    );
      // body: Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("./assets/images/screen1.png"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   child: new BackdropFilter(
      //     filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      //     child: new Container(
      //       decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
      //     ),
      //   ),
      // ),
      
  }
}
