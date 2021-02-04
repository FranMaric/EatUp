import 'package:EatUpUserApp/services/database.dart';
import 'package:flutter/material.dart';

//Objects
import 'package:EatUpUserApp/models/address_object.dart';
import 'package:EatUpUserApp/models/meal_object.dart';
import 'package:EatUpUserApp/models/user_object.dart';

//Provider
import 'package:EatUpUserApp/services/authservice.dart';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Screens
import 'package:EatUpUserApp/screens/ban_screen.dart';
import 'package:provider/provider.dart';

class Order extends ChangeNotifier {
  List<Meal> meals = [];
  List<int> quantity = [];

  String restaurantName;
  String restaurantUid;

  int timestamp;
  String note;

  String userName;
  String userUid;
  String phoneNumber;

  get total {
    double _total = 0;
    for (int i = 0; i < meals.length; i++) {
      _total += meals[i].price * quantity[i];
    }
    return _total;
  }

  void reset() {
    meals = [];
    quantity = [];
  }

  void changeMealState(Meal meal, int amount) {
    if (meals.contains(meal)) {
      if (amount < 0 && quantity[meals.indexOf(meal)] > 1)
        quantity[meals.indexOf(meal)] += amount;
      else if (amount < 0) {
        int index = meals.indexOf(meal);
        quantity.removeAt(index);
        meals.removeAt(index);
      } else if (amount > 0) {
        quantity[meals.indexOf(meal)] += amount;
      }
    } else {
      meals.add(meal);
      quantity.add(1);
    }
    notifyListeners();
  }

  Map _getOrder(Address address) {
    return <String, dynamic>{
      'userName': userName,
      'userUid': userUid,
      'address': address.toJson(),
      'meals': meals
          .map((meal) => meal.toObject(quantity[meals.indexOf(meal)]))
          .toList(),
      'userTimestamp': timestamp,
      'note': note,
      'phoneNumber': phoneNumber,
      'accepted': null,
      'sent': null,
      'restaurantUid': restaurantUid,
    };
  }

  Future<bool> makeAnOrder(BuildContext context, User user) async {
    try {
      timestamp = DateTime.now().millisecondsSinceEpoch;

      //TODO: Bring this back in production code
      // if (timestamp - user.lastOrderTimestamp < newOrderAfter) {
      //   return false;
      // }

      DocumentSnapshot restaurantData = await Firestore.instance
          .collection('restaurants')
          .document(restaurantUid)
          .get();

      //If restaurant isn't active/working you can't order from them LoGiC
      if ([null, false, 'false'].contains(restaurantData.data['active']))
        return false;

      userName = user.name;
      userUid = user.uid;
      phoneNumber = user.phoneNumber;

      DocumentSnapshot userData =
          await Firestore.instance.collection('users').document(userUid).get();

      //If you are banned fuck OFF
      if (userData.data['banned'] == true) {
        AuthService().signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BannedScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        return false;
      }

      Map<String, dynamic> order = _getOrder(
          user.addresses[user.favAddress]); //Get the order object (data)

      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(
                Firestore.instance
                    .collection('restaurants')
                    .document(restaurantUid)
                    .collection('orders')
                    .document(),
                order)
            .catchError((e) {
          print('Imamo problem: ' + e);
          return false;
        }).whenComplete(() {});
      }).catchError((e) {
        return false;
      });

      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({'lastOrderTimestamp': timestamp});

      Provider.of<Data>(context, listen: false).user.lastOrderTimestamp =
          timestamp;
    } catch (e) {
      print('This is low level error: ' + e.toString());
      return false;
    }
    reset();
    return true;
  }
}
