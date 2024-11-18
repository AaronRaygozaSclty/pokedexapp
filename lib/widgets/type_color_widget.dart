import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';

// This widget displays a Pokémon type with its corresponding color.
// If the type is empty, it shows 'Tipo desconocido' (Unknown Type).
// The color for each type is retrieved from the AppColors class.
class TypeWidget extends StatelessWidget {
  final String type;
  const TypeWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type.isEmpty) {
      return const Text('Type Unknown');
    }

    // Get the corresponding color for the type
    Color typeColor = AppColors.getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: typeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
