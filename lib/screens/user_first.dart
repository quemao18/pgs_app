import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import '../app_config.dart';
import '../app_config.dart';
import '../models/user.dart';
import 'drawer.dart';
import 'user_second.dart';
import 'dart:convert';

class UserFirst extends StatefulWidget {
  @override
  _UserFirst createState() => _UserFirst();
}


class _UserFirst extends State<UserFirst> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  String _selectedLocation;
  String _selectedGender;

  List data = List(); //edited line

  @override
  void initState() {
    super.initState();
    //this.getSWData();



  }

  void afterFirstLayout() {
    // Calling the same function "after layout" to resolve the issue.
       //getCountries(context);
       //print('hola');
  }

  Widget build(BuildContext context) {
   
    //getCountries(context);
     var config = AppConfig.of(context);
    return Scaffold(
        appBar: new AppBar(
          title: new Text(config.appName),
        ),
        drawer: DrawerOnly(), 
        body: Container(
          child: new SingleChildScrollView(  
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
              
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Introduce tu nombre';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _user.name = val),
                          ),
                          TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Apellido'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Introduce tu apellido';
                                }
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _user.lastName = val)
                          ),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration:
                                  InputDecoration(labelText: 'Email'),
                              validator: validateEmail,
                                onSaved: (val) =>
                                    setState(() => _user.email = val)
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Edad'),
                              validator: validateAge,
                              onSaved: (val) =>
                                  setState(() => _user.age = val )
                          ),
                          
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                              child: FutureBuilder(
                                  future: getCountries(context) ,
                                  builder: (context, snapshot){
                                    if (snapshot.hasData) {
                                      //print(snapshot.data);
                                      return new DropdownButtonFormField(
                                       
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
                                      return CircularProgressIndicator();
                                    }
                                  }

                              )

                          ),

                              Container(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                             
                                      child: new DropdownButtonFormField(
                                       
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
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
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
                                child: Text('Siguiente')
                        )
                        ),
                    
                        ])
                        )
                        )
                        )
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
