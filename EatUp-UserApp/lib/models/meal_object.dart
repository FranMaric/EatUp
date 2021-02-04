class Meal {
  String name;
  String description;
  double price;

  Meal({this.description, this.name, this.price});
  Object toObject(int amount) {
    return {
      'name': name,
      'description': description,
      'price': price,
      'amount': amount,
    };
  }
}
