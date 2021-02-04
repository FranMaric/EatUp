import 'dart:typed_data';

import 'package:EatUpUserApp/models/address_object.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//Screens
import 'package:EatUpUserApp/screens/ban_screen.dart';

//Services
import 'package:EatUpUserApp/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Abstract objects
import 'package:EatUpUserApp/models/user_object.dart';
import 'package:EatUpUserApp/models/restaurant_object.dart';
import 'package:flutter/services.dart';

class Data extends ChangeNotifier {
  List<Restaurant> restaurants = [];

  User user;

  String area;

  int selectedDescription;

  bool loading = false;
  bool restaurantsLoaded = false;

  void saveUser(FirebaseUser newUser) {
    user = User(
      phoneNumber: newUser.phoneNumber,
      uid: newUser.uid,
    );
  }

  void setLoading(bool newValue) {
    loading = newValue;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  void removeAddress(int index) {
    if (user.addresses.length == 1) return;

    if (user.addresses.length - 1 <= user.favAddress) {
      user.favAddress = 0;
      area = user.addresses[user.favAddress].area;
      getRestaurants();
    }

    Firestore.instance.collection('users').document(user.uid).updateData({
      'addresses': FieldValue.arrayRemove([user.addresses[index].toJson()]),
      'favAddress': user.favAddress,
    }).then((value) {
      user.addresses.removeAt(index);

      notifyListeners();
    });
  }

  void addAddress(Address address, bool setItToFavoriteAddress) {
    Firestore.instance.collection('users').document(user.uid).updateData(
      {
        'addresses': FieldValue.arrayUnion([address.toJson()]),
      },
    ).then((value) {
      user.addresses.add(address);
      if (setItToFavoriteAddress == true) newFavAddress(address);
      notifyListeners();
    });
  }

  void newFavAddress(Address newAddress) {
    if (user.addresses.indexOf(newAddress) == user.favAddress) return;

    user.favAddress = user.addresses.indexOf(newAddress);

    if (area == newAddress.area) {
      notifyListeners();
      return;
    }

    Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'favAddress': user.favAddress});

    area = newAddress.area;

    getRestaurants();
    notifyListeners();
  }

  Future<bool> getOrders() async {
    user.processedOrders = [];
    user.waitingOrders = [];

    DocumentSnapshot getResponse = await Firestore.instance
        .collection('order-history')
        .document(user.uid)
        .get();

    if (!getResponse.exists) {
      return false;
    }

    try {
      user.processedOrders = getResponse.data['processed'];
      user.waitingOrders = getResponse.data['waiting'];
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void getRestaurants() async {
    await Firestore.instance
        .collection('restaurants')
        .where('area', isEqualTo: area)
        .getDocuments()
        .then(
      (value) async {
        restaurants = [];
        for (DocumentSnapshot rest in value.documents) {
          restaurants.add(Restaurant(rest));
        }
        restaurantsLoaded = true;

        // notifyListeners();

        for (int i = 0; i < restaurants.length; i++) {
          await downloadRestaurantImage(restaurants[i]);
        }

        notifyListeners(); //Notify listeners
      },
    ).catchError((error) {
      restaurantsLoaded = true;
      notifyListeners(); //Notify listeners

      print(error);
    });
  }

  Future<bool> downloadRestaurantImage(Restaurant restaurant) async {
    int index = restaurants.indexOf(restaurant);

    try {
      String imageUrl = await FirebaseStorage.instance
          .ref()
          .child(restaurants[index].uid)
          .child('profile.jpg')
          .getDownloadURL();

      ByteData imageData =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
      restaurants[index].image = imageData.buffer.asUint8List();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIfNewUser(BuildContext context) async {
    DocumentSnapshot value =
        await Firestore.instance.collection('users').document(user.uid).get();

    if (value.data == null) {
      return true;
    } else if (value.data['banned'] == true) {
      AuthService().signOut(); //Sign out and leave the screen

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BannedScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      user.setupFromFirestore(value.data);
      if (user.addresses.length == 0) {
        return true;
      } else {
        try {
          area = user.addresses[user.favAddress].area;
        } catch (e) {
          area = user.addresses[0].area;
        }
        getRestaurants();
        return false;
      }
    }
    getRestaurants();
    return false;
  }
}
