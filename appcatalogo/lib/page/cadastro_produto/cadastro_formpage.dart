import 'package:appcatalogo/model/food_model.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroFormpage extends StatelessWidget {
  final double largura;
  final int? id;

  CadastroFormpage({super.key, required this.largura, this.id});

  final FoodController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Se id é nulo ou 0, é cadastro novo, não precisa carregar dados
    if (id == null || id == 0) {
      return _form(context, null);
    }

    return FutureBuilder<Food?>(
      future: controller.getFoodById(id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: largura,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: largura,
            child: Center(
              child: Text('Erro ao carregar produto: ${snapshot.error}'),
            ),
          );
        } else {
          final food = snapshot.data;
          return _form(context, food);
        }
      },
    );
  }

  Widget _form(BuildContext context, Food? food) {
    final nameController = TextEditingController(text: food?.name ?? '');
    final descriptionController = TextEditingController(
      text: food?.description ?? '',
    );
    final priceController = TextEditingController(
      text: food != null ? food.price.toString() : '',
    );

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: MediaQuery.of(context).size.width < 1100
            ? const BorderRadius.horizontal(right: Radius.circular(0))
            : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descrição'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Preço'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              final foodToSave = Food(
                id: id, // agora id pode ser null
                name: nameController.text,
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 0,
              );

              if (id != null) {
                controller.updateFood(foodToSave);
              } else {
                controller.addFood(foodToSave);
              }

              context.beamToNamed('/Interface');
            },
            child: Text(id != null ? 'Atualizar' : 'Cadastrar'),
          ),
        ],
      ),
    );
  }
}
