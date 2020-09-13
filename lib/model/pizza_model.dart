import 'package:bagel_pizza/model/size_model.dart';
import 'package:bagel_pizza/model/topping_model.dart';

class Pizza {
  String size;
  double price;
  List<Topping> toppings;
  Pizza({this.size, this.toppings, this.price});

  factory Pizza.fromMap(obj) {
    return Pizza(
        size: obj["size"]["name"] ?? '',
        toppings: buildToppingsList(obj["toppings"] ?? []),
        price: obj["price"]);
  }
  @override
  String toString() {
    return 'size: ${this.size}\ntoppings list: ${this.toppings.toString()}';
  }

  static List<Topping> buildToppingsList(List obj) {
    List<Topping> _toppings = [];
    obj.forEach((element) {
      _toppings.add(Topping.fromMap(obj));
    });
    return _toppings;
  }
}
