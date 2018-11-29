import 'package:flutter/material.dart';
import 'package:recipeapp/viewmodels/recipe_viewmodel.dart';
import 'package:recipeapp/widgets/chips_tile.dart';

class QueryDialog extends StatefulWidget {
  final List<String> ingredients;

  QueryDialog({this.ingredients});

  @override
  State<StatefulWidget> createState() => QueryDialogState();
}

class QueryDialogState extends State<QueryDialog> {
  List<String> original;
  TextField ingredientField;
  TextEditingController ingredientController = new TextEditingController();

  @override
  void initState() {
    original = new List<String>.from(widget.ingredients);
    ingredientField = new TextField(
        controller: ingredientController,
        decoration: InputDecoration(hintText: "Add ingredient"));
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
        Row(
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
                    ingredientController.clear();
                  }
                });
              },
            )
          ],
        ),
        ChipsTile(
          ingredients: widget.ingredients,
          deletable: true,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Number of results:", style: TextStyle(fontSize: 16.0),),
              Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: DropdownButton<int>(
                      value: RecipeViewModel.resultAmount,
                      items: <int>[5, 10, 15, 20, 25].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          RecipeViewModel.resultAmount = value;
                        });
                      }))
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                child: Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop(original);
                }),
            FlatButton(
                child: Text("Accept"),
                onPressed: () async {
                  Navigator.of(context).pop(widget.ingredients);
                })
          ],
        )
      ],
    );
  }
}
