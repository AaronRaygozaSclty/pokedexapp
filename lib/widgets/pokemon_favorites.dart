import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:provider/provider.dart';


// This icon allows the user to toggle a Pokémon's favorite status.
// When pressed, it updates the favorite status and changes the icon accordingly:
// A filled star indicates the Pokémon is a favorite, while an outlined star indicates it is not.

class FavoriteIcon extends StatelessWidget {
  final Pokemon pokemon;

  const FavoriteIcon({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return IconButton(
      icon: Icon(
        pokemon.isFavorite ? Icons.star : Icons.star_border,
        color: pokemon.isFavorite
            ? const Color.fromARGB(255, 200, 187, 66)
            : const Color.fromARGB(255, 21, 15, 15),
        size: 24,
      ),
      onPressed: () {
        favoritesProvider.toggleFavorite(pokemon);
      },
    );
  }
}
