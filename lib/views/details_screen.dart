import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/models/pokemon_model.dart'; // Asegúrate de importar el modelo correcto
import 'package:pokedexapp/services/services.dart'; // Importar el servicio para obtener los detalles
import 'package:pokedexapp/widgets/details_widget.dart';
import 'package:pokedexapp/widgets/pokemon_favorites.dart';

class DetailsScreen extends StatefulWidget {
  final Pokemon pokemon;

  const DetailsScreen({super.key, required this.pokemon});

  @override
  State<StatefulWidget> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<Pokemon> _pokemonDetails;

  @override
  void initState() {
    super.initState();
// Call the method to get the Pokémon details
    _pokemonDetails = PokemonService.fetchPokemonDetails(widget.pokemon.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            color: AppColors.whiteText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FavoriteIcon(pokemon: widget.pokemon), //Favorite Widget
        ],
      ),
      body: FutureBuilder<Pokemon>(
        future: _pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('No se encontraron detalles del Pokémon'));
          }

          final pokemon = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pokemon Image
                Center(
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 250,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                // Header  and number
                Center(
                  child: Text(
                    '${pokemon.name.toUpperCase()} (#${pokemon.number})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: DetailsWidget(pokemon: pokemon)) //Details Widget
              ],
            ),
          );
        },
      ),
    );
  }
}
