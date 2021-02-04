class Address {
  String area;
  int level;
  String street;
  String surname;
  String houseNumber;
  bool building;

  Address();

  Address.fromJson(Map<String, dynamic> json)
      : area = json['area'],
        level = json['level'],
        street = json['street'],
        surname = json['surname'],
        houseNumber = json['houseNumber'],
        building = json['building'];

  Map<String, dynamic> toJson() => {
        'area': area,
        'level': level,
        'street': street,
        'surname': surname,
        'houseNumber': houseNumber,
        'building': building,
      };
}
