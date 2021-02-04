import 'package:flutter/material.dart';
import 'dart:async';

//Models
import 'package:EatUpRestaurantApp/models/order_object.dart';
import 'package:EatUpRestaurantApp/models/restaurant_object.dart';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Services
import 'package:flutter/services.dart';

class Data extends ChangeNotifier {
  List<Order> _incomingOrders = [];
  List<Order> _kitchenOrders = [];

  Restaurant restaurant;

  String uid;

  bool loading = false;

  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot> orderListener;

  //Getters
  List<Order> get incomingOrders => _incomingOrders;

  List<Order> get kitchenOrders => _kitchenOrders;

  //Functions

  void setActivity(bool value) async {
    if (restaurant.active == value) return;

    await Firestore.instance
        .collection('restaurants')
        .document(uid)
        .updateData({
      'active': value,
    }).then((v) {
      restaurant.active = value;
      notifyListeners();
    });
  }

  void setupOrderListener() {
    orderListener = Firestore.instance
        .collection('restaurants')
        .document(uid)
        .collection('orders')
        .snapshots()
        .listen(
      (event) {
        _incomingOrders = [];
        _kitchenOrders = [];

        for (DocumentSnapshot _docSnap in event.documents) {
          Order _order = Order.fromJson(
            _docSnap.data..addAll({'documentID': _docSnap.documentID}),
          );

          if (_order.accepted == null)
            _incomingOrders.add(_order);
          else if (_order.sent == false) _kitchenOrders.add(_order);
        }

        notifyListeners();
      },
    );
  }

  void getRestaurantData() async {
    DocumentSnapshot getResponse =
        await Firestore.instance.collection('restaurants').document(uid).get();

    restaurant = Restaurant.fromJson(getResponse.data);

    restaurant.uid = uid;
  }

  // void getRestaurantImage() async {
  //   String imageUrl = await FirebaseStorage.instance
  //       .ref()
  //       .child(uid)
  //       .child('profile.jpg')
  //       .getDownloadURL();

  //   ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");

  //   restaurant.image = imageData.buffer.asUint8List();
  // }

  Future<bool> setup() async {
    getRestaurantData();

    setupOrderListener();

    // getRestaurantImage();

    return true;
  }
}
