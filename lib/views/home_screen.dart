import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/views/favorites_screen.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/providers/pokemon_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final pokemonProvider =
        Provider.of<PokemonProvider>(context, listen: false);
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    // Carga la lista de Pokémon y los favoritos al iniciar la pantalla
    pokemonProvider.fetchPokemonList();
    pokemonProvider.fetchFavoritePokemonList(favoritesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Pokédex',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.star,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                pokemonProvider.filterPokemonList(
                    query); // Filtra la lista según el texto ingresado
              },
            ),
          ),
          // Lista de Pokémon
          Expanded(
            child: pokemonProvider.pokemonList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: pokemonProvider.pokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonProvider.pokemonList[index];
                      return PokemonCard(pokemon: pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
