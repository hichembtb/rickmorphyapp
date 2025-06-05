class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String gender;
  final String location;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.gender,
    required this.location,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      location: json['location']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'gender': gender,
      'location': {'name': location},
    };
  }
}
