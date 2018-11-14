import 'package:flutter/material.dart';
import 'package:recipeapp/pages/recipe_page.dart';
import 'package:recipeapp/viewmodels/recipe_viewmodel.dart';

class FavouritesPage extends StatefulWidget {
  @override
  State createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage> {
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.sort),
              itemBuilder: (context) => <PopupMenuItem>[
                    new PopupMenuItem<int>(child: Text("Time"), value: 0),
                    new PopupMenuItem<int>(child: Text("Servings"), value: 1),
                    new PopupMenuItem<int>(child: Text("Score"), value: 2),
                  ],
              onSelected: (result) async {
                switch (result) {
                  case 0:
                    setState(() {
                      RecipeViewModel.favourites.sort((a, b) =>
                          a.readyInMinutes.compareTo(b.readyInMinutes));
                    });
                    break;
                  case 1:
                    setState(() {
                      RecipeViewModel.favourites
                          .sort((a, b) => b.servings.compareTo(a.servings));
                    });
                    break;
                  case 2:
                    setState(() {
                      RecipeViewModel.favourites.sort((a, b) =>
                          b.spoonacularScore.compareTo(a.spoonacularScore));
                    });
                    break;
                }
              },
            ),
            Expanded(
                child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Search..."),
            )),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ])),
      Expanded(
          child: ListView.builder(
              itemCount: RecipeViewModel.favourites.length,
              itemBuilder: (context, index) {
                if (filter == null || filter == "") {
                  return buildRow(index);
                } else {
                  if (RecipeViewModel.favourites[index].title
                      .toLowerCase()
                      .contains(filter.toLowerCase())) {
                    return buildRow(index);
                  } else {
                    return new Container();
                  }
                }
              }))
    ]));
  }

  Widget buildRow(int index) {
    return Hero(
        tag: RecipeViewModel.favourites[index].id.toString(),
        child: Material(
            child: ListTile(
          title: Text(RecipeViewModel.favourites[index].title),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(
                  Icons.schedule,
                  color: Colors.black,
                  size: 16.0,
                ),
                Text(" " +
                    RecipeViewModel.favourites[index].readyInMinutes.toString())
              ]),
              Row(children: <Widget>[
                Icon(
                  Icons.restaurant,
                  color: Colors.black,
                  size: 16.0,
                ),
                Text(
                    " " + RecipeViewModel.favourites[index].servings.toString())
              ]),
              Row(children: <Widget>[
                Icon(
                  Icons.grade,
                  color: Colors.black,
                  size: 16.0,
                ),
                Text(" " +
                    RecipeViewModel.favourites[index].spoonacularScore
                        .toString())
              ]),
              Row(children: <Widget>[
                Icon(
                  Icons.thumb_up,
                  color: Colors.black,
                  size: 16.0,
                ),
                Text(" " +
                    RecipeViewModel.favourites[index].aggregateLikes.toString())
              ])
            ],
          ),
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return RecipePage(recipe: RecipeViewModel.favourites[index]);
            }));
          },
        )));
  }
}
