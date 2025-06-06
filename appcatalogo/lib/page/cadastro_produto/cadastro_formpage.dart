// Importações necessárias
import 'dart:convert'; // Para conversão de imagens base64
import 'package:appcatalogo/model/extendedimageeditor.dart'; // Editor de imagem
import 'package:appcatalogo/model/food_model.dart'; // Modelo da comida
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart'; // Controller com a lógica
import 'package:beamer/beamer.dart'; // Navegação
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Gerenciamento de estado

// Componente Stateless do formulário de cadastro/edição
class CadastroFormpage extends StatelessWidget {
  final double largura; // Largura do componente
  final int? id; // ID do item, se for edição

  CadastroFormpage({super.key, required this.largura, this.id});

  // Instancia o controller já criado no GetX
  final FoodController controller = Get.find();

  // Controladores para os campos de texto
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  // Carrega os dados do item se estiver editando
  Future<void> carregarDados() async {
    if (id != null && id != 0) {
      final food = await controller.getFoodById(id!); // Busca item pelo ID
      if (food != null) {
        // Preenche os campos com os dados existentes
        nameController.text = food.name;
        descriptionController.text = food.description;
        priceController.text = food.price.toString();

        // Se houver imagem, converte de base64 e define no estado
        if (food.image != null) {
          try {
            controller.webImage.value = base64Decode(food.image!);
          } catch (_) {
            controller.webImage.value = null; // Falha na decodificação
          }
        } else {
          controller.webImage.value = null;
        }
      }
    } else {
      // Se for novo cadastro, limpa tudo
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      controller.webImage.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Espera os dados serem carregados antes de mostrar a tela
    return FutureBuilder(
      future: carregarDados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostra loading enquanto carrega
          return const Center(child: CircularProgressIndicator());
        }

        // Stack permite sobrepor widgets (usado para o pop-up do editor)
        return Stack(
          children: [
            // Conteúdo principal do formulário
            Container(
              width: largura, // Largura passada por parâmetro
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green, // Fundo verde
                borderRadius: MediaQuery.of(context).size.width < 1100
                    ? const BorderRadius.horizontal(right: Radius.circular(0))
                    : const BorderRadius.horizontal(right: Radius.circular(12)),
              ),
              child: Column(
                children: [
                  // Campo de nome
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  // Campo de descrição
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                  // Campo de preço
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Botão para selecionar imagem
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await controller.pickImage();
                      if (picked != null) {
                        controller.webImage.value = picked;
                        controller.mostrarEditor.value = true; // Abre o editor
                      }
                    },
                    child: const Text('Selecionar imagem'),
                  ),

                  const SizedBox(height: 12),

                  // Mostra imagem selecionada (se houver) e se o editor não estiver aberto
                  Obx(() {
                    if (controller.webImage.value != null &&
                        !controller.mostrarEditor.value) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(
                            image: MemoryImage(controller.webImage.value!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const SizedBox(height: 20),

                  // Botão de cadastrar/atualizar
                  ElevatedButton(
                    onPressed: () async {
                      final food = Food(
                        id: id,
                        name: nameController.text,
                        description: descriptionController.text,
                        price: double.tryParse(priceController.text) ?? 0,
                      );

                      // Atualiza ou adiciona conforme o caso
                      if (id != null && id != 0) {
                        if (controller.webImage.value != null) {
                          await controller.updateFoodWithImage(
                            food,
                            controller.webImage.value!,
                          );
                        } else {
                          await controller.updateFood(food);
                        }
                      } else {
                        if (controller.webImage.value != null) {
                          await controller.addFoodWithImage(
                            food,
                            controller.webImage.value!,
                          );
                        } else {
                          await controller.addFood(food);
                        }
                      }

                      // Vai para a interface principal após salvar
                      context.beamToNamed('/Interface');
                    },
                    child: Text(
                      id != null && id != 0 ? 'Atualizar' : 'Cadastrar',
                    ),
                  ),
                ],
              ),
            ),

            // POP-UP com o editor de imagem
            Obx(() {
              // Só mostra se o editor estiver ativado
              if (controller.mostrarEditor.value &&
                  controller.webImage.value != null) {
                return Positioned.fill(
                  child: Material(
                    color: Colors.black.withOpacity(0.85),
                    child: Stack(
                      children: [
                        // Container com editor centralizado verticalmente
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ImageEditorWidget(
                              imageBytes: controller.webImage.value!,
                              onImageCropped: (cropped, size) {
                                controller.webImage.value = cropped;
                                controller.mostrarEditor.value = false;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink(); // Retorna vazio se não for pra mostrar
            }),
          ],
        );
      },
    );
  }
}
