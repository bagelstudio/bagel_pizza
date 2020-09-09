import 'package:bagel_pizza/views/home_page.dart';
import 'package:bagel_pizza/widgets/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagel Pizza',
      theme: ThemeData.dark(),
      //home: HomeView(),
      home: SplashScreen(
        'assets/pizza.flr',
        HomeView(),
        startAnimation: 'pizza',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
