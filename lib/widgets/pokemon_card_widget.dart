import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/views/details_screen.dart';
import 'package:pokedexapp/widgets/pokemon_favorites.dart'; // Importa el widget aquí

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(pokemon: pokemon),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  pokemon.imageUrl,
                  width: 120,
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    pokemon.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -4,
              right: -8,
              child: FavoriteIcon(
                pokemon: pokemon,
              ), // Usa el widget aquí
            ),
          ],
        ),
      ),
    );
  }
}
