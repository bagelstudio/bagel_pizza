import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  //locator.registerLazySingleton<Router>(() => Router());
  locator.registerLazySingleton<HomeController>(() => HomeController());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  void popUntil(String routeName) {
    navigatorKey.currentState.popUntil(ModalRoute.withName('/'));
  }

  void pushReplacementNamed(String routhName) {
    navigatorKey.currentState.pushReplacementNamed(routhName);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }
}
