import 'package:bagel_pizza/views/home_page.dart';
import 'package:bagel_pizza/views/ordered_page.dart';
import 'package:flutter/material.dart';

// enum Routes { Home, Login, TripChat, NewPost, Account }

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'orderedPage':
      return MaterialPageRoute(builder: (context) => OrderedPage());
    case 'home':
      return MaterialPageRoute(builder: (context) => HomeView());
    default:
      return MaterialPageRoute(builder: (context) => HomeView());
  }
}
