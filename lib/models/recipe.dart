class Recipe {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final int spoonacularScore;
  final int aggregateLikes;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final int healthScore;
  final double pricePerServing;
  final List<String> ingredients;
  final List<String> steps;
  final String sourceUrl;
  final String spoonacularSourceUrl;
  
  Recipe({this.id, this.title, this.image, this.readyInMinutes, this.servings, this.spoonacularScore, this.aggregateLikes, this.vegetarian, this.vegan, this.glutenFree, this.dairyFree, this.healthScore, this.pricePerServing, this.ingredients, this.steps, this.sourceUrl, this.spoonacularSourceUrl});

  factory Recipe.fromJson(Map<String, dynamic> json){
    var ingredientsJson = json['extendedIngredients'] as List;
    var stepsJson = json['analyzedInstructions'][0]['steps'] as List;

    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      spoonacularScore: json['spoonacularScore'],
      aggregateLikes: json['aggregateLikes'],
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      healthScore: json['healthScore'],
      pricePerServing: json['pricePerServing'],
      ingredients: ingredientsJson.map((i) => i['originalString'].toString()).toList(),
      steps: stepsJson.map((i)=> i['step'].toString()).toList(),
      sourceUrl: json['sourceUrl'],
      spoonacularSourceUrl: json['spoonacularSourceUrl']
    );
  }

  factory Recipe.fromFavourites(Map<String, dynamic> json){
    var ingredientsJson = json['ingredients'] as List;
    var stepsJson = json['steps'] as List;

    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      spoonacularScore: json['spoonacularScore'],
      aggregateLikes: json['aggregateLikes'],
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      healthScore: json['healthScore'],
      pricePerServing: json['pricePerServing'],
      ingredients: ingredientsJson.map((i) => i.toString()).toList(),
      steps: stepsJson.map((i)=> i.toString()).toList(),
      sourceUrl: json['sourceUrl'],
      spoonacularSourceUrl: json['spoonacularSourceUrl']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'readyInMinutes': readyInMinutes,
    'servings': servings,
    'spoonacularScore': spoonacularScore,
    'aggregateLikes': aggregateLikes,
    'vegetarian': vegetarian,
    'vegan': vegan,
    'glutenFree': glutenFree,
    'dairyFree': dairyFree,
    'healthScore': healthScore,
    'pricePerServing': pricePerServing,
    'ingredients': ingredients,
    'steps': steps,
    'sourceUrl': sourceUrl,
    'spoonacularSourceUrl': spoonacularSourceUrl
  };
}