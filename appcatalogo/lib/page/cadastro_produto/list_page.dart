import 'dart:convert';

import 'package:appcatalogo/model/food_model.dart';
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
        color: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (food.image == null || food.image!.isEmpty) {
      imageWidget = Image.network(
        'https://via.placeholder.com/150',
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (food.image!.startsWith('http')) {
      imageWidget = Image.network(
        food.image!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else {
      try {
        final bytes = base64Decode(food.image!);
        imageWidget = Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        );
      } catch (e) {
        imageWidget = Image.network(
          'https://via.placeholder.com/150',
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        );
      }
    }

    final controller = Get.find<FoodController>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
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
                          controller.deleteFood(food.id!);
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
    );
  }
}
