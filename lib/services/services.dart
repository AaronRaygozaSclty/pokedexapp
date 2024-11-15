import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedexapp/models/pokemon_model.dart';

class PokemonService {
  // Método para obtener la lista de Pokémon
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

  // Método para obtener detalles de un Pokémon por su URL
  static Future<Pokemon> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Pokemon.fromJson({
        'name': data['name'],
        'url': url,
        'type': data['types'][0]['type']['name'],
        'number': data['id'],
        'ability': data['abilities'][0]['ability']['name'],
        'height': data['height'],
        'weight': data['weight'],
        'isFavorite': false,
      });
    } else {
      throw Exception('Error al cargar los detalles del Pokémon');
    }
  }
}
