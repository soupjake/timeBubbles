import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/chips_tile.dart';
import 'package:recipeapp/widgets/page_item.dart';
import 'package:recipeapp/widgets/page_transformer.dart';
import 'package:recipeapp/viewmodels/recipe_viewmodel.dart';
import 'package:recipeapp/widgets/query_dialog.dart';

class RecipesPage extends StatefulWidget {
  @override
  State createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage> {
  List<String> ingredients;
  bool loaded;

  @override
  void initState() {
    super.initState();
    loaded = true;
    ingredients = new List<String>();
    ingredients.add("chicken");
  }

  @override
  void dispose() {
    ingredients.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        child: Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.sort),
                  itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem<int>(child: Text("Time"), value: 0),
                        PopupMenuItem<int>(child: Text("Servings"), value: 1),
                        PopupMenuItem<int>(child: Text("Score"), value: 2),
                      ],
                  onSelected: (result) async {
                    switch (result) {
                      case 0:
                        setState(() {
                          RecipeViewModel.recipes.sort((a, b) =>
                              a.readyInMinutes.compareTo(b.readyInMinutes));
                        });
                        break;
                      case 1:
                        setState(() {
                          RecipeViewModel.recipes
                              .sort((a, b) => b.servings.compareTo(a.servings));
                        });
                        break;
                      case 2:
                        setState(() {
                          RecipeViewModel.recipes.sort((a, b) =>
                              b.spoonacularScore.compareTo(a.spoonacularScore));
                        });
                        break;
                    }
                  },
                ),
                Expanded(
                    child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: Colors.black54))),
                  child: ChipsTile(
                    ingredients: ingredients,
                    deletable: false,
                  ),
                )),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      List<String> temp = await showDialog(
                          context: context,
                          builder: (context) {
                            return QueryDialog(ingredients: ingredients);
                          });
                      setState(() {
                        ingredients = temp;
                        loaded = false;
                      });
                      await RecipeViewModel.getResults(temp);
                      setState(() {
                        loaded = true;
                      });
                    }),
              ])),
      Flexible(
          child: loaded ? recipePages(context) : Center(child: CircularProgressIndicator())),
    ]));
  }

  Widget recipePages(BuildContext context) {
    return PageTransformer(
      pageViewBuilder: (context, visibilityResolver) {
        return PageView.builder(
            controller: PageController(viewportFraction: 0.75),
            itemCount: RecipeViewModel.recipes.length,
            itemBuilder: (context, index) {
              return PageItem(
                  recipe: RecipeViewModel.recipes[index],
                  pageVisibility:
                      visibilityResolver.resolvePageVisibility(index));
            });
      },
    );
  }
}
