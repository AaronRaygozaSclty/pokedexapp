import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokedexapp/config/logs.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Pokemon> _favorites = [];
  List<Pokemon> get favorites => _favorites;

  // Loads the favorite Pokémon list from SharedPreferences
  Future<void> loadFavoritesFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritePokemonListString = prefs.getString('favoritePokemonList');

      if (favoritePokemonListString != null) {
        final List<dynamic> favoritePokemonListJson =
            jsonDecode(favoritePokemonListString);
        _favorites = favoritePokemonListJson
            .map((item) => Pokemon.fromJson(item))
            .toList();
        notifyListeners(); // Notify listeners to update the UI
      }
    } catch (e) {
      // Log error if the favorites fail to load
      Logs.p.e('Error loading favorite Pokémon: $e');
    }
  }
  

  // Saves the favorite Pokémon list to SharedPreferences
  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteListJson =
        jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString('favoritePokemonList', favoriteListJson);
  }

  // Toggles the favorite state of a Pokémon
  void toggleFavorite(Pokemon pokemon) {
    // Checks if the Pokémon is already in the favorites list
    if (isFavorite(pokemon)) {
      // If it is, remove it from the list
      _favorites.removeWhere((favPokemon) => favPokemon.id == pokemon.id);
      pokemon.isFavorite = false; // Update the Pokémon's favorite state
    } else {
      // If it's not in the list, add it
      _favorites.add(pokemon);
      pokemon.isFavorite = true; // Update the Pokémon's favorite state
    }
    notifyListeners(); // Notify listeners of the state change
    _saveFavoritesToPrefs(); // Save the updated list to SharedPreferences
  }

  // Checks if a Pokémon is in the favorites list
  bool isFavorite(Pokemon pokemon) {
    // Returns true if the Pokémon is in the list of favorites
    return _favorites.any((favPokemon) => favPokemon.id == pokemon.id);
  }

  // Updates the favorites list with a new list
  void updateFavorites(List<Pokemon> newFavorites) {
    _favorites = newFavorites;
    notifyListeners(); // Notify listeners (screens using this provider)
  }

  void loadFavoritesFromStorage(prefs) {}
}


