import 'dart:convert';
import 'package:appcatalogo/model/cart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var currentCart = Rx<Cart?>(null);
  var isLoadingCart = false.obs;

  final String baseUrl = 'http://localhost:3000/cart'; // VERIFIQUE ESTA URL!

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  // --- Métodos para interagir com a API do Carrinho ---

  Future<void> fetchCart() async {
    print('DEBUG: Chamando fetchCart() para $baseUrl');
    try {
      isLoadingCart.value = true;
      final response = await http.get(Uri.parse(baseUrl));

      print('DEBUG: fetchCart() - Status Code: ${response.statusCode}');
      print('DEBUG: fetchCart() - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('DEBUG: fetchCart() - Dados JSON decodificados: $data');
        currentCart.value = Cart.fromJson(data);
        print(
          'DEBUG: fetchCart() - Carrinho atualizado em currentCart.value: ${currentCart.value?.totalAmount}',
        );
      } else if (response.statusCode == 404) {
        currentCart.value = Cart(id: 0, totalAmount: 0.0, items: []);
        print(
          'DEBUG: Carrinho não encontrado no backend (404), inicializando carrinho vazio no frontend.',
        );
      } else {
        print(
          'DEBUG: Falha ao carregar o carrinho: ${response.statusCode} - ${response.body}',
        );
        currentCart.value = null;
      }
    } catch (e) {
      print('ERRO EM fetchCart(): $e');
      currentCart.value = null;
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> addItemToCart(int productId, int quantity) async {
    print(
      'DEBUG: Chamando addItemToCart. Produto ID: $productId, Quantidade: $quantity',
    );
    try {
      isLoadingCart.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );

      print('DEBUG: addItemToCart() - Status Code: ${response.statusCode}');
      print('DEBUG: addItemToCart() - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('DEBUG: addItemToCart() - Dados JSON decodificados: $data');
        currentCart.value = Cart.fromJson(data);
        print(
          'DEBUG: Item adicionado. Carrinho atualizado: ${currentCart.value?.totalAmount}',
        );
      } else {
        print(
          'DEBUG: Falha ao adicionar item: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('ERRO EM addItemToCart(): $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> updateItemQuantity(int cartItemId, int newQuantity) async {
    print(
      'DEBUG: Chamando updateItemQuantity. Item ID: $cartItemId, Nova Quantidade: $newQuantity',
    );
    try {
      isLoadingCart.value = true;
      final response = await http.patch(
        Uri.parse('$baseUrl/item/$cartItemId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': newQuantity}),
      );

      print(
        'DEBUG: updateItemQuantity() - Status Code: ${response.statusCode}',
      );
      print('DEBUG: updateItemQuantity() - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        currentCart.value = Cart.fromJson(data);
        print(
          'DEBUG: Quantidade atualizada. Carrinho: ${currentCart.value?.totalAmount}',
        );
      } else if (response.statusCode == 204) {
        print(
          'DEBUG: Item removido via updateQuantity (status 204). Recarregando carrinho...',
        );
        await fetchCart();
      } else {
        print(
          'DEBUG: Falha ao atualizar quantidade: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('ERRO EM updateItemQuantity(): $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> removeItemFromCart(int cartItemId) async {
    print('DEBUG: Chamando removeItemFromCart. Item ID: $cartItemId');
    try {
      isLoadingCart.value = true;
      final response = await http.delete(
        Uri.parse('$baseUrl/item/$cartItemId'),
      );

      print(
        'DEBUG: removeItemFromCart() - Status Code: ${response.statusCode}',
      );
      print('DEBUG: removeItemFromCart() - Response Body: ${response.body}');

      if (response.statusCode == 204) {
        print('DEBUG: Item removido (status 204). Recarregando carrinho...');
        await fetchCart();
      } else {
        print(
          'DEBUG: Falha ao remover item: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('ERRO EM removeItemFromCart(): $e');
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
