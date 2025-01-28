import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedexapp/config/config.dart';
import 'package:pokedexapp/providers/favorites_provider.dart';
import 'package:pokedexapp/providers/pokemon_provider.dart';
import 'package:pokedexapp/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final favoritesProvider = FavoritesProvider();
  favoritesProvider.loadFavoritesFromStorage(prefs);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PokemonProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
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
    );
  }
}
