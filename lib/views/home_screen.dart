import 'dart:convert'; // Para usar jsonEncode y jsonDecode
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/services/services.dart';
import 'package:pokedexapp/views/favorites_screen.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];

  @override
  void initState() {
    super.initState();
    _fetchPokemonList(); //Loading Pokemon List
  }

// Method to load the Pokémon list from SharedPreferences
  Future<void> _fetchPokemonList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pokemonListString = prefs.getString('pokemonList');

      if (pokemonListString != null) {
        final List<dynamic> pokemonListJson = jsonDecode(pokemonListString);
        final pokemonList =
            pokemonListJson.map((item) => Pokemon.fromJson(item)).toList();
        setState(() {
          _pokemonList = pokemonList;
          _filteredPokemonList = pokemonList; // Show list
        });
      } else {
// Method to load the Pokémon list from SharedPreferences
        await _loadPokemonFromApi();
      }
    } catch (e) {
      Text('Error al cargar Pokémon: $e');
    }
  }

  //  Method to load pokemons from an external API
  Future<void> _loadPokemonFromApi() async {
    final List<Pokemon> pokemonList = await PokemonService.fetchPokemonList();
    setState(() {
      _pokemonList = pokemonList;
      _filteredPokemonList = pokemonList;
    });
    _savePokemonList(pokemonList); // Save in Shared Preferences
  }

// Method to save the Pokémon list in SharedPreferences
  Future<void> _savePokemonList(List<Pokemon> pokemonList) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonListJson =
        jsonEncode(pokemonList.map((e) => e.toJson()).toList());
    await prefs.setString('pokemonList', pokemonListJson);
  }

  // To filter Pokemon List
  void _filterPokemonList(String query) {
    final filteredList = _pokemonList
        .where((pokemon) =>
            pokemon.name.contains(query))
        .toList();
    setState(() {
      _filteredPokemonList = filteredList;
    });
  }

  // Method to activate or deactivate search
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredPokemonList = _pokemonList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(
              () {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
                _filteredPokemonList = _pokemonList;
              },
            );
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Pokedex',
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
                      return PokemonCard(pokemon: pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
