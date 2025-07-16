/// Modelo que representa un personaje de la API de Rick and Morty.
class Character {
  final int? id;
  final String? name; 
  final String? image;
  final String? status;
  final String? species;
  final Origin? origin; 
  final Location? location; 
  final List<String>? episode; 

  /// Constructor del modelo [Character].
  Character({
    this.id,
    this.name,
    this.image,
    this.status,
    this.species,
    this.origin,
    this.location,
    this.episode,
  });

  /// Constructor factory para crear un [Character] desde un JSON.
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      species: json['species'],
      origin: json['origin'] != null ? Origin.fromJson(json['origin']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      episode: json['episode'] != null ? List<String>.from(json['episode']) : <String>[],
    );
  }
}

/// Modelo que representa el origen de un personaje.
class Origin {
  final String? name; // Nombre del lugar de origen.
  final String? url; // URL con más información del origen.

  /// Constructor del modelo [Origin].
  Origin({this.name, this.url});

  /// Constructor factory para crear un [Origin] desde un JSON.
  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      name: json['name'],
      url: json['url'],
    );
  }
}

/// Modelo que representa la ubicación actual de un personaje.
class Location {
  final String? name; // Nombre de la ubicación.
  final String? url; // URL con más información de la ubicación.

  /// Constructor del modelo [Location].
  Location({this.name, this.url});

  /// Constructor factory para crear un [Location] desde un JSON.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      url: json['url'],
    );
  }
}
