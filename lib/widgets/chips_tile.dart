import 'package:flutter/material.dart';

class ChipsTile extends StatelessWidget {
  final List<String> ingredients;

  ChipsTile({this.ingredients});

  @override
  Widget build(BuildContext context) { 
    final List<Widget> chips = <Widget>[];
    if (ingredients.isNotEmpty) {
      chips.add(Wrap(  
        children: ingredients.map<Widget>((String name) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(label: Text(name)),
        );
      }).toList()));
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: chips,
    );
  }
}