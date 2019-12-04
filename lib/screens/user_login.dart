import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_health/components/Buttons/roundedButton.dart';
import 'package:pgs_health/screens/user_first.dart';
import '../app_config.dart';
import './progress_hud.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loading_animations/loading_animations.dart';

import 'user_data.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FacebookLogin _facebookLogin = FacebookLogin();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final databaseReference = Firestore.instance;

final _random = new Random();

int next(int min, int max) => min + _random.nextInt(max - min);

void main() {
  runApp(LoginPage(message: null,));
}

class UserLogged{
  String name = '';
  String email = '';
  String photo = '';
  // var userData;
}



class LoginPage extends StatefulWidget {
  final String message;
  
  LoginPage({Key key, this.message}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isLoadingApi = false;
  bool isConexion = true;
  bool existUser = false;
  var profileData;
  var userLogged ;
  var userData;
  final userFb = UserLogged();
  final userGoogle = UserLogged();
  // bool _success;
  // var _userID;
  String _message;
  // final TextEditingController _tokenController = TextEditingController();
  static List listImg = [
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen1.png?alt=media&token=7e207097-6292-434a-bdd4-336c5ac5e88f',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen2.png?alt=media&token=507976f1-f48f-40ce-ab9d-bb0c933ab908',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen3.png?alt=media&token=7bb9ab03-cee0-4126-a4da-03990b6c8819',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen4.png?alt=media&token=edf4579e-50f6-4a01-bebd-69128740be0c',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen5.png?alt=media&token=c31b40aa-9edf-4296-8fed-0663127bbf2c'
  ];
  List listTxt = [
    'No te ofrecemos una póliza, te damos razones para tenerla.',
    'El seguro no es un derecho, es un privilegio.',
    'Tu salud, tu vida y tu familia nos Importan.',
    'Imprescindible en tu camino es contar con nuestro respaldo.'
  ];

  String textShow;
  String imgShow;

  @protected
  initState(){
    // if(this.isLoggedIn)
    _saveDeviceToken();
    this.imgShow = listImg[_random.nextInt(listImg.length)];
    this.textShow = listTxt[_random.nextInt(listTxt.length)];
    _getCurrentUser();
    super.initState();
    this.userData = null;
    isLoading = true;
    this.isConexion = false;
    Future.delayed(Duration(milliseconds: 100), () {   
      // setState(() {
        // _getPlansUser(context);
        _checkConnection();
        if(this.isLoggedIn)
        this.userData =_getUserApi(context);

      // });
    });

    firebaseCloudMessagingListeners();
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.black, // navigation bar color
  //   statusBarColor: Colors.transparent, // status bar color
  // ));

  }


   onLoginStatusChanged(bool isLoggedIn, {profileData, userLogged}) {
    setState(() {
      isLoading = false;
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
      this.userLogged = userLogged;
      // userData =_getUserApi(context);
      //return UserFirst(userData: userLogged);
      // print(this.profileData);
    });
  //  UserFirst(userData: profileData);
  }

 Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      height: 40,
      width: 80,
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: const Color(0xFF696969),
        //     offset: Offset(1.0, 6.0),
        //     blurRadius: 0.001,
        //   ),
        // ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
  
  Future<bool> _onBackPressed() {
    // Navigator.of(context).pop(false);
        // Navigator.of(context).pushReplacementNamed('/login');
    final ThemeData theme = Theme.of(context);

    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('¿Estás seguro?'),
                content: new Text('¿Realmente quieres salir del app?'),
                actions: <Widget>[
                  new GestureDetector(
                    onTap: () => {
                      // widget.message == null ? 
                      Navigator.of(context).pop(false)
                      // Navigator.of(context).pushReplacementNamed('/login')
                      },
                    child: roundedButton("No", theme.primaryColor,
                        const Color(0xFFFFFFFF)),
                  ),
                  new GestureDetector(
                    onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                    child: roundedButton(" Si ", theme.primaryColor,
                        const Color(0xFFFFFFFF)),
                  ),
                ],
              ),
        ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return
    WillPopScope(
      onWillPop: 
        _onBackPressed,
        // return new Future.value(false);,
      child:
     Scaffold(
        key: _scaffoldstate,
        body:
        _home()
      )
      );
    
  }

  _home(){
    final Size screenSize = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Container(
            //padding:new EdgeInsets.symmetric(horizontal: 50, vertical: 50.0),
            //margin: ,
            child: 
            CachedNetworkImage(
                    imageUrl: this.imgShow,
                    imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                                // image: AssetImage("./assets/images/screen"+rand.toString()+".png"),
                                image: (imageProvider),
                                fit: BoxFit.cover,
                              ),
                            ),
                      child:  
                      BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: isLoading ? 
                                  Center(
                                  child: LoadingBouncingGrid.square(
                                    borderColor: theme.primaryColor,
                                    borderSize: 1.0,
                                    size: 70.0,
                                    backgroundColor: Colors.transparent,
                                    )
                                    // CircularProgressIndicator( 
                                    // valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF9e946b)),
                                    // ),
                                    )
                                    : Column( 
                                    children: <Widget>[
                                      // // SizedBox(height: 70,),
                                      // Align(
                                      // alignment: Alignment.center,
                                      // child: 
                                      //   Image( 
                                      //         color: Color(0xFF9e946b).withOpacity(1 ),
                                      //         image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                                      //         width: (screenSize.width < 500)
                                      //             ? 160.0
                                      //             : (screenSize.width / 4) + 12.0,
                                      //         height: screenSize.height / 5 + 0,
                                      //       )

                                      // ,),
                                      new Container( 
                                        margin:new EdgeInsets.only(top: screenSize.height/7, left: 5),
                                        child: 
                                        Image( 
                                              color: Color(0xFF9e946b).withOpacity(1 ),
                                              image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                                              width: (screenSize.width < 500)
                                                  ? 160.0
                                                  : (screenSize.width / 4) + 12.0,
                                              height: screenSize.height / 5 + 0,
                                            )
                                      ),
                                      
                                      widget.message == null ? 
                                      Container(padding: EdgeInsets.only(top:screenSize.height/15),):
                                      new Container(
                                      child: new Icon(Icons.check_circle_outline, color: Colors.lightGreen[500], size: 110.0,)
                                      ),
                                      Container(
                                        width: 280,
                                        // padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                      //  margin: EdgeInsets.only(bottom: 20),
                                        child: 
                                        widget.message == null ? ListTile(
                                        title: Text( isLoggedIn ? 'Hola '+this.userLogged.name.split(' ')[0] : 'Bienvenido', 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                                        textAlign: TextAlign.center,
                                        ),
                                        subtitle: Text('\n'+ this.textShow.toString(), style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.3),
                                        textAlign: TextAlign.center,
                                        ),
                                        ): 
                                        ListTile(
                                        title: Text( 'Gracias por preferirnos', 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                                        textAlign: TextAlign.center,
                                        ),
                                        subtitle: Text('\n'+ widget.message, style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.3),
                                        textAlign: TextAlign.center,
                                        ),
                                        ),

                                      ),

                                      Container(
                                      padding: widget.message == null ?  
                                      EdgeInsets.only(top: screenSize.height/7): EdgeInsets.only(top: screenSize.height/50),
                                      child: 
                                      
                                   FutureBuilder(
                                      future: this.userData,
                                      // initialData: this.userData,
                                      builder: (context, snapshot) {
                                      if (snapshot.hasData && this.isConexion && !isLoading) {
                                      if (snapshot.data != null) { 
                                      return
                                      Column(children: <Widget>[
                                      
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                          child:
                                            RoundedButton(
                                              buttonName: widget.message == null ? "Cotizar": "Cotizar nuevamente",
                                              onTap:  () {
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => UserFirst(userData: userLogged)
                                                          ),
                                                  );
                                              },
                                                  width: screenSize.width/2,
                                                  height: 50.0,
                                                  bottomMargin: 10.0,
                                                  borderWidth: 1.0,
                                                  //buttonColor: primaryColor,
                                                )
                                                
                                          ),
                                        existUser ? Align(
                                        alignment: Alignment.bottomCenter,
                                          child: 
                                            !isLoading ? RoundedButton(
                                              buttonName: "Mis Cotizaciones",
                                              onTap:  () {
                                                  // Navigator.of(context).pop();
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => UserData()
                                                          ),
                                                  );
                                              },
                                              width: screenSize.width/2,
                                              height: 50.0,
                                              bottomMargin: 10.0,
                                              borderWidth: 1.0,
                                              //buttonColor: primaryColor,
                                            ):
                                             CircularProgressIndicator(backgroundColor: theme.primaryColor),
                                        ): Container()

                                    

                                      ],);
                                        }
                                      }
                                      else if (snapshot.hasError || !this.isConexion) {
                                        // _showDialog2('Error de conexión...', 3);
                                        return  RoundedButton(
                                              buttonName: "Intentar de nuevo",
                                              onTap:  () {
                                                  // Navigator.of(context).pop();
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => LoginPage()
                                                          ),
                                                  );
                                              },
                                              width: screenSize.width/2,
                                              height: 50.0,
                                              bottomMargin: 10.0,
                                              borderWidth: 1.0,
                                              //buttonColor: primaryColor,
                                            ); 
                                    }else{
                         
                                      return 
                                      this.isLoggedIn ? Align(
                                        alignment: Alignment.bottomCenter,
                                          child:
                                            RoundedButton(
                                              buttonName: widget.message == null ? "Cotizar": "Cotizar nuevamente",
                                              onTap:  () {
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => UserFirst(userData: userLogged)
                                                          ),
                                                  );
                                              },
                                                  width: screenSize.width/2,
                                                  height: 50.0,
                                                  bottomMargin: 10.0,
                                                  borderWidth: 1.0,
                                                  //buttonColor: primaryColor,
                                                )
                                                
                                          ):
                                          Center(
                                              child: 
                                                  ProgressHUD(
                                                      child: _displayLoginButton(), inAsyncCall: isLoading),
                                              )
                                          ;
                                   
                                    }
                                        
                                     return  Center(
                                      child: Container(
                                        // padding: EdgeInsets.only(top: screenSize.height/3, left: screenSize.width/40),
                                        child: isConexion ? CircularProgressIndicator(backgroundColor: theme.primaryColor):
                                        RoundedButton(
                                              buttonName: "Intentar de nuevo",
                                              onTap:  () {
                                                  // Navigator.of(context).pop();
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => LoginPage()
                                                          ),
                                                  );
                                              },
                                              width: screenSize.width/2,
                                              height: 50.0,
                                              bottomMargin: 10.0,
                                              borderWidth: 1.0,
                                              //buttonColor: primaryColor,
                                            ) 
                                        )
                                      );
                                      
                                      
                                      
                                    },

                                    ),

                                  ),
                       
                                  widget.message !=null ? Container(
                                    width: 180,
                                    padding: EdgeInsets.only(top:screenSize.height/30),
                                    child: Center(
                                      child: 
                                      Text('Una póliza de salud. Garantía de sentirte protegido.',  textAlign: TextAlign.center,
                                      style: TextStyle(height: 1.3, fontSize: 15, color: Colors.white70, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                      ) ,
                                  ),
                                  ): Container(),
                                ],
                                ),
                            
                        ),

                      ),
                    
                    ),
            placeholder: (context, url) => 
                Center(child:       
                  new Container(
                  padding: EdgeInsets.only(top: screenSize.height/10),
                  child:
                  Column(children: <Widget>[
                  new Image(
                  image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                  width: (screenSize.width < 500)
                      ? 160.0
                      : (screenSize.width / 4) + 12.0,
                  height: screenSize.height / 4 + 0,
                  ),
                  LoadingBouncingGrid.square(
                  borderColor: theme.primaryColor,
                  borderSize: 1.0,
                  size: 70.0,
                  backgroundColor: Colors.transparent,
                  )
                  ],

                ),
                ),
                ),

                  errorWidget: (context, url, error) => Icon(Icons.error),
              )
             
                    
            //),
          );
  }

  // _loginButton(){
  //   return Container(
  //         child: Center(
  //           child: isLoggedIn
  //               ? _displayUserData(profileData)
  //               : ProgressHUD(
  //                   child: _displayLoginButton(), inAsyncCall: isLoading),
  //         ),
  //       );
  // }

  void initiateFacebookLogin() async {
    setState(() {
      isLoading = true;
    });

    var facebookLoginResult = await _facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        String token = facebookLoginResult.accessToken.token;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        //print(graphResponse.body);
        
        this.userFb.name =  profile['name'];
        this.userFb.email = profile['email'];
        this.userFb.photo = profile['picture']['data']['url'];

        _signInWithFacebook(token);
        onLoginStatusChanged(true, profileData: profile, userLogged: userFb);

        break;

    }
  }

    // Example code of how to sign in with google.
   void _signInWithGoogle() async {
     try{
         setState(() {
      isLoading = true;
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    // assert(user.email != null);
    assert(user.displayName != null);
    if(Platform.isIOS)
    assert(user.providerData[0].email != null);
    else
    assert(user.providerData[1].email != null);
  
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        isLoggedIn = true;
        // _success = true;
        // _userID = user.uid;
        this.userGoogle.name = user.displayName;
        this.userGoogle.email = user.email;
        this.userGoogle.photo = user.photoUrl;
        onLoginStatusChanged(true, profileData: user, userLogged: userGoogle);
      } else {
        isLoggedIn = false;
        // _success = false;
      }
    });
    } catch (error) {
   print(error.toString());
      return null;
    }
  }

  // Example code of how to sign in with Facebook.
  void _signInWithFacebook(token) async {

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: token
    );
    
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    if(user!=null)
    print(user);
    // if(user.email== null)
    if (Platform.isIOS)
    assert(user.providerData[0].email !=null);
    else
    assert(user.providerData[1].email !=null);
    // else
    // assert(user.providerData[0].displayName != null);
    // assert(user.providerData[0].email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in with Facebook. ' + user.uid;
      } else {
        _message = 'Failed to sign in with Facebook. ';
      }
    });
    print(_message);
  }

  /*_displayUserData(profileData) {
    return

       Column(
        children: <Widget>[
           Center(
            child:  Container(
              margin: EdgeInsets.only(top: 80.0,bottom: 70.0),
              height: 160.0,
              width: 160.0,
              decoration:  BoxDecoration(
                image:  DecorationImage(
                  image:  NetworkImage(
                    profileData['picture']['data']['url'],),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                    color: Colors.blue, width: 5.0),
                borderRadius:  BorderRadius.all(
                    const Radius.circular(80.0)),
              ),
            ),
          ),
          Text(
            "Logged in as: ${profileData['name']}",
            style:  TextStyle(
                color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),

        ],
      );
  }*/

  

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
    // print(user.providerData); 
    setState(() {
      if(user!=null){
        this.userGoogle.name = user.displayName;
        this.userGoogle.email = user.email;
        this.userGoogle.photo = user.photoUrl;
        isLoggedIn = true;
      }
      else
      isLoggedIn = false;
    });
    // print(this.userGoogle.email);
    this.userLogged = this.userGoogle;
    
  }

  _checkConnection() async{
        
    try {
    var config = AppConfig.of(context);
    var url = config.apiBaseUrl;
    // final result = await InternetAddress.lookup(url+'v1/');
    var res = await http.get(Uri.encodeFull(url+'v1/'), headers: {"Accept": "application/json"});
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    if(res.statusCode == 200){
      print('connected');
      setState(() {
      this.isConexion = true;
      isLoading = false;
      });
    }
    } on SocketException catch (_) {
    print('not connected');
    _showDialog2('Error de conexión...', 3);
    setState(() {
      this.isConexion = false;
      isLoading = false;
    });
    }

  }

  _getUserApi(BuildContext context) async{
    setState(() {
      isLoadingApi = true;
      isLoading = true;
    });
    // print(this.userLogged.email);
    try{
      var res2;
      var config = AppConfig.of(context);
      var url = config.apiBaseUrl;
      var res = await http.get(Uri.encodeFull(url+'v1/account/'+this.userLogged.email+'/email_logged'), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
      // print(resBody['msg']);
        if (res.statusCode == 200) {
          // this.userLogged.userData = resBody;
          setState(() {
            if(resBody[0] ==  null){
             this.isConexion = true;
            
             this.existUser = false; 
             res2 = null;
            }
            else
            if(resBody.length>0){
            res2 = resBody;
            this.existUser = true;
            }

            isLoadingApi = false;
            isLoading = false;
       
          });
        }else{
            setState(() {
              res2 = null;
             this.isConexion = false; 
             isLoadingApi = false;
             isLoading = false;
            });
        }
        // print(res2);
        return res2;
    }catch(_){
      print('error');
      setState(() {
        isLoading = false;
      });
      // _showDialog2('Error de conexión', 3);
    }

  }

  _displayLoginButton() {
    // final Size screenSize = MediaQuery.of(context).size;
        return Column(children: <Widget>[
      
              Container(
                  width: 210,
                  margin: EdgeInsets.only(left: 0, top: 0),
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  Colors.white ),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  child: FlatButton.icon(onPressed: initiateFacebookLogin, icon: Icon(MdiIcons.facebook, color: Colors.white), label: Text('Entrar con Facebook', style: TextStyle(color: Colors.white),)),
              ),
              Container(
                  width: 210,
                  margin: EdgeInsets.only(left: 0, top: 10),
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color:  Colors.white ),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  child: FlatButton.icon(onPressed: _signInWithGoogle, icon: Icon(MdiIcons.google, color: Colors.white), label: Text('Entrar con Google', style: TextStyle(color: Colors.white),)),
              ),
            
    ],
    
    );

  }

  void firebaseCloudMessagingListeners() {
  if (Platform.isIOS) iOSPermission();

  _firebaseMessaging.getToken().then((token){
    print(token);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
       showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
       );
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

void iOSPermission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });
}

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    // String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();
    // final FirebaseUser currentUser = await _auth.currentUser();
    // Get the token for this device
    try{
    String fcmToken = await _firebaseMessaging.getToken();
    // print(this.userLogged.email);
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = databaseReference
          .collection('users')
          .document(this.userLogged.email)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
    }catch(e){
      print(e.toString());
      print('error save data base firebase');
    }
  }


}
