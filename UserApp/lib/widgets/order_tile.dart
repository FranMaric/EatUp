import 'package:EatUpUserApp/models/meal_object.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final Meal meal;
  final int quantity;

  OrderTile({this.meal, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        title: Text(
          meal.name,
        ),
        trailing: Text(meal.price.toString() + ' kn x' + quantity.toString()),
      ),
    );
  }
}
