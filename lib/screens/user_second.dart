import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_contulting/components/TextFields/inputField.dart';
import '../app_config.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';


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
    final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  TextEditingController _textFieldController = TextEditingController();
  
  TextEditingController _textFieldControllerAge = TextEditingController();

  bool _value1 = false;
  bool _value2 = false;
  bool _btnEnabled = false;

  String _selectedGender;
  //String _selectedDependent;

  List<DropdownMenuItem> list = [];
  List<String> ages = [];

  int value = 0;

 
  bool _keyboardState;
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();

  @protected
  void initState() {
    super.initState();

    _keyboardState = _keyboardVisibility.isKeyboardVisible;

   _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
        });
      },
    );
  }

  void _onChanged1(bool value) => setState(()
  {   
    _value1 = value; 
    
    if(value == false) {
      //_selectedDependent = null;
      _user.dependents = '0';
      _textFieldControllerAge.clear();
      ages = [];
    }else{
      
    }
  
  });
  void _onChanged2(bool value) => setState((){ _value2 = value;  _textFieldController.text = ""; _user.spouseGender ='none'; });

  @override
  Widget build(BuildContext context) {
    //print(widget.user.email);
    var config = AppConfig.of(context);
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
                                    title: Text('COTIZAR', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    subtitle: Text('\nCompleta si deseas una cobertura familiar. Puedes agregar hasta 5 niños',
                                    style: TextStyle(fontSize: 15,height: 1.3),
                                    ),
                                    ),
                                  ),
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
                                          width: 170,
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                           
                                        //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                        child:  InputField(
                                            hintText: 'Edad',
                                            autovalidate: false,
                                            obscureText: false,
                                            bottomMargin: 0,
                                            icon: Icons.accessibility_new,
                                            keyboardType: TextInputType.number,
                                            enabled: _value2,
                                            //decoration:InputDecoration(contentPadding: EdgeInsets.only(top:14), labelText: 'Edad'),
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
                                      Flexible(
                                        child: 
                                      Container(
                                        padding: EdgeInsets.only(top:0),
                                        decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  Color(0xFF9e946b) ),
                                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            ),
                                          ),
                
                                      //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left:20, top: 13),
                                        prefixIcon: Icon(MdiIcons.genderMaleFemale), 
                                        enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                          )
                                        ),
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
                                      //SizedBox(width: 100.0,),
                                      //SizedBox(width: 0.0,),
                                    ],
                                  ),
                                ),
                                    Container(
                                      //padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
                                      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                                    child: SwitchListTile(
                                        value: _value1,
                                        onChanged: _onChanged1,
                                        title: new Text('¿Tiene niños?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        activeColor: Color(0xFF9e946b),
                                    )
                                  ),
                                  Container(
                                  padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                  margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: 
                                  Row(children: <Widget>[

                                    Flexible(
                                     
                                        child: InputField(
                                            //enabled: int.parse(_user.dependents) >= 1 ? true:false,
                                            hintText: 'Edad del niño/a',
                                            obscureText: false,
                                            bottomMargin: 20,
                                            icon: MdiIcons.humanChild,
                                            iconSuf: MdiIcons.plus,
                                            onPressedSuf: _btnEnabled==false || ages.length>4  ? null: _addItem,
                                            enabled: _value1 && ages.length<5,
                                            autovalidate: true,
                                            validator: validateAgeDependent,
                                            controller:_textFieldControllerAge,
                                            onChanged: (value) { 
                                              
                                              setState((){ 
                                                Pattern pattern =r'^(?:[+0]9)?[0-9]{1,2}$';
                                                RegExp regex = new RegExp(pattern);
                                                if (!regex.hasMatch(value) && value.isEmpty || ages.length>4)
                                                { 
                                                  _btnEnabled = false;
                                                }else{
                                                  _btnEnabled = true;
                                                }
                                                 //_user.spouseAge = val;
                                                 //_ageDependent = val;
                                                });
                                             },
                                            onSaved: (val) {
                                                if (_value1 == false) val = '0'; 
                                                setState((){ 
                                                 //_user.spouseAge = val;
                                                 //_ageDependent = val;
                                                });
                                            },
                                            keyboardType: TextInputType.number,
                                            
                                            // decoration: InputDecoration(
                                            //     //contentPadding: EdgeInsets.all(10),
                                            //     hintText: 'Edad del niño/a',
                                            //     suffixIcon: IconButton(
                                            //   icon: Icon(Icons.add),
                                            //   onPressed: _btnEnabled==false || ages.length>4  ? null: _addItem,
                                            //   ),
                                            // )
                                        ),
                                      ),
                                      SizedBox(width: 0),
                                        // Flexible(
                                        //   flex: 1,
                                        //   // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
                                        //   // child: FlatButton(
                                            
                                        //   //     // onPressed: () {
                                        //   //     //   if(_btnEnabled==true)
                                        //   //     //   _addItem();
                                        //   //     // },
                                        //   //     onPressed: _btnEnabled==false || ages.length>4  ? null: _addItem,
                                        //   //     child: Row( // Replace with a Row for horizontal icon + text
                                        //   //       children: <Widget>[
                                        //   //         Text(" Agregar " ),
                                        //   //         Icon(Icons.add_circle_outline),
                                        //   //       ],
                                        //   //     ),

                                        //   //   )
                                        //  child: Container(
                                        //         width: 160,
                                        //         margin: EdgeInsets.only(left: 0, top: 0),
                                        //         padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                        //         decoration: ShapeDecoration(
                                        //           shape: RoundedRectangleBorder(
                                        //             side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Color(0xFF9e946b) ),
                                        //             borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        //           ),
                                        //         ),
                                        //         child: FlatButton.icon(
                                        //           onPressed: _btnEnabled==false || ages.length>4  ? null: _addItem,
                                        //           icon: Icon(MdiIcons.plus, color:  Color(0xFF9e946b)), 
                                        //           label: Text('Agregar', 
                                        //           style: TextStyle(color: Colors.black),)),
                                        //     ),
                                        //   ),
                                        //   SizedBox(width: 0,),
                                            ],
                                          ),
                                  ),

                                              Container(
                                              //height: 80,
                                              //width: 130,
                                              padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                                              // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
                                              child: ListView.builder(
                                               
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: ages.length,
                                                itemBuilder: (BuildContext context, int index, ) {
                                                 return  Dismissible(
                                                    key: Key(ages.length.toString()),
                                                    onDismissed: (direction) {
                                                      setState(() {
                                                        ages.removeAt(index);
                                                      });
                                                    },
                                                child: Card(
                                                //width: 140,
                                               // height: 30,
                                               elevation: 3,
                                                //decoration: BoxDecoration(border: Border.all(width: 1.0)),

                                                 // padding: const EdgeInsets.all(8.0),
                                                     //decoration: BoxDecoration(color: Color(0xFF9e946b),),
                                                  child: Padding(
                                                  padding: const EdgeInsets.all(0.0),
                                                   child: _buildRow(index, ages ),
                                                  ),
                                                 ),
                                                );
                                                  
                                                  //return makeExpansion(lessons[index]);
                                                },
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
                          /*
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
                                      _user.dependentsAges = ages;
                                      print(_user);
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
                                  child: Text('Siguiente')
                                  )
                          ),
                          */
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
                                      _user.dependentsAges = ages;
                                      print(_user);
                                      _user.save(context,widget.user).then((id) {
                                           print("Result: $id");
                                           if(id==null)
                                          _showDialog2('Error', 5);
                                          
                                          else
                                          _showDialog2('Registro correcto...', 5);
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



  _addItem() {
    setState(() {
      value = value + 1;
      //_ageDependent = _textFieldControllerAge.text;
      ages.add(
        _textFieldControllerAge.text
      );
    });
  }

  _buildRow(int index, ages){
    if(index<5)
    {
      _btnEnabled = true;
      return _tile(" Niño "+ (index+1).toString(), ages[index].toString() + ' años', Icons.delete_sweep);
    }else{
      _btnEnabled = false;
      _textFieldControllerAge.text = '';
    }
  }

  //_buildRow(int index, ages) {
    //print(index);
    //return Text("Edad " + (index).toString()+': '+ages[index].toString(), style: TextStyle(fontSize: 15),);

    // return Row(  // Replace with a Row for horizontal icon + text
    //     children: <Widget>[
    //       Text(" Edad del niño/a " + (index+1).toString()+': '+ages[index].toString() + ' años', style: TextStyle(fontSize: 16),),
    //        Padding(
    //             padding: EdgeInsets.only(left: 130),
    //             child: Icon(Icons.delete_sweep)
    //         ),
    //     ],
    //   );
    //   _btnEnabled = false;
  //   return 


  //   FlatButton(

  //     color: Color(0xFF9e946b),
  //     onPressed: () {
  //        setState(() {
  //         ages.removeAt(index);
  //         });
  //     },
  //     //child: Text("Edad " + (index+1).toString()+': '+ages[index].toString(),)
  //     child: Row( // Replace with a Row for horizontal icon + text
  //       children: <Widget>[
  //         Icon(Icons.delete_forever),
  //         Text(" Edad " + (index+1).toString()+': '+ages[index].toString(),)
  //       ],
  //     ),
    
  //   );
  //}

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Color(0xFF9e946b),
      ),
    );

  _showDialog(context, text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
_showDialog2(text, tempo){
  _scaffoldstate.currentState.showSnackBar(
                  new SnackBar(
                      duration: new Duration(seconds: tempo),
                      content: new Text(text),
                   )
                   );
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

    if(_value1 == false) {_btnEnabled = false; return null;}
    Pattern pattern =r'^(?:[+0]9)?[0-9]{1,2}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
    { 
      _btnEnabled = false;
      return 'Coloca una edad válida';
    }
      
    else{
      _btnEnabled = true;
      return null;
    }
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
  
    saveUser(context, user, _user) async{
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
