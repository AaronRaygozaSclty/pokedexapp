import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Pokemon> _favorites = [];
  List<Pokemon> get favorites => _favorites;

  // Método para cargar los favoritos desde SharedPreferences
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
        notifyListeners(); // Notificamos a los listeners para que se actualice la UI
      }
    } catch (e) {
      Text('Error al cargar los Pokémon favoritos: $e');
    }
  }

  // Método para guardar los favoritos en SharedPreferences
  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteListJson =
        jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString('favoritePokemonList', favoriteListJson);
  }

  // Método para alternar el estado de favorito de un Pokémon
  void toggleFavorite(Pokemon pokemon) {
    // Verifica si el Pokémon ya está en los favoritos
    if (isFavorite(pokemon)) {
      // Si está en los favoritos, lo eliminamos
      _favorites.removeWhere((favPokemon) => favPokemon.id == pokemon.id);
      pokemon.isFavorite = false; // Actualiza el estado en el objeto Pokemon
    } else {
      // Si no está en los favoritos, lo agregamos
      _favorites.add(pokemon);
      pokemon.isFavorite = true; // Actualiza el estado en el objeto Pokemon
    }
    notifyListeners(); // Notifica a los listeners que el estado cambió
    _saveFavoritesToPrefs(); // Guarda los cambios en SharedPreferences
  }

  // Verifica si un Pokémon está en los favoritos
  bool isFavorite(Pokemon pokemon) {
    // Verifica si el Pokémon está en la lista de favoritos
    return _favorites.any((favPokemon) => favPokemon.id == pokemon.id);
  }

  // Actualiza la lista de favoritos
  void updateFavorites(List<Pokemon> newFavorites) {
    _favorites = newFavorites;
    notifyListeners(); // Notifica a los listeners (pantallas que usan este provider)
  }
}
