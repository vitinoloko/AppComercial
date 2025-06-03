import 'package:appcatalogo/model/food_model.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroFormpage extends StatelessWidget {
  const CadastroFormpage({super.key, required this.largura});
  final double largura;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodController>();

    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();

    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: MediaQuery.of(context).size.width < 1100
            ? const BorderRadius.horizontal(right: Radius.circular(0))
            : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Cadastro de Comida',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preço',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    descController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  Get.snackbar('Erro', 'Preencha todos os campos');
                  return;
                }

                final food = Food(
                  name: nameController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                );

                controller.addFood(food);

                nameController.clear();
                descController.clear();
                priceController.clear();
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
