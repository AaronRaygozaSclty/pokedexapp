class Pokemon {
  final String name;
  final String url;
  final int id; // Se recibe directamente
  final String imageUrl; // Calculado directamente usando el id
  bool isFavorite;
  final String type;
  final int number;
  final String ability;
  final int height;
  final int weight;

  Pokemon({
    required this.name,
    required this.url,
    required this.id,
    required this.isFavorite,
    required this.type,
    required this.number,
    required this.ability,
    required this.height,
    required this.weight,
  }) : imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'id': id,
      'isFavorite': isFavorite,
      'type': type,
      'number': number,
      'ability': ability,
      'height': height,
      'weight': weight,
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Derivar el id del URL si no se pasa explícitamente
    final String url = json['url'];
    final int id = int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;

    return Pokemon(
      name: json['name'],
      url: url,
      id: json['id'] ?? id,
      isFavorite: json['isFavorite'] ?? false,
      type: json['type'] ?? '',
      number: json['number'] ?? 0,
      ability: json['ability'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }
}
