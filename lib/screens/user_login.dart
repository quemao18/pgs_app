import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pgs_contulting/components/Buttons/roundedButton.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:pgs_contulting/screens/drawer.dart';
import 'package:pgs_contulting/screens/user_first.dart';
import '../app_config.dart';
import './progress_hud.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loading_animations/loading_animations.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

final _random = new Random();

int next(int min, int max) => min + _random.nextInt(max - min);

void main() {
  runApp(LoginPage());
}

class UserLogged{
  String name = '';
  String email = '';
  String photo = '';
}



class LoginPage extends StatefulWidget {
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  bool isLoading = false;
  var profileData;
  var userLogged;
  final userFb = UserLogged();
  final userGoogle = UserLogged();
  bool _success;
  var _userID;
  String _message;
  final TextEditingController _tokenController = TextEditingController();
  List listImg = [
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen1.png?alt=media&token=7e207097-6292-434a-bdd4-336c5ac5e88f',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen2.png?alt=media&token=507976f1-f48f-40ce-ab9d-bb0c933ab908',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen3.png?alt=media&token=7bb9ab03-cee0-4126-a4da-03990b6c8819',
  'https://firebasestorage.googleapis.com/v0/b/pgs-consulting.appspot.com/o/pgs_assets%2Fimages%2Fscreen4.png?alt=media&token=edf4579e-50f6-4a01-bebd-69128740be0c'
  ];
  List textIni = [
    'No te vendemos una poliza... Te damos razones para tenerla.',
    'Cotiza el mejor plan que se adapte a tus necesidades.',
    'Que tu ausencia no afecte el futuro de tu familia.',
    'Imprescindible en tu camino es contar con nuestro respaldo.'
  ];
  int rand = next(0, 3);
  int randText = next(0, 3);
  var facebookLogin = FacebookLogin();

   onLoginStatusChanged(bool isLoggedIn, {profileData, userLogged}) {
    setState(() {
      isLoading = false;
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
      this.userLogged = userLogged;
      //return UserFirst(userData: userLogged);
      print(this.profileData);
    });
   UserFirst(userData: profileData);
  }

  @override
  Widget build(BuildContext context) {
    //var config = AppConfig.of(context);

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "Facebook Login",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(
        //         Icons.exit_to_app,
        //         color: Colors.white,
        //       ),
        //       onPressed: () => facebookLogin.isLoggedIn
        //           .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
        //     ),
        //   ],
        // ),
        //  appBar: new AppBar(
        //   title: new Text(config.appName),
        //   actions: isLoggedIn==true ? <Widget>[
        //     IconButton(
        //       icon: Icon(
        //         Icons.exit_to_app,
        //         color: Colors.white,
        //       ),
        //       onPressed: () => facebookLogin.isLoggedIn
        //           .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
        //     ),
        //   ]:null,
        // )
        // ,
        drawer: DrawerOnly(),
        body:
        _home()
      );
    
  }

  _home(){
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
            //padding:new EdgeInsets.symmetric(horizontal: 50, vertical: 50.0),
            //margin: ,
            child: 
            CachedNetworkImage(
                    imageUrl: listImg[rand],
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
                                    borderColor: Color(0xFF9e946b),
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

                                      new Center(
                                        child: new Image(
                                        image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                                        width: (screenSize.width < 500)
                                            ? 250.0
                                            : (screenSize.width / 4) + 12.0,
                                        height: screenSize.height / 4 + 100,
                                        )
                                      ),
                                      Container(
                                        width: 280,
                                        padding:new EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                       // margin: EdgeInsets.only(top: 0),
                                        child: 
                                        ListTile(
                                        title: Text( isLoggedIn ? 'Hola '+this.userLogged.name.split(' ')[0] : 'Bienvenido', 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, height: 1),
                                        textAlign: TextAlign.center,
                                        ),
                                        subtitle: Text('\n'+textIni[randText].toString(), style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.3),
                                        textAlign: TextAlign.center,
                                        ),
                                        ),
                                      ),

                                      Container(
                                      padding:new EdgeInsets.only(top: screenSize.height/5),
                                      child: 
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                          child: this.isLoggedIn==true ?
                                          // RaisedButton(
                                          //   onPressed: () {
                                          //   Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //           builder: (context) => UserFirst(userData: userLogged)
                                          //           ),
                                          //       );
                                          //   },
                                          //   child: Text('Cotizar')
                                          //   )
                                            RoundedButton(
                                              buttonName: "Cotizar",
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
                                            :
                                          Center(
                                          child: //isLoggedIn
                                              //? _displayUserData(profileData)
                                              //: 
                                              ProgressHUD(
                                                  child: _displayLoginButton(), inAsyncCall: isLoading),
                                        ),
                                        
                                      ),
                                      ),

                                    ],
                                    ),
                                
                        ),

                      ),
                    
                    ),
            placeholder: (context, url) =>       
                          new Center(
                          
                          child:
                          Column(children: <Widget>[
                          new Image(
                          image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
                          width: (screenSize.width < 500)
                              ? 250.0
                              : (screenSize.width / 4) + 12.0,
                          height: screenSize.height / 4 + 100,
                          ),
                          LoadingBouncingGrid.square(
                          borderColor: Color(0xFF9e946b),
                          borderSize: 1.0,
                          size: 70.0,
                          backgroundColor: Colors.transparent,
                          )
                          ],

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

    var facebookLoginResult =
        await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        //print(graphResponse.body);
        _tokenController.text = facebookLoginResult.accessToken.token;
        this.userFb.name =  profile['name'];
        this.userFb.email = profile['email'];
        this.userFb.photo = profile['picture']['data']['url'];

        onLoginStatusChanged(true, profileData: profile, userLogged: userFb);
        _signInWithFacebook();
        break;

    }
  }

    // Example code of how to sign in with google.
   void _signInWithGoogle() async {
         setState(() {
      isLoading = true;
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        this.userGoogle.name = user.displayName;
        this.userGoogle.email = user.email;
        this.userGoogle.photo = user.photoUrl;
        onLoginStatusChanged(true, profileData: user, userLogged: userGoogle);
      } else {
        _success = false;
      }
    });
  }

  // Example code of how to sign in with Facebook.
  void _signInWithFacebook() async {
    //_googleSignIn.signOut();
    //_auth.signOut();
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: _tokenController.text,
    );
    
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email !=null);
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

  _displayLoginButton() {
    // final Size screenSize = MediaQuery.of(context).size;
        return Column(children: <Widget>[
              // RaisedButton(
              //   child: Text(
              //     "Iniciar sesión con Facebook",
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   //color: Colors.blue,
              //   onPressed: () => initiateFacebookLogin(),
              //   //onPressed: () => _signInWithFacebook(),
              // ),
              // RaisedButton(
              //     child: Text(
              //       "Iniciar sesión con Google",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     //color: Colors.blue,
              //     onPressed: () => _signInWithGoogle(),
              //     //onPressed: () => _signInWithFacebook(),
              //   ),
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
              // RoundedButton(
              //   buttonName: "Iniciar sesión con Facebook",
              //   onTap:  initiateFacebookLogin,
              //   width: screenSize.width/1.4,
              //   height: 50.0,
              //   bottomMargin: 10.0,
              //   borderWidth: 1.0,
              //   //buttonColor: primaryColor,
              // ),

              // RoundedButton(
              //   buttonName: "Iniciar sesión con Google",
              //   onTap:  _signInWithGoogle,
              //   width: screenSize.width/1.4,
              //   height: 50.0,
              //   bottomMargin: 10.0,
              //   borderWidth: 1.0,
              //   //buttonColor: primaryColor,
              // ),

    ],
    
    );

  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
    _auth.signOut();
    _googleSignIn.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
