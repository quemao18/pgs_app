import 'dart:io';
import '../app_config.dart';
import 'dart:convert';


class User {
  //static const String InfoMaternity = 'false';
  static const bool InfoSmoker = false;
  static const bool InfoTransplant = false;
  static const bool InfoMaternity = false;

  String name = '';
  String lastName = '';
  String email = '';
  String gender = '';
  String countryId = '';
  String age = '0';
  String phone = '0';
  String spouseAge = '0';
  String spouseGender = 'none';
  String dependents = '0';
  String photo = '';
  List dependentsAges = [];
  bool maternity = false;
  bool smoker = false;
  bool transplant = false;

  Map info = {
    InfoMaternity: false,
    InfoSmoker: false,
    InfoTransplant: false
  };
  // bool newsletter = false;

  save(context, user, user2) async {
    print('saving user using a web service');

    var config = AppConfig.of(context);
    var url = config.apiBaseUrl;

    var data = {
      "name": user.name,
      "last_name": user.lastName,
      "username": user.email,
      "email": user.email,
      "photo": user.photo,
      "password":"",
      "user_type":4,
      "gender": user.gender, 
      "country_id": user.countryId,
      "age": int.parse(user.age),
      "spouse_gender": user2.spouseGender,
      "spouse_age": int.parse(user2.spouseAge),
      "dependents": user2.dependentsAges.length,
      "dependents_ages": user2.dependentsAges,
      "maternity": this.maternity ,
      "smoker": this.smoker ,
      "transplant": this.transplant 
    };

      //apiRequestPost(url+'v1/account', data);
       var res = (await apiRequestPost(url+'v1/account', data));
       //print(res);
        return res;
  }

  apiRequestPost(String url, Map jsonMap) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();

  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  //print(json.decode(reply)['result']);
  httpClient.close();
  if(response.statusCode == 200)
    return json.decode(reply)['result'] as String;

  }

}
