import 'package:flutter/material.dart';
import 'package:recipeapp/pages/favourites_page.dart';
import 'package:recipeapp/pages/recipes_page.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              title: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.search)),
                  Tab(icon: Icon(Icons.favorite))
                ],
                indicatorColor: Colors.black,
              )),
          body: TabBarView(
            children: <Widget>[
              RecipesPage(),
              FavouritesPage()
            ],
          )),
    ));
  }
}
