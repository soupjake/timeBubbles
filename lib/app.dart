import 'package:recipeapp/pages/home_page.dart';
import 'package:flutter/material.dart';

class RecipeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
            title: 'RecipeApp',
            theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
            home: HomePage(),
          );
  }
}