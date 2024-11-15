import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedexapp/models/pokemon_model.dart';

class PokemonService {
  static Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((data) => Pokemon.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar la lista de Pokémon');
    }
  }
}
