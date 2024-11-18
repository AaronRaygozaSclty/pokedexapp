import 'package:flutter/material.dart';

class AppColors {
  // General Colors
  static const Color primaryColor = Color.fromARGB(255, 162, 26, 26);
  static const Color whiteText = Colors.white;

  //Map of types and corresponding colors
  static const Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'bug': Colors.greenAccent,
    'normal': Colors.grey,
    'poison': Colors.purple,
    'fairy': Colors.pink,
    'ghost': Colors.deepPurple,
    'fighting': Colors.brown,
    'psychic': Colors.pinkAccent,
    'rock': Colors.orange,
    'ground': Colors.brown,
    'ice': Colors.lightBlue,
    'dragon': Colors.deepOrange,
    'dark': Colors.black,
    'steel': Colors.blueGrey,
    'flying': Colors.indigo,
  };

// Function to get the type's color

  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}
