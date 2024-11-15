import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/models/pokemon_model.dart'; // Asegúrate de importar el modelo correcto
import 'package:pokedexapp/widgets/pokemon_favorites.dart'; // Importar el widget FavoriteIcon

class DetailsScreen extends StatefulWidget {
  final Pokemon pokemon; // Recibe el Pokémon

  const DetailsScreen({super.key, required this.pokemon});

  @override
  State<StatefulWidget> createState() => _DetailsScreen();
}

class _DetailsScreen extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon; // Obtener Pokémon desde el widget

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(
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
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),
        actions: [
          FavoriteIcon(pokemon: pokemon, ), // Usar el widget FavoriteIcon aquí
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Image.network(
                pokemon.imageUrl, // Mostrar imagen del Pokémon
                height: 300,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pokemon.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Aquí añades el resto de las secciones (tipos, habilidades, estadísticas)
          ],
        ),
      ),
    );
  }
}
