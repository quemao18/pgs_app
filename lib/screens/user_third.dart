import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pgs_contulting/screens/list_options.dart';
import '../app_config.dart';
import '../models/user.dart';

// import 'package:keyboard_visibility/keyboard_visibility.dart';


import 'drawer.dart';

class UserThird extends StatefulWidget{
  
  final User user;
  final User user2;

  UserThird({Key key, this.user, this.user2}) : super(key: key);

  
  @override
  _UserThird createState()=> _UserThird();
  
}


class _UserThird extends State<UserThird>{
  final _user = User();
  final _formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  //String _selectedDependent;

  List<DropdownMenuItem> list = [];
  List<String> ages = [];

  int value = 0;
  bool _keyboardState= false;

  @protected
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
        onChange: (bool visible) {
          //print(visible);
          _keyboardState = visible;
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.user2.spouseAge);
    var config = AppConfig.of(context);
    final ThemeData theme = Theme.of(context);
    
    return Scaffold(
      key: _scaffoldstate,
        appBar: new AppBar(
          title: new Text(config.appName),
        ),
        drawer: DrawerOnly(), 
        body: 

        SingleChildScrollView(
          child:
        
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Builder(
              
                builder: (context) => Form(
                    key: _formKey,
                    
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                   

                              Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    title: Text('COTIZAR', textAlign: TextAlign.center, style: TextStyle(color:theme.accentColor,  fontSize: 25, fontWeight: FontWeight.bold)),
                                    subtitle: Text('\nCompleta si deseas alguna cobertura adicional',
                                    style: TextStyle(fontSize: 15,height: 1.3, color: theme.accentColor),
                                    ),
                                    ),
                                  ),
                          // Container(
                          //   //padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //   //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          //   //child: Text('Otra información'),
                          //   //child: Text("OR"),
                          //     margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          //     child: Divider(
                          //       color: Color(0xFF9e946b),
                          //       //height: 6,
                          //     )
                          //   ),
                            //),
                          //),
                          
                          Container(
                            height: 40,
                          //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child:CheckboxListTile(
                              title: const Text('Maternidad'),
                              value: _user.maternity,
                              activeColor: theme.primaryColor,
                              onChanged: (val) {
                                setState(() => _user.maternity = val );
                              }),
                          ),
                          Container(
                             height: 40,
                          //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: CheckboxListTile(
                              title: const Text('Fumador'),
                              value: _user.smoker,
                              activeColor: theme.primaryColor,
                              onChanged: (val) {
                                setState(() => _user.smoker = val );
                              }),
                          ),
                          Container(
                             height: 40,
                          //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: CheckboxListTile(
                              title: const Text('Transplante de organos'),
                              value: _user.transplant,
                              activeColor: theme.primaryColor,
                              onChanged: (val) {
                                setState(() => _user.transplant = val);
                              }),
                          ),

                          
                        ])
                        )
                        )
                        )
                        ),
                        floatingActionButton:  
                        Visibility(child:                             
                        FloatingActionButton(
                          elevation: 10,
                        
                                onPressed: (){   
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      //print(widget.user);
                                      _user.save(context,widget.user, widget.user2).then((id) {
                                           print("Result: $id");
                                           if(id==null)
                                          _showDialog2('Error', 5);
                                          else{
                                          // _showDialog2('Registro correcto...', 5);
                                           Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => ListPage(userId: id)
                                            ),
                                            );
                                          }
                                      } 
                                     
                                      
                                      );
                                      
                                      //saveUser(context, widget.user, _user)
                                      //print(widget.user.name);
                                    }
                                },
                                
                                child: Icon(Icons.navigate_next)//Text('Siguiente')
                        ),
                        visible:  !_keyboardState
                    ),
              );
  }



_showDialog2(text, tempo){
  _scaffoldstate.currentState.showSnackBar(
    new SnackBar(
        duration: new Duration(seconds: tempo),
        content: new Text(text),
      )
      );
  }








}