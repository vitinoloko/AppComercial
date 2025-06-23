import 'dart:convert';
import 'package:appcatalogo/const/const.dart';
import 'package:appcatalogo/model/food/food_model.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.largura});
  final double largura;

  @override
  Widget build(BuildContext context) {
    final FoodController controller = Get.find<FoodController>();

    // Garante que fetchFoods seja chamado se a lista estiver vazia e não estiver carregando
    // ou se o Beamer acabou de reconstruir e precisa garantir os dados.
    // Esta linha pode ser crítica para garantir que os dados estejam sendo buscados.
    if (controller.foodList.isEmpty && !controller.isLoading.value) {
      controller.fetchFoods();
    }

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: MediaQuery.of(context).size.width < 1200
            ? const BorderRadius.horizontal(right: Radius.circular(0))
            : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Obx(() {
        // --- NOVO: Tratamento do estado de carregamento ---
        if (controller.isLoading.value && controller.foodList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ), // Mostra carregamento
          );
        }

        if (controller.foodList.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum produto encontrado. Adicione um novo!', // Mensagem para lista vazia após carregar
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchFoods(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.foodList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
              mainAxisExtent: 170,
            ),
            itemBuilder: (context, index) {
              final food =
                  controller.foodList[controller.foodList.length - 1 - index];
              return FoodCard(food: food);
            },
          ),
        );
      }),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  void _showFoodDetails(BuildContext context) {
    // Define o limite máximo de caracteres para o nome.
    const int nameCharLimit = 25; // Você pode ajustar este valor

    showDialog(
      context: context,
      builder: (ctx) {
        String displayedName = food.name;
        // Verifica se o nome é maior que o limite e o trunca se necessário
        if (displayedName.length > nameCharLimit) {
          displayedName = '${displayedName.substring(0, nameCharLimit)}...';
        }

        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            displayedName,
            style: corPedido,
            textAlign: TextAlign.center,
          ), // <--- APLICAÇÃO DO NOME LIMITADO AQUI
          content: SizedBox(
            width: 450,
            height: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FoodImage(imageData: food.image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(155, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(food.description, style: corDialog),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity, // Ocupa toda a largura do Dialog
              height:
                  90, // Altura suficiente para os botões quebrarem a linha se necessário
              child: Stack(
                alignment: Alignment
                    .centerLeft, // Alinha os filhos ao centro por padrão
                children: [
                  // Widget 1: O Preço (ficará no centro do Stack)
                  Text(
                    'R\$ ${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  // Widget 2: Os Botões (alinhados à direita)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8.0, // Espaçamento horizontal entre os botões
                      runSpacing:
                          8.0, // Espaçamento vertical se os botões quebrarem a linha
                      children: [
                        botaoForm(
                          'Carrinho',
                          iconM: Icons.add_shopping_cart,
                          iconMcor: Colors.lightGreenAccent,
                          () async {
                            if (food.id == null) {
                              if (kDebugMode) print('ERRO: Food ID é nulo!');
                              return;
                            }
                            final cartController = Get.find<CartController>();
                            await cartController.addItemToCart(food.id!, 1);
                            Navigator.of(ctx).pop();
                          },
                        ),
                        botaoForm(
                          'Fechar',
                          iconM: Icons.close,
                          iconMcor: Colors.redAccent,
                          () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodController = Get.find<FoodController>();
    final cartController = Get.find<CartController>();

    return GestureDetector(
      onTap: () => _showFoodDetails(context),
      child: Card(
        // ... (resto do FoodCard igual)
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FoodImage(imageData: food.image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${food.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Row(
                            children: [
                              tooltipForm(
                                'Editar',
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    context.beamToNamed('/Cadastro/${food.id}');
                                  },
                                ),
                              ),
                              tooltipForm(
                                'Deletar',
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await foodController.deleteFood(food.id!);
                                    await cartController.fetchCart();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodImage extends StatelessWidget {
  final String? imageData;

  const FoodImage({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    if (imageData == null || imageData!.isEmpty) {
      return Container(
        width: 120,
        height: 120,
        color: Colors.grey[300],
        child: const Icon(Icons.fastfood, size: 48, color: Colors.grey),
      );
    }

    if (imageData!.startsWith('http')) {
      return Image.network(
        imageData!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        gaplessPlayback: true,
      );
    }

    try {
      final bytes = base64Decode(imageData!);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        gaplessPlayback: true,
      );
    } catch (_) {
      return Container(
        width: 120,
        height: 120,
        color: Colors.grey[300],
        child: const Icon(Icons.fastfood, size: 48, color: Colors.grey),
      );
    }
  }
}
