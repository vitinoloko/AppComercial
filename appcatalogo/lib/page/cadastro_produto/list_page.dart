import 'dart:convert';
import 'package:appcatalogo/const/const.dart';
import 'package:appcatalogo/model/food_model.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.largura});
  final double largura;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodController>();

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: MediaQuery.of(context).size.width < 1100
            ? const BorderRadius.horizontal(right: Radius.circular(0))
            : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Obx(() {
        if (controller.foodList.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma comida cadastrada',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.foodList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
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
        );
      }),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  void _showFoodDetails(BuildContext context) {
    final cartController = Get.find<CartController>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.amber.shade900,
          title: Text(food.name),
          content: SizedBox(
            width: 450,
            height: 350,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: FoodImage(imageData: food.image),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Descrição: ${food.description}', style: corDialog),
                  const SizedBox(height: 8),
                  Text(
                    'Preço: R\$ ${food.price.toStringAsFixed(2)}',
                    style: corDialog,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () async {
                if (food.id == null) {
                  // Debug: Verifique se o ID da comida é nulo. Não deveria ser para adicionar.
                  print(
                    'ERRO: Food ID é nulo ao tentar adicionar ao carrinho!',
                  );
                  return;
                }
                print(
                  'Tentando adicionar ${food.name} (ID: ${food.id}) ao carrinho...',
                );
                await cartController.addItemToCart(food.id!, 1);
                Navigator.of(ctx).pop();
                // Verifique no console se esta snackbar aparece
              },
              child: const Text('Adicionar ao carrinho'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodController = Get.find<FoodController>();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            context.beamToNamed('/Cadastro/${food.id}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            foodController.deleteFood(food.id!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.purple,
                          ),
                          onPressed: () async {
                            if (food.id == null) {
                              // Debug: Verifique se o ID da comida é nulo.
                              print(
                                'ERRO: Food ID é nulo ao tentar adicionar ao carrinho diretamente!',
                              );
                              return;
                            }
                            print(
                              'Tentando adicionar ${food.name} (ID: ${food.id}) ao carrinho diretamente...',
                            );
                            final cartController = Get.find<CartController>();
                            await cartController.addItemToCart(food.id!, 1);
                          },
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
