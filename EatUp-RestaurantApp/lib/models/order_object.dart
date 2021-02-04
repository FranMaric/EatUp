import 'package:EatUpRestaurantApp/models/address_object.dart';
import 'package:EatUpRestaurantApp/models/meal_object.dart';
import 'dart:convert';

class Order {
  String userName;
  String phoneNumber;
  String userUid;
  Address address;
  String note;

  int userTimestamp;
  bool accepted;
  bool sent;

  List<Meal> meals;

  String documentID;

  Order();

  Order.fromJson(Map<String, dynamic> parsedJson)
      : userName = parsedJson['userName'],
        phoneNumber = parsedJson['phoneNumber'],
        userUid = parsedJson['userUid'],
        address = Address.fromJson(parsedJson['address']),
        note = parsedJson['note'],
        userTimestamp = parsedJson['userTimestamp'],
        accepted = parsedJson['accepted'],
        meals = List<Meal>.from(
            parsedJson['meals'].map((e) => Meal.fromJson(e)).toList()),
        documentID = parsedJson['documentID'],
        sent = parsedJson['sent'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'userUid': userUid,
        'address': address.toJson(),
        'note': note,
        'userTimestamp': userTimestamp,
        'accepted': accepted,
        'meals': json.encode(meals.map((meal) => meal.toJson()).toList()),
        'documentID': documentID,
        'sent': sent,
      };
}
