import 'package:flutter/material.dart';
import '../app_config.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';

class UserSecond extends StatefulWidget{
  
  final User user;

  UserSecond({Key key, this.user}) : super(key: key);

  
  @override
  _UserSecond createState()=> _UserSecond();
  
}

class _UserSecond extends State<UserSecond>{
  final _user = User();
  final _formKey = GlobalKey<FormState>();
  

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldControllerAge1 = TextEditingController();
  TextEditingController _textFieldControllerAge2 = TextEditingController();
  TextEditingController _textFieldControllerAge3 = TextEditingController();
  bool _value1 = false;
  bool _value2 = false;
  String _selectedGender;
  String _selectedDependent;
  List<DropdownMenuItem> list = [];

  void _onChanged1(bool value) => setState(()
  {   
    _value1 = value; 
    
    if(value == false) {
      _selectedDependent = null;
      _user.dependents = '0';
      list = [];
      _textFieldControllerAge1.clear();
      _textFieldControllerAge2.clear();
      _textFieldControllerAge3.clear();
    }else{
      list = [
        DropdownMenuItem(value: "1", child:Text("1")),
        DropdownMenuItem(value: "2", child:Text("2")),
        DropdownMenuItem(value: "3", child:Text("3+")),
        //DropdownMenuItem(value: "4", child:Text("4")),
        //DropdownMenuItem(value: "5", child:Text("5+")),
        ];
    }
  
  });
  void _onChanged2(bool value) => setState((){ _value2 = value;  _textFieldController.text = ""; _user.spouseGender ='none'; });

  @override
  Widget build(BuildContext context) {
    //print(widget.user.email);
    var config = AppConfig.of(context);
    return Scaffold(
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
                                    child: SwitchListTile(
                                        value: _value2,
                                        onChanged: _onChanged2,
                                        title: new Text('¿Conyugue o Casado/a?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        activeColor: Color(0xFF9e946b),
                                    )
                                  ),
                                Container(
                                  
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                                  child: 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: 
                                      Container(
                                        padding: EdgeInsets.only(top:0),
                                        child: 
                                      SizedBox(
                                        width: 200,
                                      //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                        //style: Theme.of(context).textTheme.body2, //para cambiar el color del texto
                                        value: _selectedGender,
                                        hint: Text("Género"),
                                        validator:validateGender,
                                      items: getData() 
                                        .map<DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem<String>(
                                            value: value['value'].toString(),
                                            child: Text(value['name'].toString()),
                                          );
                                        })
                                        .toList(),
                                        onChanged: (value) {
                                            setState(() {
                                               _user.spouseGender = value;
                                              _selectedGender  = value;
                                            });
                                        }            
                                      ),
                                      ),
                                      ),
                                      ), 
                                      //SizedBox(width: 100.0,),
                        
                                      Flexible(
                                        child:
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                        child:
                                        SizedBox(
                                        width: 150,
                                        //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                        child:  TextFormField(
                                            keyboardType: TextInputType.number,
                                            enabled: _value2,
                                            decoration:InputDecoration(contentPadding: EdgeInsets.only(top:14), labelText: 'Edad'),
                                            validator: validateAge,
                                            controller: _textFieldController,
                                            onSaved: (val) {
                                                if (_value2 == false) val = '0'; 
                                                setState((){ 
                                                  _user.spouseAge = val;
                                                });
                                            }
                                        ),
                                        ),
                                        ),
                                      ),
                                      //SizedBox(width: 0.0,),
                                    ],
                                  ),
                                ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
                                    child: SwitchListTile(
                                        value: _value1,
                                        onChanged: _onChanged1,
                                        title: new Text('¿Dependientes?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        activeColor: Color(0xFF9e946b),
                                    )
                                  ),
                                  Container(
                                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                                        child: DropdownButtonFormField(
                                          //value: _selectedDependent,
                                          hint: Text("Cantidad de dependientes"),
                                          validator: (value) {
                                            //print(_selectedDependent);
                                            //if ( _value1 && _selectedDependent == null ) {
                                            if (value?.isEmpty ?? true && _value1) {
                                              return 'Selecciona la cantidad de dependientes';
                                            }
                                            return null;
                                          },
                                        items: list,
                                        onChanged:(changedValue) {
                                        
                                          setState(() {
                                              _selectedDependent=changedValue;
                                              _user.dependents = changedValue;
                                          });
                                        },
                                        value: _selectedDependent,  
                                        ),

                                ), 
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                            enabled: int.parse(_user.dependents) >= 1 ? true:false,
                                            validator: validateAgeDependent,
                                            controller: _textFieldControllerAge1,
                                            onSaved: (val) {
                                                if (_value1 == false) val = '0'; 
                                                setState((){ 
                                                 // _user.spouseAge = val;
                                                });
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(10),
                                                hintText: 'Edad 1',
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 20.0,),
                                      new Flexible(
                                        child: new TextFormField(
                                            enabled: int.parse(_user.dependents) >= 2 ? true:false,
                                            validator: validateAgeDependent,
                                            controller: _textFieldControllerAge2,
                                            onSaved: (val) {
                                                if (_value1 == false) val = '0'; 
                                                setState((){ 
                                                 // _user.spouseAge = val;
                                                });
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(10),
                                                hintText: 'Edad 2',
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 20.0,),
                                      new Flexible(
                                        child: new TextFormField(
                                            enabled: int.parse(_user.dependents) >= 3 ? true:false,
                                            validator: validateAgeDependent,
                                            controller: _textFieldControllerAge3,
                                            onSaved: (val) {
                                                if (_value1 == false) val = '0'; 
                                                setState((){ 
                                                 // _user.spouseAge = val;
                                                });
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(10),
                                                hintText: 'Edad 3',
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            //child: Text('Otra información'),
                            //child: Text("OR"),
                              // margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                              // child: Divider(
                              //   color: Color(0xFF9e946b),
                              //   height: 36,
                              // )
                            ),
                            //),
                          //),
                          Container(
                            height: 40,
                          //padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child:CheckboxListTile(
                              title: const Text('Maternidad'),
                              value: _user.maternity,
                              activeColor: Color(0xFF9e946b),
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
                              activeColor: Color(0xFF9e946b),
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
                              activeColor: Color(0xFF9e946b),
                              onChanged: (val) {
                                setState(() => _user.transplant = val);
                              }),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _user.save(context,widget.user).then((id) {
                                           print("Result: $id");
                                           if(id==null)
                                          _showDialog(context, 'Error');
                                          else
                                          _showDialog(context, 'Registro correcto...');
                                      } 
                                     
                                      
                                      );
                                      
                                      
       
                                      //saveUser(context, widget.user, _user)
                                      //print(widget.user.name);

                                    }
                                  },
                                  child: Text('Siguiente'))),
                        ]))))));
  }

  _showDialog(BuildContext context, text) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  String validateAge(String value) {
    if(_value2 == false) return null;
    Pattern pattern =r'^(?:[+0]9)?[0-9]{2}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || int.parse(value) <18 )
      return 'Coloca una edad válida';
    else
      return null;
  }

  String validateAgeDependent(String value) {
    if(_value1 == false) return null;
    Pattern pattern =r'^(?:[+0]9)?[0-9]{2}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Completa';
    else
      return null;
  }


  String validateGender(String value){
      if(_value2 == false) return null;
      if (value == null || value == '' ) {
        return 'Selecciona el género del conyugue';
      }
      return null;
    }
  

 getData(){
  if(_value2 == false) 
    return [];
  return [{"value":"male", "name":"Masculino"}, {"value":"female", "name":"Femenino"}];
  }
  
    saveUser(BuildContext context, user, _user) async{
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      var data = {
      "name": user.name,
      "last_name": user.lastName,
      "email": user.email,
      "gender": user.gender, 
      "country_id": user.countryId,
      "age": user.age,
      "spouse_gender": _user.spouseGender,
      "spouse_age": _user.spouseAge,
      "dependents": _user.dependents,
      "maternity": _user.info[User.InfoMaternity],
      "smoker": _user.info[User.InfoSmoker],
      "transplant": _user.info[User.InfoTransplant],
    };
    
      var response = await http.post(url+'v1/account', body: data);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
            
    }



}
