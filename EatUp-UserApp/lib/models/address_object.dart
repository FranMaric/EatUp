class Address {
  String street;
  String houseNumber;
  String area;
  int level;
  bool building;
  String surname;

  Address({
    this.area,
    this.building,
    this.houseNumber,
    this.level,
    this.street,
    this.surname,
  });

  Object toJson() {
    return {
      'street': street,
      'houseNumber': houseNumber,
      'area': area,
      'level': level,
      'building': building,
      'surname': surname,
    };
  }
}
