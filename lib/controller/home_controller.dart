import 'package:bagel_pizza/model/pizza_model.dart';
import 'package:bagel_pizza/model/topping_model.dart';
import 'package:bagel_pizza/scoped_model/base_model.dart';

import 'package:bagel_db/bagel_db.dart';

import '../model/topping_model.dart';

class HomeController extends BaseModel {
  static String _apiToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6ImFwaS1rZXkiLCJ0eXAiOiJKV1QifQ.eyJvcmdhbml6YXRpb25JRCI6ImJyaDJ0YmkyM2FrZzAwZWkwdDBnIiwicHJvamVjdElEIjoiYnNvaDF2MjIzYWtnMDA4cmhocWciLCJhdWQiOiJodHRwczovL2RldmlsIiwianRpIjoiNjk4MmNkZjItMmFlYi00ZmNhLTk2OGItZjNmNjUxYWE2MmM1IiwiaXNzIjoiaHR0cHM6Ly9hdXRoZW50aWNhdGlvbi5iYWdlbGRiLmNvIiwic3ViIjoiYnNvaDF2MjIzYWtnMDA4cmhocWcifQ.LV9XZdy0WWU4L8hK2M1TKzACMcUoMKI8BE13rDa8xchuTjMJhuQe2HlrH10fb63EhFW5ZypIOXJsjzbrB3GYk2lpL8UldqgNW9k12dV2UWfRXLVBWBkMMbh-zOAZmc6FRyOmOrNVZcfRudXfmUspa8ZJoynX7yowMzRgtqZOnMQpl_ouFSQSb_R235Qe3cbDaM4EYKnPXM_TKVopZVcVmWt66OtBsh1ucyB3DeWec8VAM50ahN9fFn6BhWlhu9gVsAx9KVdgpyVRtM-Qbl54QIFFNExmiulvn6BUBGNl_wevMK63qby3n9E7xXl9YjAkUvIlLAkz6TjZUJF6jsvKAmhN4TEqLALMtv_ssSxUDKwSkBnuTMysY5VhNYzjv6EoG35kAcgFjNRv8TqemRcGuQosJLvFZAb2dDZJXf1N8ROOdjwUF-v_z5wsCB4nQXYedzpkaEYG4sSwl-HN9ApLWs_lKNz0DzoEJe65JYOr_uqU2JPeTbm3zK705JZyxyfoyykSIuYEQvrOa2tYN0xLrsB9xmR_rB8Am12KeV3nlEQZStZcj4t82RxO7nkI9bJ3K4LwWmBg5ZwmeneQHzTibotKm26ASom9pTR8t1BVzKwoGrLtbTCRJSKjylPUcsxUgUxjG_JLVq0vzANehmWDnnRhwzCoQvTYe79-Ex_6tqA';
  // static String emptyPizzaImageLink = 'https://sfo2.digitaloceanspaces.com/bagel/bagel/pizza.png';
  BagelDB _bagelDB = BagelDB(token: _apiToken);
  List<Topping> toppingsList = [];
  List<Topping> userToppigsList = [];
  List<String> pizzaToppingsImages = [];
  bool finishDrag = true;
  List<String> sizeLst = ['Small', 'Medium', 'Large'];
  int tag = 1;
  Pizza currentPizza;
  List<Pizza> pizzasList = [];

  void init() {
    loadToppings();
  }

  changeTag(int tagNum) {
    this.tag = tagNum;
    print(this.tag);
    notifyListeners();
  }

  static PIZZA_SIZE returnPizzaSizeEnum(int index) {
    print(index);
    switch (index) {
      case (0):
        return PIZZA_SIZE.Small;
      case (1):
        return PIZZA_SIZE.Medium;
      default:
        return PIZZA_SIZE.Large;
    }
  }

  String convertSizeEnumToString(PIZZA_SIZE pizzaSize) {
    switch (pizzaSize) {
      case (PIZZA_SIZE.Small):
        return 'Small';
      case (PIZZA_SIZE.Medium):
        return 'Medium';
      default:
        return 'Large';
    }
  }
  // selectSize(int index) {
  //   sizeLst[index] = !sizeLst[index];
  //   print(sizeLst.toString());
  //   notifyListeners();
  // }

  loadToppings() async {
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

  addToppingToPizza(Topping topping) {
    this.pizzaToppingsImages.add(topping.pizzaImage);
    this.userToppigsList.add(topping);
    notifyListeners();
  }

  resetToppings() {
    this.pizzaToppingsImages.clear();
    userToppigsList.clear();
    notifyListeners();
  }

  removeTopping(Topping topping) {
    this.pizzaToppingsImages.remove(topping.pizzaImage);
    this.userToppigsList.remove(topping);
    notifyListeners();
  }

  void postPizza() {
    List<Topping> userTops = this.userToppigsList;
    Pizza pizza =
        new Pizza(size: returnPizzaSizeEnum(this.tag), toppings: userTops);
    this.currentPizza = pizza;
    this.pizzasList.add(pizza);
    notifyListeners();
    print(pizza.toString());
  }

  removePizza(Pizza pizzaToRemove) {
    this.pizzasList.remove(pizzaToRemove);
    notifyListeners();
  }
}
