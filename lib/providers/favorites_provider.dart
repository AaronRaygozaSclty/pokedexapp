import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Pokemon> _favorites = [];

  List<Pokemon> get favorites => _favorites;

  void toggleFavorite(Pokemon pokemon) {
    if (_favorites.contains(pokemon)) {
      _favorites.remove(pokemon);
    } else {
      _favorites.add(pokemon);
    }
    notifyListeners();
  }

  bool isFavorite(Pokemon pokemon) {
    return _favorites.contains(pokemon);
  }
}
