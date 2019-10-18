class Lesson {
  String title;
  String level;
  double indicatorValue;
  double price;
  String content;
  Map<String, bool> plans;
  //List plans.price;

  Lesson(
      {this.title, this.level, this.indicatorValue, this.content, this.price, this.plans});
}

class Company {
  String name;
  String logo;
  List plans;
  List prices;

  Company(
      {this.name, this.logo, this.prices, this.plans});

  factory Company.fromJson(json) {

    return Company(
      name: json['comnpany_name'].toString(),
      logo: json['company_logo'].toString(),

    );
  }


}