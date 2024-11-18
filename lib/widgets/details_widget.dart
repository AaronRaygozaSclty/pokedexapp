import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/widgets/type_color_widget.dart';

//Widget to show details
class DetailsWidget extends StatefulWidget {
  const DetailsWidget({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),

        TypeWidget(type: widget.pokemon.type), //TypeWidget

        const SizedBox(height: 8),
        Text(
//Ability
          'Ability: ${widget.pokemon.ability}',
          style: const TextStyle(fontSize: 18),
        ),
//Number
        const SizedBox(height: 8),
        Text(
          'Number: #${widget.pokemon.number}',
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 8),
//Weight
        Text(
          'Height: ${widget.pokemon.height} m',
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 8),
//Weight
        Text(
          'Weight: ${widget.pokemon.weight} kg',
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
