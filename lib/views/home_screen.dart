import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/services/services.dart';
import 'package:pokedexapp/views/favorites_screen.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _pokemonList = []; // Lista completa de Pokémon
  List<Pokemon> _filteredPokemonList = []; // Lista filtrada de Pokémon

  @override
  void initState() {
    super.initState();
    _fetchPokemonList(); // Llama a la función para cargar la lista al iniciar
  }

  // Método para cargar la lista de Pokémon
  Future<void> _fetchPokemonList() async {
    try {
      final List<Pokemon> pokemonList = await PokemonService.fetchPokemonList();
      setState(() {
        _pokemonList = pokemonList;
        _filteredPokemonList =
            pokemonList; // Inicialmente muestra toda la lista
      });
    } catch (e) {
      // Manejo de errores al cargar la lista
      Text('Error al cargar Pokémon: $e');
    }
  }

  // Método para filtrar la lista de Pokémon
  void _filterPokemonList(String query) {
    final filteredList = _pokemonList
        .where((pokemon) =>
            pokemon.name.toUpperCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredPokemonList = filteredList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokedex',
          style: TextStyle(
            color: AppColors.whiteText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchController.clear();
              _filteredPokemonList = _pokemonList;
            });
          },
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
                    builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (query) => _filterPokemonList(query),
              ),
            ),
          Expanded(
            child: _filteredPokemonList.isEmpty
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
                    itemCount: _filteredPokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = _filteredPokemonList[index];
                      return PokemonCard(
                        pokemon: pokemon, // Solo pasamos el Pokémon aquí
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
