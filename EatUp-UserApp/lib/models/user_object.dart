import 'package:EatUpUserApp/models/address_object.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String phoneNumber;
  String uid;
  int favAddress;
  int lastOrderTimestamp;

  List<Address> addresses = [];
  List processedOrders = [];
  List waitingOrders = [];

  User({
    this.addresses,
    this.favAddress,
    this.name,
    this.phoneNumber,
    this.uid,
    this.lastOrderTimestamp,
  });

  void setupFromFirestore(Map<String, Object> value) {
    name = value['name'] ?? '';
    lastOrderTimestamp = value['lastOrderTimestamp'] ?? 0;

    favAddress = value['favAddress'] ?? 0;
    addresses = [];

    for (var address in value['addresses']) {
      addresses.add(
        Address(
          street: address['street'],
          houseNumber: address['houseNumber'],
          area: address['area'],
          building: address['building'],
          level: address['level'],
          surname: address['surname'],
        ),
      );
    }
  }

  void setupFromFirstTimeLoginScreen(Map<String, Object> value) {
    name = value['name'];
    favAddress = value['favAddress'];
    addresses = [];
    lastOrderTimestamp = value['lastOrderTimestamp'];
    phoneNumber = value['phoneNumber'];

    for (var address in value['addresses']) {
      addresses.add(
        Address(
          street: address['street'],
          houseNumber: address['houseNumber'],
          area: address['area'],
          building: address['building'],
          level: address['level'],
        ),
      );
    }
  }
}
