import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pgs_contulting/components/TextFields/inputField.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//import '../app_config.dart';
import '../app_config.dart';
import '../models/user.dart';
import 'drawer.dart';
import 'user_second.dart';
import 'dart:convert';

class UserFirst extends StatefulWidget {
  @override
  _UserFirst createState() => _UserFirst();
  final userData;

  UserFirst({Key key, this.userData}) : super(key: key);
}


class _UserFirst extends State<UserFirst> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  String _selectedLocation;
  String _selectedGender;

  List data = List(); //edited line
  // bool _isButtonDisabled = false;
  bool _keyboardState;
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;

  @protected
  void initState() {
    super.initState();

    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          print(visible);
          _keyboardState = visible;
        });
      },
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  void afterFirstLayout() {
    // Calling the same function "after layout" to resolve the issue.
       //getCountries(context);
       //print('hola');

  }


  Widget build(BuildContext context) {
    // print(widget.userData);
    if(widget.userData!=null){
    if(widget.userData.name != '') _nameTextController.text = widget.userData.name;
    if(widget.userData.email != '') _emailTextController.text = widget.userData.email;
    _user.photo = widget.userData.photo;
    }else{
      //Navigator.pop(context);
    }
    //_redirectLogin();
    //getCountries(context);
    var config = AppConfig.of(context);
    return Scaffold(
        appBar: new AppBar(
          title: new Text(config.appName),
          //title: Image.asset('./assets/images/Sin-fondo-(4).png', fit: BoxFit.cover)

        ),
        drawer: DrawerOnly(), 
        body: 
        
        Container(
          child: new SingleChildScrollView(  
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
              
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:<Widget>[
                        // Container(
                        // child: CircleAvatar(
                        //   backgroundImage: ExactAssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                        //   minRadius: 20,
                        //   backgroundColor: Colors.transparent,
                        //   maxRadius: 40,
                        // ),
                        // ),
                          // Text('Completa los siguientes campos'),
                          Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            title: Text('COTIZADOR', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            subtitle: Text('\nCotiza, compara y ahorra solicitando las coberturas en 30 segundos...'),
                            ),
                          ),
                          InputField(
                            autovalidate: false,
                            hintText: "Nombre",
                            controller: _nameTextController,
                            obscureText: false,

                            icon: Icons.person,
                            bottomMargin: 20.0,
                            //decoration:InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Introduce tu nombre';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _user.name = val),
                          ),
                          // TextFormField(
                          //     decoration:
                          //         InputDecoration(labelText: 'Apellido'),
                          //     validator: (value) {
                          //       if (value.isEmpty) {
                          //         return 'Introduce tu apellido';
                          //       }
                          //       return null;
                          //     },
                          //     onSaved: (val) =>
                          //         setState(() => _user.lastName = val)
                          // ),
                          InputField(
                            autovalidate: false,
                              controller: _emailTextController,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.mail_outline,
                              bottomMargin: 20.0,
                              hintText: "Email",
                              // decoration:InputDecoration(labelText: 'Email'),
                              validator: validateEmail,
                                onSaved: (val) =>
                                    setState(() => _user.email = val)
                            ),
                          
                            // InputField(
                            //   autovalidate: false,
                            //   hintText: 'Teléfono',
                            //   obscureText: false,
                            //   bottomMargin: 20,
                            //   icon: Icons.phone,
                            //   keyboardType: TextInputType.number,
                            //   // decoration:InputDecoration(labelText: 'Edad'),
                            //   //validator: validateAge,
                            //    validator: (value) {
                            //       if (value.isEmpty) {
                            //         return 'Introduce tu teléfono';
                            //       }
                            //       return null;
                            //     },
                            //   onSaved: (val) =>
                            //       setState(() => _user.phone = val )
                            //   ),
                              
                              Container(
                                  //width: 170,
                                  // height: 60,
                                  //padding: EdgeInsets.only(bottom:20 ),
                                  margin: EdgeInsets.only(top: 0),
                                  child: 
                                  InputField(
                                    autovalidate: false,
                                    hintText: 'Edad',
                                    obscureText: false,
                                    bottomMargin: 20,
                                    icon: Icons.accessibility_new,
                                    keyboardType: TextInputType.number,
                                    // decoration:InputDecoration(labelText: 'Edad'),
                                    validator: validateAge,
                                    onSaved: (val) =>
                                        setState(() => _user.age = val )
                                    ),  
                                ),
                             Container(
                              //width: 200,
                              // height: 60,
                              margin: EdgeInsets.only(left: 0, top: 1),
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  Color(0xFF9e946b) ),
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                                      child: new DropdownButtonFormField(
                                        decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left:20, top: 12),
                                        prefixIcon: Icon(MdiIcons.genderMaleFemale), 
                                        enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                          )
                                        ),
                                        value: _selectedGender,
                                        hint: new Text("Género"),
                                        validator:(value){
                                          if (value?.isEmpty ?? true) {
                                            return 'Selecciona tu género';
                                          }
                                          return null;
                                        },
                                      items: [{"value":'male', "name":"Masculino"}, {"value":'female', "name":"Femenino"}]
                                        .map<DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem<String>(
                                            value: value['value'],
                                            child: Text(value['name']),
                                          );
                                        })
                                        .toList(),
                                        onChanged: (value) {
                                            setState(() {
                                               _user.gender = value;
                                              _selectedGender  = value;
                                            });
                                        }            
                                      ),
                              ),

                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  Color(0xFF9e946b)),
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),

                              child: FutureBuilder(
                                  future: getCountries(context) ,
                                  builder: (context, snapshot){
                                    if (snapshot.hasData) {
                                      //print(snapshot.data);
                                      return new DropdownButtonFormField(
                                        decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left:20, top: 10),
                                        prefixIcon: Icon(Icons.public),
                                        enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                        )
                                        ),
                                        value: _selectedLocation,
                                        hint: new Text("País/Región"),
                                        validator:(value){
                                          if (value?.isEmpty ?? true) {
                                            return 'Selecciona un País ó Región';
                                          }
                                          return null;
                                        },
                                        items: snapshot.data.map<DropdownMenuItem<String>>((value) {
                                          //print(value['country_id']);
                                          return DropdownMenuItem(
                                            value: value['country_id'].toString(),
                                            child: Text(value['name']),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                            setState(() {
                                               _user.countryId = value;
                                              _selectedLocation  = value;
                                            });
                                        }
                                      );
                                    
                                    }
                                    else{
                                      // _isButtonDisabled = true;
                                      return CircularProgressIndicator();
                                    }
                                  }

                              )

                              ), 

                        //   Container(
                        //       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        //       child: 

                        // ),
                    
                        ])
                        )
                        )
                        )
                        ),
                        floatingActionButton:
                        Visibility(child:                              
                        FloatingActionButton(
                                onPressed: (){   
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                    form.save();
                                    //_user.save();
                                    //_showDialog(context);
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => UserSecond(user: _user)
                                    ),
                                    );
                                    }
                                },
                                
                                child: Icon(Icons.navigate_next)//Text('Siguiente')
                        ),
                        visible: !_keyboardState,
                        )
                        );
  }

  // _showDialog(BuildContext context) {
  //   Scaffold.of(context)
  //       .showSnackBar(SnackBar(content: Text('Submitting form')));
  // }


    String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Coloca un email válido';
    else
      return null;
  }

  String validateAge(String value) {
    Pattern pattern =r'^(?:[+0]9)?[0-9]{2}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || int.parse(value) <18 )
      return 'Coloca una edad válida';
    else
      return null;
  }

    getCountries(BuildContext context) async{
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/country/countries/'), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
        //print(resBody);
        if (res.statusCode == 200) {
            return resBody;
        }else{
          throw Exception('Failed to load post');
        }
      
    }


  
}
