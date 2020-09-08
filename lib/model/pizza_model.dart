import 'package:bagel_pizza/model/topping_model.dart';

class Pizza {
  final PIZZA_SIZE size;
  List<Topping> toppings;
  Pizza({this.size, this.toppings});

  factory Pizza.fromMap(obj) {
    return Pizza(
      size: returnPizzaSizeEnum(obj["size"]["value"] ?? ''),
      toppings: buildToppingsList(obj["toppings"] ?? []),
    );
  }
  @override
  String toString() {
    return 'size: ${this.size}\ntoppings list: ${this.toppings.toString()}';
  }

  static PIZZA_SIZE returnPizzaSizeEnum(String sizeString) {
    print(sizeString);
    switch (sizeString) {
      case ('small'):
        return PIZZA_SIZE.Small;
      case ('medium'):
        return PIZZA_SIZE.Medium;
      default:
        return PIZZA_SIZE.Large;
    }
  }

  static List<Topping> buildToppingsList(List obj) {
    List<Topping> _toppings = [];
    obj.forEach((element) {
      _toppings.add(Topping.fromMap(obj));
    });
    return _toppings;
  }
}

enum PIZZA_SIZE { Small, Medium, Large }
