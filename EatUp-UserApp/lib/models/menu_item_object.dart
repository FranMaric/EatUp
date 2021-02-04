import 'package:EatUpUserApp/models/meal_object.dart';

class MenuItem {
  String name;
  String image;
  List<Meal> meals;

  MenuItem({this.image, this.meals, this.name});
}
