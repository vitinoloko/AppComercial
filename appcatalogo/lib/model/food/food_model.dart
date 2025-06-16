class Food {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? image; // ✅ Adiciona imagem

  Food({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
