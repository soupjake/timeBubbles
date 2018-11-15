import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/chips_tile.dart';

class QueryDialog extends StatefulWidget {
  final List<String> ingredients;
  final List<bool> diets;

  QueryDialog({this.ingredients, this.diets});

  @override
  State<StatefulWidget> createState() => QueryDialogState();
}

class QueryDialogState extends State<QueryDialog> {
  TextField ingredientField;
  TextEditingController ingredientController = new TextEditingController();
  bool vegan = false;
  bool vegetarian = false;
  bool diaryFree = false;
  bool glutenFree = false;

  @override
  void initState() {
    ingredientField = new TextField(
        controller: ingredientController,
        decoration: InputDecoration(hintText: "Add ingredient..."));
    for (int i = widget.ingredients.length-1; i > 0; i--) {
      switch (widget.ingredients[i]) {
        case "vegan":
          vegan = true;
          widget.ingredients.removeAt(i);
          break;
        case "vegetarian":
          vegetarian = true;
          widget.ingredients.removeAt(i);
          break;
        case "diaryFree":
          diaryFree = true;
          widget.ingredients.removeAt(i);
          break;
        case "glutenFree":
          glutenFree = true;
          widget.ingredients.removeAt(i);
          break;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(12.0),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
                top: 8.0, bottom: 16.0, left: 12.0, right: 12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Theme(
                        data: ThemeData(primaryColor: Colors.black54),
                        child: ingredientField)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (ingredientController.text.length > 0) {
                        widget.ingredients.add(ingredientController.text);
                      }
                    });
                  },
                )
              ],
            )),
        Row(children: <Widget>[
          ChipsTile(
            ingredients: widget.ingredients,
            deletable: true,
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Text("Vegan      "),
          Checkbox(
            value: vegan,
            onChanged: (value) {
              setState(() {
                vegan = value;
              });
            },
          ),
          Text("Vegetarian"),
          Checkbox(
            value: vegetarian,
            onChanged: (value) {
              setState(() {
                vegetarian = value;
              });
            },
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Text("Diary Free"),
          Checkbox(
            value: diaryFree,
            onChanged: (value) {
              setState(() {
                diaryFree = value;
              });
            },
          ),
          Text("Gluten Free"),
          Checkbox(
            value: glutenFree,
            onChanged: (value) {
              setState(() {
                glutenFree = value;
              });
            },
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                child: Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text("Accept"),
                onPressed: () async {
                  if(vegan){
                    widget.ingredients.add("vegan");
                  }
                  if(vegetarian){
                    widget.ingredients.add("vegetarian");
                  }
                  if(diaryFree){
                    widget.ingredients.add("diaryFree");
                  }
                  if(glutenFree){
                    widget.ingredients.add("glutenFree");
                  }
                  Navigator.of(context).pop(widget.ingredients);
                })
          ],
        )
      ],
    );
  }
}
