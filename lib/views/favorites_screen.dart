import 'package:flutter/material.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoritePokemonList = favoritesProvider.favorites;

    // Si no hay Pokémon favoritos, muestra un mensaje
    if (favoritePokemonList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
        ),
        body: const Center(
          child: Text("No tienes Pokémon favoritos"),
        ),
      );
    }

    // Si hay Pokémon favoritos, muestra la lista en un GridView
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: favoritePokemonList.length,
        itemBuilder: (context, index) {
          final pokemon = favoritePokemonList[index];
          return PokemonCard(pokemon: pokemon);
        },
      ),
    );
  }
}
