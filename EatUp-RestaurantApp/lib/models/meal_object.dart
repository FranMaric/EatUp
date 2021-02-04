class Meal {
  String name;
  String description;
  int amount;
  String price;

  Meal();

  Meal.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        amount = json['amount'],
        price = tryInt(json['price']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'amount': amount,
        'price': price
      };
}

String tryInt(number) {
  if (number is double && number.round() == number) {
    return number.round().toString();
  }
  return number.toString();
}
