// lib/models/cart_item.dart
import 'package:appcatalogo/model/food_model.dart'; // Ajuste o caminho

class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final Food? product;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      product: json['product'] != null
          ? Food.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
