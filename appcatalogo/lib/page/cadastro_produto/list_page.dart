import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
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

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(16),
          itemCount: controller.foodList.length,
          itemBuilder: (context, index) {
            final item = controller.foodList[index];

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Text('R\$ ${item.price.toStringAsFixed(2)}'),
              ),
            );
          },
        );
      }),
    );
  }
}
