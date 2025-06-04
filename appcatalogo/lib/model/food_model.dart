class Food {
  final int? id; // Agora id é nullable
  final String name;
  final String description;
  final double price;

  Food({
    this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  Food copyWith({int? id, String? name, String? description, double? price}) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Food(id: $id, name: $name, description: $description, price: $price)';
  }
}
