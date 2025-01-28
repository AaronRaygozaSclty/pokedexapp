import 'package:flutter/material.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokedexapp/config/config.dart';

//This Widget Groups Pokemons in Favorites
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoritesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoritePokemonList = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Favorites',
          style: TextStyle(
              color: AppColors.whiteText, fontWeight: FontWeight.bold),
        ),
      ),
      body: favoritePokemonList.isEmpty
          ? const Center(child: Text("You don't have any favorite Pokémon"))
          : GridView.builder(
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
                return PokemonCard(pokemon: pokemon); // Pokémon Card Widget
              },
            ),
    );
  }
}
