class Pokemon {
  final String name;
  final String url;
  final int id; 
  final String imageUrl; 
  final String type;
  final int number;
  final String ability;
  final int height;
  final int weight;
  bool isFavorite; 

  Pokemon({
    required this.name,
    required this.url,
    required this.id,
    required this.type,
    required this.number,
    required this.ability,
    required this.height,
    required this.weight,
    this.isFavorite = false, 
  }) : imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'id': id,
      'type': type,
      'number': number,
      'ability': ability,
      'height': height,
      'weight': weight,
      'isFavorite': isFavorite, 
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final String url = json['url'];
    final int id =
        int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;

    return Pokemon(
      name: json['name'],
      url: url,
      id: json['id'] ?? id,
      type: json['type'] ?? '',
      number: json['number'] ?? 0,
      ability: json['ability'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      isFavorite: json['isFavorite'] ?? false, 
    );
  }
}
