import 'package:flutter/semantics.dart';

class PizzaSize {
  final String name, id;
  final double price;
  PizzaSize({this.name, this.price, this.id});

  factory PizzaSize.fromMap(obj) {
    return PizzaSize(
        name: obj["name"] ?? '',
        price: obj["price"].runtimeType == double
            ? obj["price"]
            : obj["price"].toDouble() ?? 3.0,
        id: obj["_id"] ?? '');
  }
  @override
  String toString() {
    return 'size: ${this.name}, price: ${this.price}';
  }

  @override
  bool operator ==(covariant PizzaSize other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
