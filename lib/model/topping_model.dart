class Topping {
  final String name, smallImage, pizzaImage, id;
  final double price;
  Topping({this.name, this.smallImage, this.pizzaImage, this.id, this.price});

  factory Topping.fromMap(obj) {
    return Topping(
        name: obj["name"] ?? '',
        smallImage: obj["smallImage"]["imageURL"] ?? '',
        pizzaImage: obj["pizzaImage"]["imageURL"] ?? '',
        id: obj["_id"] ?? '',
        price: obj["price"].runtimeType == double
            ? obj["price"]
            : obj["price"].toDouble() ?? 3.0);
  }
  @override
  String toString() {
    return '${this.name}';
  }
}
