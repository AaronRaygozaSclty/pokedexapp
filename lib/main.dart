import 'package:flutter/material.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/views/favorites_screen.dart';
import 'package:pokedexapp/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
