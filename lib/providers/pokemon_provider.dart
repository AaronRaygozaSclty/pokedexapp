import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokedexapp/config/logs.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];

  List<Pokemon> get pokemonList => _pokemonList;
  List<Pokemon> get filteredPokemonList => _filteredPokemonList;

  // Carga la lista de Pokémon
  Future<void> fetchPokemonList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pokemonListString = prefs.getString('pokemonList');

      if (pokemonListString != null) {
        final List<dynamic> pokemonListJson = jsonDecode(pokemonListString);
        _pokemonList =
            pokemonListJson.map((item) => Pokemon.fromJson(item)).toList();
        _filteredPokemonList = _pokemonList;
        notifyListeners();
      } else {
        await _loadPokemonFromApi();
      }
    } catch (e) {
      Logs.p.e('Error loading Pokemon: $e');
    }
  }

  // Carga favoritos y actualiza la lista
  Future<void> fetchFavoritePokemonList(
      FavoritesProvider favoritesProvider) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritePokemonListString = prefs.getString('favoritePokemonList');

      if (favoritePokemonListString != null) {
        final List<dynamic> favoritePokemonListJson =
            jsonDecode(favoritePokemonListString);
        final favoritePokemonList = favoritePokemonListJson
            .map((item) => Pokemon.fromJson(item))
            .toList();
        favoritesProvider.updateFavorites(favoritePokemonList);
        updateFavoritesList(favoritesProvider);
      }
    } catch (e) {
      Logs.p.e('Error loading pokemon favorites: $e');
    }
  }

  // Actualiza el estado de favoritos
  void updateFavoritesList(FavoritesProvider favoritesProvider) {
    for (var pokemon in _pokemonList) {
      pokemon.isFavorite = favoritesProvider.isFavorite(pokemon);
    }
    _filteredPokemonList = _pokemonList;
    notifyListeners();
  }

  // Filtra Pokémon según el query
  void filterPokemonList(String query) {
    print('Filtrando: $query');
    if (query.isEmpty) {
      _filteredPokemonList = _pokemonList;
    } else {
      _filteredPokemonList = _pokemonList
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Carga desde la API y guarda en SharedPreferences
  Future<void> _loadPokemonFromApi() async {
    final List<Pokemon> pokemonList = await PokemonService.fetchPokemonList();
    _pokemonList = pokemonList;
    _filteredPokemonList = pokemonList;
    notifyListeners();
    _savePokemonList(pokemonList);
  }

  // Guarda la lista en SharedPreferences
  Future<void> _savePokemonList(List<Pokemon> pokemonList) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonListJson =
        jsonEncode(pokemonList.map((e) => e.toJson()).toList());
    await prefs.setString('pokemonList', pokemonListJson);
  }
}
