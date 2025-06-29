import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.largura});
  final double largura;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: MediaQuery.of(context).size.width < 1200
            ? const BorderRadius.horizontal(right: Radius.circular(0))
            : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            width: largura,
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: MediaQuery.of(context).size.width < 1200
                  ? const BorderRadius.horizontal(right: Radius.circular(0))
                  : const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: const Text(
                    'Meu Carrinho',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (!GetPlatform.isMobile)
                  IconButton(
                    onPressed: () {
                      cartController.fetchCart();
                    },
                    icon: Icon(Icons.refresh, color: Colors.white, size: 35),
                  ),
              ],
            ),
          ),
          Obx(() {
            if (cartController.isLoadingCart.value) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final cart = cartController.currentCart.value;

            if (cart == null || cart.items.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    'Seu carrinho está vazio!',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ),
              );
            }

            return Expanded(
              child: RefreshIndicator(
                onRefresh: () => cartController.fetchCart(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final foodName =
                        item.product?.name ?? 'Produto Desconhecido';
                    final itemTotalPrice = item.price * item.quantity;

                    return Card(
                      key: ValueKey(item.id),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.blueGrey[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // <-- Esta é a Row que provavelmente está transbordando
                          children: [
                            // Imagem do produto - manter tamanho fixo
                            SizedBox(
                              width: 100,
                              height: 100,
                              child:
                                  item.product?.image != null &&
                                      item.product!.image!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.memory(
                                        base64Decode(item.product!.image!),
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(
                                        Icons.fastfood,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            // Detalhes do Produto - Envolvemos com Expanded
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foodName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${item.price.toStringAsFixed(2)} / un.',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Total: R\$ ${itemTotalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.lightGreenAccent,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Botões de Quantidade e Excluir - Envolvemos com Row (já está) e garantimos que os ícones caibam
                            Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Garante que a Row ocupe apenas o espaço necessário
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ), // Tamanho reduzido
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      cartController.updateItemQuantity(
                                        item.id,
                                        item.quantity - 1,
                                      );
                                    } else {
                                      cartController.removeItemFromCart(
                                        item.id,
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ), // Tamanho reduzido
                                  onPressed: () {
                                    cartController.updateItemQuantity(
                                      item.id,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(122, 0, 0, 0),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Obx(
              () => Column(
                // MUDANÇA: Row -> Column
                mainAxisSize:
                    MainAxisSize.min, // Para a coluna ocupar o mínimo de altura
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Para os textos ocuparem toda a largura
                children: [
                  const Text(
                    'Total do Carrinho:',
                    style: TextStyle(
                      fontSize: 18, // Fonte um pouco menor para harmonizar
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4), // Pequeno espaço entre eles
                  Text(
                    'R\$ ${cartController.currentCart.value?.totalAmount.toStringAsFixed(2) ?? '0.00'}',
                    textAlign: TextAlign.right, // Alinha o preço à direita
                    style: const TextStyle(
                      fontSize: 22, // Damos mais destaque ao preço
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
