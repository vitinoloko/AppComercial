import 'dart:convert';
import 'package:appcatalogo/model/cart.dart';
import 'package:flutter/foundation.dart'; // Importe para usar kDebugMode
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var currentCart = Rx<Cart?>(null);
  var isLoadingCart = false.obs;

  final String baseUrl = 'http://localhost:3000/cart';

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  // --- Métodos para interagir com a API do Carrinho ---

  Future<void> fetchCart() async {
    // Print 1: Indica o início da chamada
    if (kDebugMode) print('DEBUG: Chamando fetchCart() para $baseUrl');
    try {
      isLoadingCart.value = true;
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        currentCart.value = Cart.fromJson(data);
      } else if (response.statusCode == 404) {
        currentCart.value = Cart(id: 0, totalAmount: 0.0, items: []);
        // Print 2: Erro específico (carrinho não encontrado)
        if (kDebugMode) {
          print(
            'DEBUG: Carrinho não encontrado (404), inicializando vazio no frontend.',
          );
        }
      } else {
        // Print 2: Erro geral ao carregar
        if (kDebugMode) {
          print(
            'DEBUG: Falha ao carregar carrinho: ${response.statusCode} - ${response.body}',
          );
        }
        currentCart.value = null;
      }
    } catch (e) {
      // Print de exceção: Sempre importante
      if (kDebugMode) print('ERRO CRÍTICO em fetchCart(): $e');
      currentCart.value = null;
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> addItemToCart(int productId, int quantity) async {
    // Print 1: Indica a ação
    if (kDebugMode) {
      print(
        'DEBUG: Adicionando Produto ID: $productId, Quantidade: $quantity ao carrinho.',
      );
    }
    try {
      isLoadingCart.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        currentCart.value = Cart.fromJson(data);
      } else {
        // Print 2: Erro ao adicionar
        if (kDebugMode) {
          print(
            'DEBUG: Falha ao adicionar item: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      // Print de exceção: Sempre importante
      if (kDebugMode) print('ERRO CRÍTICO em addItemToCart(): $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> updateItemQuantity(int cartItemId, int newQuantity) async {
    // Print 1: Indica a ação
    if (kDebugMode) {
      print(
        'DEBUG: Atualizando Item ID: $cartItemId, Nova Quantidade: $newQuantity.',
      );
    }
    try {
      isLoadingCart.value = true;
      final response = await http.patch(
        Uri.parse('$baseUrl/item/$cartItemId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': newQuantity}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        currentCart.value = Cart.fromJson(data);
      } else if (response.statusCode == 204) {
        // No Content para remoção
        if (kDebugMode) {
          print(
            'DEBUG: Item removido via updateQuantity (status 204).',
          ); // Print 2: Informação de remoção
        }
        await fetchCart();
      } else {
        // Print 2: Erro ao atualizar
        if (kDebugMode) {
          print(
            'DEBUG: Falha ao atualizar quantidade: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      // Print de exceção: Sempre importante
      if (kDebugMode) print('ERRO CRÍTICO em updateItemQuantity(): $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> removeItemFromCart(int cartItemId) async {
    // Print 1: Indica a ação
    if (kDebugMode) print('DEBUG: Removendo Item ID: $cartItemId do carrinho.');
    try {
      isLoadingCart.value = true;
      final response = await http.delete(
        Uri.parse('$baseUrl/item/$cartItemId'),
      );

      if (response.statusCode == 204) {
        if (kDebugMode) {
          print(
            'DEBUG: Item ID $cartItemId removido (status 204).',
          ); // Print 2: Confirmação de remoção
        }
        await fetchCart();
      } else {
        // Print 2: Erro ao remover
        if (kDebugMode) {
          print(
            'DEBUG: Falha ao remover item: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      // Print de exceção: Sempre importante
      if (kDebugMode) print('ERRO CRÍTICO em removeItemFromCart(): $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  int get cartItemCount {
    return currentCart.value?.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        ) ??
        0;
  }
}
