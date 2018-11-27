import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:recipeapp/models/recipe.dart';
import 'package:path_provider/path_provider.dart';

class RecipeViewModel {
  static List<Recipe> recipes = new List<Recipe>();
  static List<Recipe> favourites = new List<Recipe>();
  static Map<String, String> headers = new Map<String, String>();
  static String joiner = "%2C";

  static Future load() async {
    //API KEY GOES HERE
    headers['X-Mashape-Key'] =
        "test";
    headers['Accept'] = "application/json";
    //load recipes
    try {
      loadRecipes(await getRecipes());
    } catch (e) {
      print(e);
    }
    //load favourites
    try {
      File file = await getFile();
      String favouritesFile = await file.readAsString();
      if (favouritesFile != null) {
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

  static loadRecipes(String recipesJson) {
    recipes.clear();
    List jsonParsed = json.decode(recipesJson);
    for (int i = 0; i < jsonParsed.length; i++) {
      //some responses come back with empty fields so don't include them
      try{
      recipes.add(new Recipe.fromJson(jsonParsed[i]));
      } catch (e) {
        print(e);
      }
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
    for (int i = 0; i < favourites.length; i++) {
      if (id == favourites[i].id) {
        match = true;
        break;
      }
    }
    return match;
  }

  static Future getResults(List<String> ingredients) async {
    try {
      String queries = ingredients.join(joiner);
      var resultsResponse = await http.get(
          "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=false&ingredients=" +
              queries +
              "&limitLicense=false&number=10&ranking=1",
          headers: headers);
      if (resultsResponse.statusCode == 200) {
        List resultsJson = json.decode(resultsResponse.body);
        String results =
            resultsJson.map((i) => (i['id'].toString())).toList().join(joiner);
        var recipeResponse = await http.get(
            "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/informationBulk?ids=" +
                results +
                "&includeNutrition=false",
            headers: headers);
        if (recipeResponse.statusCode == 200) {
          loadRecipes(recipeResponse.body);
        } else {
          throw Exception("Failed to get recipes response");
        }
      } else {
        throw Exception("Failed to get results response");
      }
    } catch (e) {
      print(e);
    }
  }
}
