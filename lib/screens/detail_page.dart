
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final data;
  DetailPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;

    // final levelIndicator = Container(
    //   child: Container(
    //     child: LinearProgressIndicator(
    //         // backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
    //         // value: lesson.indicatorValue,
    //         // valueColor: AlwaysStoppedAnimation(Colors.green)
    //         ),
    //   ),
    // );

    // final coursePrice = Container(
    //   padding: const EdgeInsets.all(7.0),
    //   decoration: new BoxDecoration(
    //       border: new Border.all(color: Colors.white),
    //       borderRadius: BorderRadius.circular(5.0)),
    //   child: new Text(
    //     // "\$20",
    //     "\$",
    //     style: TextStyle(),
    //   ),
    // );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 55.0),
        Icon(
          Icons.person,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        ListTile(
          title: Text(data['name'],
          style: TextStyle(color: Colors.white, fontSize: 30.0)
          ),
          subtitle: Text( data['email'] +'\n'+ data['age'].toString() + ' años.',
          style: TextStyle(color: Colors.white, fontSize: 16, height: 1.2),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: _buildAge(context, data, theme)
                  
                  )),
            // Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[

        Container(
          // height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(30.0),
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: theme.primaryColor),
          child: topContentText
        ),
        Positioned(
          left: 8.0,
          top: 50.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Positioned(
          left: screenSize.width/1.7,
          top: 50,
          child: 
          Image( color: Colors.white70,
          image: AssetImage('./assets/images/logos/Sin-fondo-(4).png'),
          width: (screenSize.width < 500)
              ? 160.0
              : (screenSize.width / 4) + 12.0,
          height: screenSize.height/10 + 0,
          ),
        ),
      ],
    );

    final bottomContentText = Text(
      'Planes cotizados',
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
    );

    // final readButton = Container(
    //     padding: EdgeInsets.symmetric(vertical: 16.0),
    //     width: MediaQuery.of(context).size.width,
    //     child: RaisedButton(
    //       onPressed: () => {},
    //       color: Color.fromRGBO(58, 66, 86, 1.0),
    //       child:
    //           Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
    //     ));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: 30),
      child: Container(
        child: Column(
          children: <Widget>[
            bottomContentText,
            SizedBox(height: 20,),
            _builPlans(context, data['plans'], theme), 
            // readButton
            ],
        ),
      ),
    );

    return Scaffold(
      body: 
      SingleChildScrollView(
          child:
          Column(
            children: <Widget>[topContent, bottomContent],
          ),
        )
    );
  }

    Widget _buildAge(BuildContext context, data, theme) {
    String gender = data['spouse_gender'] == 'female' ? '(Mujer).\n': data['spouse_gender'] == 'male' ? '(Hombre).\n' : '';  
    // String age = data['age'].toString() + ' años. ';
    String spouse = data['spouse_age']!=null && data['spouse_age']>0 ? ' Conyugue: '+ data['spouse_age'].toString() + ' años ': '';
    String dependents = data['dependents']!=null && data['dependents']>0 ? ' Dependientes: '+ data['dependents'].toString() + '.': '';
    return spouse!='' || dependents!='' ? Container(
      // padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      // decoration: BoxDecoration(
      //   // color: theme.primaryColor,
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      child: Text(
        spouse + gender + dependents,
        style: TextStyle(
          // fontFamily: 'Spectral',
          color: Colors.white,
          fontSize: 15.0,
          height: 1.2,
          fontWeight: FontWeight.w300,
        ),
      ),
    ):null;
  }

  Widget _builPlans(context, plans, theme) {
  var children = <Widget>[];
  var childrenRev = <Widget>[];
  // print(plans);
  final formatter = NumberFormat("#,###.##");
  String priceUser = '';
  String priceSpouse = '';
  String priceDependents = '';
  String deductible = '';
  String transplant = '';
  String maternity = '';
  String costAdmin = '';
  double total = 0.0;
  for(var plan in plans){
  String date ='';

  total = 0.0; priceUser = ''; priceSpouse = ''; priceDependents = ''; deductible = ''; transplant = ''; maternity =''; costAdmin='';
    // print(plan)
  if(plan['option_prices'].length>0)
  priceUser = plan['option_prices'][0]!=null && plan['option_prices'][0] > 0 ? 'Precio USD ' + formatter.format(plan['option_prices'][0]).toString():'';
  if(plan['option_prices'].length>1)
  priceSpouse = plan['option_prices'][1]!=null && plan['option_prices'][1] >0 ? 'Precio Conyugue USD ' + formatter.format(plan['option_prices'][1]).toString():'';
  if(plan['option_prices'].length>2)
  priceDependents = plan['option_prices'][2]!=null && plan['option_prices'][2] > 0 ? 'Precio Dependientes USD ' + formatter.format(plan['option_prices'][2]).toString():'';

  deductible = plan ['deductible']!=null ? 'Deducible USD ' + formatter.format(plan['deductible']) : ''; 
  maternity = plan ['maternity']!=null && plan['maternity'] >0 ? 'Complicaciones por maternidad USD ' + formatter.format(plan['maternity']) : '';
  transplant = plan ['transplant']!=null && plan ['transplant'] >0 ? 'Transplante de organos USD ' + formatter.format(plan['transplant']) : ''; 
  costAdmin = plan ['cost_admin']!=null && plan ['cost_admin'] >0 ? 'Costos administrativos USD ' + formatter.format(plan['cost_admin']) : '';


  if(plan['option_prices'].length>0)
    for(var price in plan['option_prices']) 
      total += price;
  
  total = total + plan['maternity'] + plan['transplant'] + plan['cost_admin'];

  // print(total);
  // if(plan['option_prices'].length>0)
    children.add(
      Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.primaryColor)
        ),
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),  
        child: 
        ExpansionTile(
        title: 
        ListTile(

          trailing: 
          
              Text('USD '+formatter.format(total).toString()+'\n'+date.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),) ,
          
          leading:    
          Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          child: 
          CachedNetworkImage(
              height: 35, width: 35,
              imageUrl: plan['company_logo'],
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.image),
          ),
          ),
          title:Text(plan['company_name'],
            style: TextStyle(fontWeight: FontWeight.bold)
            ), 
            subtitle: Text(plan['plan_name'],
            style: TextStyle(height: 1.3, fontSize: 12)
            ),
            ),
            children: <Widget>[
             
            Container(
              margin: EdgeInsets.all(10),
              child: 
              Column(children: <Widget>[
                 
                priceUser !='' ? Text(
                    priceUser,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 priceSpouse != '' ? Text(
                    priceSpouse,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 priceDependents !='' ? Text(
                    priceDependents,
                    style: TextStyle(height: 1.5,)
                  ):Container(),
                  
                 Text(
                    deductible,
                    style: TextStyle(height: 1.5,)
                  ),
                  
                  maternity !='' ? Text(
                    maternity,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 transplant !='' ? Text(
                    transplant,
                    style: TextStyle(height: 1.5,)
                  ):Container(),

                 costAdmin !='' ? Text(
                    costAdmin,
                    style: TextStyle(height: 1.5,)
                  ):Container(),
              ],)
            
            ,),




          ],
      ), 
    )
    );
    
  } //end for plans
  // print(children.length);
  childrenRev = children.reversed.toList();
  // print(childrenRev.length);

    return 
    Container(           
      child: Column(children: childrenRev),
      );

 
  }

}