import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/viewmodels/recipe_viewmodel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  RecipePage({this.recipe});

  @override
  State createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double availableWidth = mediaQuery.size.width - 190;
    var textTheme = Theme.of(context).textTheme;
    bool alreadySaved = RecipeViewModel.checkMatch(widget.recipe.id);

    return Hero(
        tag: widget.recipe.id.toString(),
        child: Scaffold(
            body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: 256.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    if (await canLaunch(widget.recipe.sourceUrl)) {
                      await launch(widget.recipe.sourceUrl);
                    } else {
                      throw 'Could not lunch $widget.recipe.sourceUrl';
                    }
                  },
                ),
                IconButton(
                  icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
                  onPressed: () async {
                    if(alreadySaved){
                      setState(() {
                        RecipeViewModel.favourites.remove(widget.recipe);
                        RecipeViewModel.saveFavourites();
                        alreadySaved = false;
                      });
                    } else {
                      setState(() {
                        RecipeViewModel.favourites.add(widget.recipe);
                        RecipeViewModel.saveFavourites();
                        alreadySaved = true;
                      });
                    }
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: availableWidth,
                  ),
                  child: Text(
                    widget.recipe.title,
                    textScaleFactor: 0.8,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.recipe.image,
                      fit: BoxFit.cover,
                      height: 256.0,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.center,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Icon(
                                Icons.schedule,
                                color: Colors.black,
                                size: 16.0,
                              ),
                              Text(
                                " " + widget.recipe.readyInMinutes.toString(),
                                style: textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              )
                            ]),
                            Row(children: <Widget>[
                              Icon(
                                Icons.restaurant,
                                color: Colors.black,
                                size: 16.0,
                              ),
                              Text(" " + widget.recipe.servings.toString(),
                                  style: textTheme.caption.copyWith(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                            ]),
                            Row(children: <Widget>[
                              Icon(
                                Icons.grade,
                                color: Colors.black,
                                size: 16.0,
                              ),
                              Text(
                                  " " + widget.recipe.spoonacularScore.toString(),
                                  style: textTheme.caption.copyWith(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ))
                            ]),
                            Row(children: <Widget>[
                              Icon(
                                Icons.thumb_up,
                                color: Colors.black,
                                size: 16.0,
                              ),
                              Text(
                                  " " + widget.recipe.aggregateLikes.toString(),
                                  style: textTheme.caption.copyWith(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ))
                            ])
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                "Vegan",
                                style: textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                widget.recipe.vegan ? Icons.check : Icons.close,
                                color: Colors.black,
                                size: 16.0,
                              )
                            ]),
                            Row(children: <Widget>[
                              Text(
                                "Vegetarian",
                                style: textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                widget.recipe.vegetarian
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.black,
                                size: 16.0,
                              )
                            ]),
                            Row(children: <Widget>[
                              Text(
                                "Diary Free",
                                style: textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                widget.recipe.dairyFree
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.black,
                                size: 16.0,
                                
                              )
                            ]),
                            Row(children: <Widget>[
                              Text(
                                "Gluten Free",
                                style: textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                widget.recipe.glutenFree
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.black,
                                size: 16.0,
                              )
                            ]),
                          ],
                        ),
                      ),
                      ExpansionTile(
                        title: Text("Ingredients"),
                        children: <Widget>[
                          ListView.separated(
                              separatorBuilder: (context, int index) =>
                                  Divider(),
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 0.0,
                                  bottom: 0.0),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount:
                                  widget.recipe.ingredients.length,
                              itemBuilder: (context, int index) {
                                return ListTile(
                                    title: Text(widget
                                        .recipe
                                        .ingredients[index]));
                              })
                        ],
                      ),
                      ExpansionTile(
                        title: Text("Instructions"),
                        initiallyExpanded: true,
                        children: <Widget>[
                          ListView.separated(
                              separatorBuilder: (context, int index) =>
                                  Divider(),
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 0.0,
                                  bottom: 0.0),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: widget.recipe.steps.length,
                              itemBuilder: (context, int index) {
                                return ListTile(
                                    title: Text(widget.recipe.steps[index]));
                              })
                        ],
                      )
                    ],
                  ),
                )
              ]),
            )
          ],
        )));
  }
}
