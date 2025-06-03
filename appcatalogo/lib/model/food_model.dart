class Food {
  final int? id;
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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'price': price};
  }
}
