class Pokemon {
  final String name;
  final String url;
  final int id;
  final String imageUrl;
  bool isFavorite;  // Nueva propiedad para marcar como favorito

  // Constructor modificado para incluir `isFavorite`
  Pokemon({
    required this.name,
    required this.url,
    required this.isFavorite, // Inicializamos como `false` por defecto
  })  : id = int.parse(url.split('/')[6]),  // Obtiene el ID del URL
        imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${url.split('/')[6]}.png';

  // Método para crear un Pokemon desde JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
      isFavorite: json['isFavorite'] ?? false, // Usamos el valor por defecto `false`
    );
  }
}
