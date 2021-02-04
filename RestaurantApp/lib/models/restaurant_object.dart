import 'dart:typed_data';

class Restaurant {
  String name;
  String description;
  String area;

  String uid;

  bool active;

  Uint8List image;

  Restaurant.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        area = json['area'],
        active = json['active'];
}
