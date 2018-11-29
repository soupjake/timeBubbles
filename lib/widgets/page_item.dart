import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/pages/recipe_page.dart';
import 'package:recipeapp/widgets/page_transformer.dart';
import 'package:recipeapp/viewmodels/recipe_viewmodel.dart';
import 'package:transparent_image/transparent_image.dart';

class PageItem extends StatelessWidget {
  PageItem({
    @required this.recipe,
    @required this.pageVisibility,
  });

  final Recipe recipe;
  final PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final bool alreadySaved = RecipeViewModel.checkMatch(recipe.id);

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          recipe.title,
          style: textTheme.title
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

    var infoText = _applyTextEffects(
        translationFactor: 300.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.schedule,
              color: Colors.white70,
              size: 16.0,
            ),
            Text(
              " " + recipe.readyInMinutes.toString(),
              style: textTheme.caption.copyWith(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            Padding(padding: const EdgeInsets.only(right: 12.0, left: 12.0)),
            Icon(
              Icons.restaurant,
              color: Colors.white70,
              size: 16.0,
            ),
            Text(" " + recipe.servings.toString(),
                style: textTheme.caption.copyWith(
                  color: Colors.white70,
                  fontSize: 16.0,
                )),
            Padding(padding: const EdgeInsets.only(right: 12.0, left: 12.0)),
            Icon(
              Icons.thumb_up,
              color: Colors.white70,
              size: 16.0,
            ),
            Text(" " + recipe.aggregateLikes.toString(),
                style: textTheme.caption.copyWith(
                  color: Colors.white70,
                  fontSize: 16.0,
                )),
            Padding(padding: const EdgeInsets.only(right: 12.0, left: 12.0)),
            Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: Colors.white70),
          ],
        ));

    return Positioned(
      bottom: 32.0,
      left: 32.0,
      right: 32.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleText,
          infoText,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var image = FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: recipe.image,
      fit: BoxFit.cover,
      alignment: FractionalOffset(
        0.5 + (pageVisibility.pagePosition / 3),
        0.5,
      ),
    );

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.center,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    );

    return InkWell(
      child: Hero(tag: recipe.id.toString(), child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 8.0,
        ),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              imageOverlayGradient,
              _buildTextContainer(context),
            ],
          ),
        ),
      )),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return RecipePage(recipe: recipe);
        }));
      },
    );
  }
}
