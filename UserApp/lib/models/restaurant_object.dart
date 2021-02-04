import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

//Objects
import 'package:EatUpUserApp/models/meal_object.dart';
import 'package:EatUpUserApp/models/menu_item_object.dart';

class Restaurant {
  String name;
  String description;
  String area;

  String imageUrl;
  String uid;

  bool active;

  List<MenuItem> menu;

  Uint8List image;

  Restaurant(DocumentSnapshot document) {
    uid = document.documentID;

    name = document.data['name'];
    area = document.data['area'];
    description = document.data['description'];
    active = document.data['active'];
    menu = [];

    for (Map menuItem in document.data['menu']) {
      List<Meal> meals = [];
      for (Map meal in menuItem['meals']) {
        meals.add(
          Meal(
            name: meal['name'],
            description: meal['description'],
            price: toNumber(meal['price']),
          ),
        );
      }
      menu.add(MenuItem(
        image: menuItem['image'],
        name: menuItem['name'],
        meals: meals,
      ));
    }
  }
}

double toNumber(dynamic num) {
  if (num is double) {
    return num;
  } else if (num is int) {
    return num.toDouble();
  } else if (num is String) {
    try {
      return double.parse(num);
    } catch (e) {
      print('Invalid input');

      return 0.0;
    }
  } else {
    return 0.0;
  }
}
