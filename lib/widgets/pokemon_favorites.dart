import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

//Widget to turn on or turn of favorites
//It is displayed in Favorites,Details, and Home Screen
class FavoriteIcon extends StatefulWidget {
  final Pokemon pokemon;

  const FavoriteIcon({
    super.key,
    required this.pokemon,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return IconButton(
      icon: Icon(
        widget.pokemon.isFavorite ? Icons.star : Icons.star_border,
        color: widget.pokemon.isFavorite
            ? const Color.fromARGB(255, 200, 187, 66)
            : const Color.fromARGB(255, 21, 15, 15),
        size: 24,
      ),
      onPressed: () {
        setState(() {
          favoritesProvider.toggleFavorite(widget.pokemon);
          widget.pokemon.isFavorite = !widget.pokemon.isFavorite;
        });
      },
    );
  }
}
