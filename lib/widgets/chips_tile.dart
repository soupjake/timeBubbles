import 'package:flutter/material.dart';

class ChipsTile extends StatefulWidget {
  final List<String> ingredients;
  final bool deletable;

  ChipsTile({this.ingredients, this.deletable});

  @override
  State<StatefulWidget> createState() => ChipsTileState();
}

class ChipsTileState extends State<ChipsTile> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = <Widget>[];
      chips.add(Wrap(
          children: widget.ingredients.map<Widget>((String name) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: widget.deletable
              ? Chip(
                  label: Text(name),
                  onDeleted: () {
                    setState(() {
                      widget.ingredients.remove(name);
                    });
                  },
                )
              : Chip(
                  label: Text(name),
                ),
        );
      }).toList()));
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: chips,
    );
  }
}
