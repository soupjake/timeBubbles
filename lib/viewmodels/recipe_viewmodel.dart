import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recipeapp/models/recipe.dart';
import 'package:path_provider/path_provider.dart';

class RecipeViewModel {
  static List<Recipe> recipes = new List<Recipe>();
  static List<Recipe> favourites = new List<Recipe>();

  static Future load() async {
    //load recipes
    try {
      String recipesJson = await getRecipes();
      List jsonParsed = json.decode(recipesJson);
      for (int i = 0; i < jsonParsed.length; i++) {
        recipes.add(new Recipe.fromJson(jsonParsed[i]));
      }
    } catch (e) {
      print(e);
    }
    //load favourites
    try {
      File file = await getFile();
      String favouritesFile = await file.readAsString();
      if(favouritesFile != null){
        List favouritesJson = json.decode(favouritesFile);
        if (favouritesJson != null) {
          for (int i = 0; i < favouritesJson.length; i++) {
            favourites.add(new Recipe.fromFavourites(favouritesJson[i]));
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }  
 
  static Future<String> getRecipes() async {
    return await rootBundle.loadString('assets/bulk.json');
  }

  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/favourites.json');
  }

  static Future saveFavourites() async {
    File file = await getFile();
    file.writeAsString(json.encode(favourites));
  }

  static bool checkMatch(int id) {
    bool match = false;
    for(int i = 0; i < favourites.length; i++){
      if(id == favourites[i].id){
        match = true;
        break;
      }
    }
    return match;
  }
}
