class Topping {
  final String name, smallImage, pizzaImage;
  Topping({this.name, this.smallImage, this.pizzaImage});

  factory Topping.fromMap(obj) {
    return Topping(
      name: obj["name"] ?? '',
      smallImage: obj["smallImage"]["imageURL"] ?? '',
      pizzaImage: obj["pizzaImage"]["imageURL"] ?? '',
    );
  }
  @override
  String toString() {
    return '${this.name}';
  }
}
