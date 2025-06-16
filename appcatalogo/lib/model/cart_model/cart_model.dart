// lib/models/cart.dart
import 'package:appcatalogo/model/cart_model/cart_item_model.dart'; // Ajuste o caminho

class Cart {
  final int id;
  final double totalAmount;
  final List<CartItem> items;

  Cart({required this.id, required this.totalAmount, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> cartItems = itemsList
        .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
        .toList();

    return Cart(
      id: json['id'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: cartItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
