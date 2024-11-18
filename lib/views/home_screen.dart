import 'dart:convert';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/config/logs.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/services/services.dart';
import 'package:pokedexapp/views/favorites_screen.dart';
import 'package:pokedexapp/widgets/pokemon_card_widget.dart';
import 'package:provider/provider.dart';
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
  final FocusNode _searchFocusNode =
      FocusNode(); // Agregado para gestionar el foco
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
    _fetchFavoritePokemonList();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); 
    _searchController.dispose();
    super.dispose();
  }

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
          _filteredPokemonList = pokemonList;
        });
        _updateFavoritesList();
      } else {
        await _loadPokemonFromApi();
      }
    } catch (e) {
      Logs.p.e('Error loading Pokemon: $e');
    }
  }

  Future<void> _fetchFavoritePokemonList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritePokemonListString = prefs.getString('favoritePokemonList');

      if (favoritePokemonListString != null) {
        final List<dynamic> favoritePokemonListJson =
            jsonDecode(favoritePokemonListString);
        final favoritePokemonList = favoritePokemonListJson
            .map((item) => Pokemon.fromJson(item))
            .toList();

        if (mounted) {
          final favoritesProvider =
              Provider.of<FavoritesProvider>(context, listen: false);
          favoritesProvider.updateFavorites(favoritePokemonList);
          _updateFavoritesList();
        }
      }
    } catch (e) {
      Logs.p.e('Error loading pokemon favorites$e');
    }
  }

  void _updateFavoritesList() {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    setState(() {
      for (var pokemon in _pokemonList) {
        pokemon.isFavorite = favoritesProvider.isFavorite(pokemon);
      }
      _filteredPokemonList = _pokemonList;
    });
  }

  Future<void> _loadPokemonFromApi() async {
    final List<Pokemon> pokemonList = await PokemonService.fetchPokemonList();
    setState(() {
      _pokemonList = pokemonList;
      _filteredPokemonList = pokemonList;
    });
    _savePokemonList(pokemonList);
  }

  Future<void> _savePokemonList(List<Pokemon> pokemonList) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonListJson =
        jsonEncode(pokemonList.map((e) => e.toJson()).toList());
    await prefs.setString('pokemonList', pokemonListJson);
  }

  void _filterPokemonList(String query) {
    final filteredList =
        _pokemonList.where((pokemon) => pokemon.name.contains(query)).toList();
    setState(() {
      _filteredPokemonList = filteredList;
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
            setState(() {
              _isSearching = !_isSearching;
              if (_isSearching) {
                Future.delayed(
                  const Duration(milliseconds: 100),
                );
                _searchFocusNode.requestFocus(); 
              } else {
                _searchController.clear();
                _searchFocusNode
                    .unfocus(); 
                _filteredPokemonList = _pokemonList;
              }
            });
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
                  builder: (context) => const FavoritesScreen(),
                ),
              ).then((_) {
                if (!mounted) return;
                final favoritesProvider =
                    Provider.of<FavoritesProvider>(context, listen: false);

                setState(() {
                  for (var pokemon in _pokemonList) {
                    pokemon.isFavorite = favoritesProvider.isFavorite(pokemon);
                  }
                  _filteredPokemonList = _pokemonList;
                });
              });
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
                focusNode: _searchFocusNode, 
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
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
