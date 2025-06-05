class FavoriteCharacter {
  final int id;
  final String name;
  final String image;
  final String status;

  FavoriteCharacter({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
  });

  factory FavoriteCharacter.fromJson(Map<String, dynamic> json) {
    return FavoriteCharacter(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'status': status};
  }
}
