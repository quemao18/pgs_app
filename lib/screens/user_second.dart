import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_health/components/TextFields/inputField.dart';
import '../app_config.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


import 'drawer.dart';
import 'user_third.dart';

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
  // bool _btnEnabled = false;

  String _selectedGender;
  //String _selectedDependent;

  List<DropdownMenuItem> list = [];
  List<String> ages = [];

  int count = 0;

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
  void _onChanged2(bool value) => setState((){ 
    _value2 = value;  
    _textFieldController.text = ""; 
    _user.spouseGender ='none'; });

  @override
  Widget build(BuildContext context) {
    //print(widget.user.email);
    final ThemeData theme = Theme.of(context);  
    Size screenSize = MediaQuery.of(context).size;
    final FocusNode _nodeText1 = FocusNode();

    var config = AppConfig.of(context);
    return
    
     Scaffold(
      key: _scaffoldstate,
        appBar: new AppBar(
          title: new Text(config.appName),
        ),
        drawer: DrawerOnly(), 
        body: 
      // KeyboardActions(
      //   config:_buildConfig(context),
      //   child:
        SingleChildScrollView(
          child:
        
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Builder(
              
                builder: (context) => Form(
                    key: _formKey,
                    
                          child:
                         
                           Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    title: Text('COTIZAR', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    subtitle: Text('\nCompleta si deseas una cobertura familiar (Opcional).',
                                    style: TextStyle(fontSize: 15,height: 1.3),
                                    ),
                                    ),
                                  ),
                                Container(
                                    child: SwitchListTile(
                                        value: _value2,
                                        onChanged: _onChanged2,
                                        title: new Text('¿Cónyugue?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        activeColor: theme.primaryColor,
                                    )
                                  ),
                  
                                Container(
                                  
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                                  child: 
                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                            
                                    // Flexible(
                                        // child:
                                        Container(
                                          // width: 170,
                                          // height: 50,
                                          // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                                        child:  InputField(
                                            hintText: 'Edad',
                                            autovalidate: false,
                                            obscureText: false,
                                            bottomMargin: 0,
                                            icon: Icons.accessibility_new,
                                            keyboardType: TextInputType.number,
                                            // enabled: _value2,
                                            //decoration:InputDecoration(contentPadding: EdgeInsets.only(top:14), labelText: 'Edad'),
                                            validator: validateAge,
                                            controller: _textFieldController,
                                            onSaved: (val) {
                                                if (_value2 == false) val = '0'; 
                                                setState((){ 
                                                  _user.spouseAge = val;
                                                });
                                            },
                                            onChanged: (value ) {
                                              _value2 = true;
                                              if(int.parse(value) > 17) {
                                                FocusScope.of(context).requestFocus(new FocusNode()); 
                                              }
                                               
                                              },
                                        ),
                                        
                                        ),
                                        // SizedBox(height: 0,),
                                      // ),
                                      // Flexible(
                                        // child: 
                                      Container(
                                        // height: 56,
                                        // padding: EdgeInsets.only(top:0),
                                        margin: EdgeInsets.only(left: 0, top: 10),
                                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0.0),
                                        decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  theme.primaryColor ),
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
                                      // ),
                                   
                                      // SizedBox(height: 100.0,),
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
                                        title: new Text('¿Dependientes?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        activeColor: theme.primaryColor,
                                    )
                                  ),
                                  Container(
                                  padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                  margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: 
                                  Row(children: <Widget>[
                             
                                    Flexible(
                                    child:
                                    InputField(
                                            //enabled: int.parse(_user.dependents) >= 1 ? true:false,
                                            focusNode: _nodeText1,
                                            hintText: 'Edad',
                                            obscureText: false,
                                            bottomMargin: 20,
                                            icon: MdiIcons.humanChild,
                                            // iconSuf: MdiIcons.plus,
                                            // onPressedSuf: _btnEnabled==false || ages.length>4  ? null: _addItem,
                                            enabled: ages.length<5,
                                            autovalidate: true,
                                            validator: validateAgeDependent,
                                            controller:_textFieldControllerAge,
                                            onFieldSubmitted: (value){
                                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                                            Pattern pattern =r'^(?:[+0]9)?[0-9]{1,2}$';
                                            RegExp regex = new RegExp(pattern);
                                            var numValue = int.tryParse(value);
                                            if(numValue!=null)
                                            if (!regex.hasMatch(value) && value.isEmpty || ages.length>4 || numValue>23) return null;
                                              _addItem();
                                            },
                                            onChanged: (value) { 
                                              // print(value);
                                              // print(_keyboardState);
                                              _onChanged1(true);

                                              // setState((){ 
                                              //   Pattern pattern =r'^(?:[+0]9)?[0-9]{1,2}$';
                                              //   RegExp regex = new RegExp(pattern);
                                              //   var numValue = int.tryParse(value);
                                              //   if(numValue!=null)
                                              //   if (!regex.hasMatch(value) && value.isEmpty || ages.length>4 || numValue>23)
                                              //   { 
                                              //     _btnEnabled = false;
                                              //   }else{
                                              //     _btnEnabled = true;
                                                
                                              //   }
                                              //    //_user.spouseAge = val;
                                              //    //_ageDependent = val;
                                              //   });
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
                
                                            ],
                                          ),
                                  ),
                                      Container(
                                        width: screenSize.width/1.2,
                                        child:
                                        Text('Puedes agregar hasta 5 dependientes.', style: TextStyle(fontSize: 14, color: Colors.black38),),
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
                                                        if(ages.length==0)
                                                         _onChanged1(false);
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
                                                   child: _buildRow(index, ages, theme ),
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
                        
                        ),
                        // ),
                        ),
                        floatingActionButton:  
                        Visibility(child:                             
                        FloatingActionButton(
                          elevation: 10,
                           onPressed: (){   
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                    form.save();
                                    //print(widget.user.email);
                                    //_user.save();
                                    //_showDialog(context);
                                    _user.dependentsAges = ages;
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => UserThird(user: widget.user, user2: _user)
                                    ),
                                    );
                                    }
                                },
                                
                                child: Icon(Icons.navigate_next)//Text('Siguiente')
                        ),
                        visible:  !_keyboardState && (!_value1 || ages.length>0)
                    ),
                
                 
              );
  }



  _addItem() {
    if(_textFieldControllerAge.text!=''){
    setState(() {
      count = count + 1;
      //_ageDependent = _textFieldControllerAge.text;
      ages.add(
        _textFieldControllerAge.text
      );
      FocusScope.of(context).requestFocus(FocusNode());
    });
      // _textFieldControllerAge.text = '';
      WidgetsBinding.instance.addPostFrameCallback( (_) => _textFieldControllerAge.clear());

  }else{
  _textFieldControllerAge.text = '';
  }
  }

  _buildRow(int index, ages, theme){
    if(index<5)
    {
      // _btnEnabled = true;
      return _tile(" Niño "+ (index+1).toString(), ages[index].toString() + ' años', Icons.delete_sweep, theme);
    }else{
      // _btnEnabled = false;
      _textFieldControllerAge.text = '';
    }
  }

  ListTile _tile(String title, String subtitle, IconData icon, ThemeData theme) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color:theme.primaryColor,
      ),
    );


  String validateAge(String value) {
    if(_value2 == false) return null;
    Pattern pattern =r'^(?:[+0]9)?[0-9]{2}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || int.parse(value) <18 )
      return 'Coloca una edad válida';
    else
      return null;
  }

  String validateAgeDependent(value) {

    // if(_value1 == false) {_btnEnabled = false; return null;}
    Pattern pattern =r'^(?:[+0]9)?[0-9]{1,2}$';
    RegExp regex = new RegExp(pattern);
    // print(value);
    var numValue = int.tryParse(value);
    // _btnEnabled = false;
    // print(numValue);
    if(numValue!=null)
    if (!regex.hasMatch(value) && value!='' || numValue>23 )
    { 
      // _btnEnabled = false;
      return 'Coloca una edad válida, entre 0 y 23, luego presiona +';
    }
    else{
      // _btnEnabled = true;
      return null;
    }
    return null;
  }


  String validateGender(String value){
      if(_value2 == false) return null;
      if (value == null || value == '' ) {
        return 'Selecciona el género';
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
