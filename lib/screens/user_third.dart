import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pgs_contulting/screens/drawer.dart';
import 'package:pgs_contulting/screens/list_options.dart';
import 'package:pgs_contulting/screens/user_login.dart';
import '../app_config.dart';
import '../models/user.dart';

// import 'package:keyboard_visibility/keyboard_visibility.dart';


import 'drawer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


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
  final userGoogle = UserLogged();
  var userLogged;

  @protected
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
        onChange: (bool visible) {
          //print(visible);
          _keyboardState = visible;
        },
      );
  _getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.user2.spouseGender);
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
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: ListTile(
                                title: Text('COTIZAR', textAlign: TextAlign.center, style: TextStyle(color:theme.accentColor,  fontSize: 25, fontWeight: FontWeight.bold)),
                                subtitle: Text('\nCompleta si deseas alguna cobertura adicional',
                                style: TextStyle(fontSize: 15,height: 1.3, color: theme.accentColor),
                                ),
                                ),
                              ),
                          Container(
                            child: 
                            Column(children: <Widget>[
                            widget.user.gender =='female' &&  int.parse(widget.user.age) >=18 && int.parse(widget.user.age) <=45 || 
                            widget.user2.spouseGender =='female' &&  int.parse(widget.user2.spouseAge) >=18 && int.parse(widget.user2.spouseAge) <=45
                             ?  Container(
                              // height: 40,
                              padding: EdgeInsets.all(10),
                              //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:CheckboxListTile(
                                  title: const Text('Complicaciones de maternidad'),
                                  value: _user.maternity,
                                  activeColor: theme.primaryColor,
                                  onChanged: (val) {
                                    setState(() => _user.maternity = val );
                                  }),
        
                              ):Container(),
                              // Container(
                                //    height: 40,
                                // //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                // child: CheckboxListTile(
                                //     title: const Text('Fumador'),
                                //     value: _user.smoker,
                                //     activeColor: theme.primaryColor,
                                //     onChanged: (val) {
                                //       setState(() => _user.smoker = val );
                                //     }),
                                // ),
                                Container(
                                  //  height: 40,
                                //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                margin: EdgeInsets.only(top: 0),
                                padding: EdgeInsets.all(10),
                                child: CheckboxListTile(
                                    title: const Text('Transplante de organos'),
                                    value: _user.transplant,
                                    activeColor: theme.primaryColor,
                                    onChanged: (val) {
                                      setState(() => _user.transplant = val);
                                    }),
                            
                                ),
                            
                          ],) ,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.primaryColor)
                              ),  
                          ),


                          
                        ]),
                        )
                        ),
                      
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
                                      _user.save(context,widget.user, widget.user2, userLogged).then((id) {
                                           print("Result: $id");
                                           if(id==null)
                                          _showDialog2('Error', 5);
                                          else{
                                          // _showDialog2('Registro correcto...', 5);
                                           Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => ListPage(userId: id, userData: _user)
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


  _getCurrentUser() async{
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final FirebaseUser user = await _auth.currentUser();
    // print(user.providerData[1]); 
    setState(() {
      if(user!=null){
        this.userGoogle.name = user.displayName;
        this.userGoogle.email = user.providerData[1].email;
        this.userGoogle.photo = user.photoUrl;
        isLoggedIn = true;
      }
      else
      isLoggedIn = false;
    });
    this.userLogged = this.userGoogle;
    // print(this.userLogged.photo);
    
  }





}
