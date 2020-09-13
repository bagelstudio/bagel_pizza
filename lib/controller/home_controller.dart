import 'package:bagel_pizza/model/pizza_model.dart';
import 'package:bagel_pizza/model/size_model.dart';
import 'package:bagel_pizza/model/topping_model.dart';
import 'package:bagel_pizza/scoped_model/base_model.dart';
import 'package:bagel_db/bagel_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../model/topping_model.dart';

class HomeController extends BaseModel {
  static String _apiToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6ImFwaS1rZXkiLCJ0eXAiOiJKV1QifQ.eyJvcmdhbml6YXRpb25JRCI6ImJyaDJ0YmkyM2FrZzAwZWkwdDBnIiwicHJvamVjdElEIjoiYnNvaDF2MjIzYWtnMDA4cmhocWciLCJhdWQiOiJodHRwczovL2RldmlsIiwianRpIjoiNjk4MmNkZjItMmFlYi00ZmNhLTk2OGItZjNmNjUxYWE2MmM1IiwiaXNzIjoiaHR0cHM6Ly9hdXRoZW50aWNhdGlvbi5iYWdlbGRiLmNvIiwic3ViIjoiYnNvaDF2MjIzYWtnMDA4cmhocWcifQ.LV9XZdy0WWU4L8hK2M1TKzACMcUoMKI8BE13rDa8xchuTjMJhuQe2HlrH10fb63EhFW5ZypIOXJsjzbrB3GYk2lpL8UldqgNW9k12dV2UWfRXLVBWBkMMbh-zOAZmc6FRyOmOrNVZcfRudXfmUspa8ZJoynX7yowMzRgtqZOnMQpl_ouFSQSb_R235Qe3cbDaM4EYKnPXM_TKVopZVcVmWt66OtBsh1ucyB3DeWec8VAM50ahN9fFn6BhWlhu9gVsAx9KVdgpyVRtM-Qbl54QIFFNExmiulvn6BUBGNl_wevMK63qby3n9E7xXl9YjAkUvIlLAkz6TjZUJF6jsvKAmhN4TEqLALMtv_ssSxUDKwSkBnuTMysY5VhNYzjv6EoG35kAcgFjNRv8TqemRcGuQosJLvFZAb2dDZJXf1N8ROOdjwUF-v_z5wsCB4nQXYedzpkaEYG4sSwl-HN9ApLWs_lKNz0DzoEJe65JYOr_uqU2JPeTbm3zK705JZyxyfoyykSIuYEQvrOa2tYN0xLrsB9xmR_rB8Am12KeV3nlEQZStZcj4t82RxO7nkI9bJ3K4LwWmBg5ZwmeneQHzTibotKm26ASom9pTR8t1BVzKwoGrLtbTCRJSKjylPUcsxUgUxjG_JLVq0vzANehmWDnnRhwzCoQvTYe79-Ex_6tqA';
  // declare bagelDB object
  BagelDB _bagelDB = BagelDB(token: _apiToken);
  List<Topping> toppingsList = [];
  List<String> pizzaToppingsImages = [];
  List<String> sizesList = [];
  List<PizzaSize> sizesObjLst = [];
  List<String> sizesStringsToDisplay = [];
  Pizza currentPizza;
  List<Pizza> pizzasList = [];
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> specifyTextFieldKey =
      GlobalKey<FormFieldState>();
  int tag = 1;
  bool edit = false;
  bool finishDrag = true;
  bool formSent = false;
  bool loadingFormSubmit = false;
  bool submitError = false;

  void init({Map pizzaMap}) async {
    Pizza pizza;
    if (pizzaMap != null) {
      if (pizzaMap["pizza"] != null) {
        pizza = pizzaMap["pizza"];
        edit = true;
      } else
        edit = false;
    } else
      edit = false;
    if (toppingsList.isEmpty) loadToppings();
    if (sizesList.isEmpty) await loadSizes();

    if (pizza == null) {
      currentPizza = Pizza(toppings: List(), size: sizesList[1]);
      pizzaToppingsImages.clear();
      formSent = false;
    } else {
      currentPizza = pizza;
      pizzaToppingsImages =
          pizza.toppings.map((Topping topping) => topping.pizzaImage).toList();
    }
    notifyListeners();
  }

  changeTag(int tagNum) {
    this.tag = tagNum;
    currentPizza.size = returnPizzaSizeString(tagNum);
    notifyListeners();
  }

  String returnPizzaSizeString(int index) => sizesList[index];

  void loadToppings() async {
    // bagelDB get
    BagelResponse res =
        await _bagelDB.collection('toppings').everything().get();
    var data = res.data;
    List<dynamic> _toppings =
        data.map((topObj) => Topping.fromMap(topObj)).toList();
    _toppings.forEach((topping) {
      toppingsList.add(topping);
    });
    notifyListeners();
  }

  Future<Null> loadSizes() async {
    // bagelDB get
    BagelResponse res = await _bagelDB.collection('sizes').get();
    var data = res.data;
    List<dynamic> _sizes =
        data.map((sizeObj) => PizzaSize.fromMap(sizeObj)).toList();
    _sizes.forEach((size) {
      sizesObjLst.add(size);
    });
    sizesList = sizesObjLst.map((PizzaSize size) => size.name).toList();
    sizesStringsToDisplay = sizesObjLst
        .map((PizzaSize size) =>
            '${size.name} | ${size.price.toStringAsFixed(0)}\$')
        .toList();
    return notifyListeners();
  }

  addToppingToPizza(Topping topping) {
    this.pizzaToppingsImages.add(topping.pizzaImage);
    currentPizza.toppings.add(topping);
    notifyListeners();
  }

  resetToppings() {
    this.pizzaToppingsImages.clear();
    currentPizza.toppings.clear();
    notifyListeners();
  }

  removeTopping(Topping topping) {
    this.pizzaToppingsImages.remove(topping.pizzaImage);
    currentPizza.toppings.remove(topping);
    notifyListeners();
  }

  void savePizza() {
    currentPizza.price = calculatePizzaPrice(currentPizza);
    if (!edit) this.pizzasList.add(currentPizza);
    notifyListeners();
  }

  removePizza(Pizza pizzaToRemove) {
    this.pizzasList.remove(pizzaToRemove);
    notifyListeners();
  }

  submitForm(Map<String, dynamic> form) async {
    loadingFormSubmit = true;
    notifyListeners();
    List<String> pizzaIDs = [];
    for (Pizza pizza in pizzasList) {
      try {
        Map<String, dynamic> map = {
          'size': pizza.size,
          'name': 'pizza-' + pizzasList.indexOf(pizza).toString(),
          'toppings': pizza.toppings
              .map((Topping topping) => {'itemRefID': topping.id})
              .toList(),
          'price': calculatePizzaPrice(pizza)
        };
        // bagelDB post
        BagelResponse response =
            await this._bagelDB.collection('pizzas').post(item: map);
        pizzaIDs.add(response.data['id']);
      } catch (e) {
        print(e.response.data);
      }
    }
    Map<String, dynamic> cartMap = {
      'name': form["name"],
      'email': form["email"],
      'phone': form["phone"],
      'adress': form["adress"],
      'totalPrice': calculateTotalPrice(),
      'pizza': pizzaIDs.map((pizzaID) => {'itemRefID': pizzaID}).toList()
    };
    // bagelDB post
    BagelResponse res =
        await this._bagelDB.collection('carts').post(item: cartMap);
    if (res.statusCode == 201) {
      loadingFormSubmit = false;
      formSent = true;
    } else {
      formSent = true;
      submitError = true;
    }
    notifyListeners();
  }

  calculatePizzaPrice(Pizza pizza) {
    double totalPrice = 0;
    double sizePrice = sizesObjLst
        .firstWhere((PizzaSize sizeObj) => sizeObj.name == pizza.size)
        .price;
    double toppingsTotalPrice = 0;
    for (Topping topping in pizza.toppings) {
      toppingsTotalPrice = toppingsTotalPrice + topping.price;
    }
    totalPrice = toppingsTotalPrice + sizePrice;
    return totalPrice;
  }

  calculateTotalPrice() {
    double totalPrice = 0;
    for (Pizza pizza in pizzasList) {
      totalPrice = totalPrice + pizza.price;
    }
    return totalPrice;
  }
}
