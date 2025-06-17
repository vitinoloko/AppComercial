import 'dart:convert';

import 'package:appcatalogo/const/const.dart';
import 'package:appcatalogo/const/extendedimageeditor.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroFormpage extends StatelessWidget {
  final double largura;
  final int? id;

  const CadastroFormpage({super.key, required this.largura, this.id});

  @override
  Widget build(BuildContext context) {
    final FoodController controller = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFoodForEditing(id);
    });

    return Obx(() {
      if (!controller.dadosCarregadosForm.value) {
        return Container(
          width: largura,
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: MediaQuery.of(context).size.width < 1200
                ? const BorderRadius.horizontal(right: Radius.circular(0))
                : const BorderRadius.horizontal(right: Radius.circular(12)),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      return Stack(
        children: [
          Container(
            width: largura,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: MediaQuery.of(context).size.width < 1200
                  ? const BorderRadius.horizontal(right: Radius.circular(0))
                  : const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
            child: Column(
              children: [
                textFormTypeK(
                  largura,
                  'nome',
                  Icons.receipt_long,
                  Colors.white,
                  info: 'Nome do Produto Ex: Lanche..',
                  controller: controller.nameTextController,
                ),
                textFormTypeK(
                  largura,
                  'obs',
                  Icons.info_outline,
                  Colors.white,
                  info: 'Descrição Ex: Carne 150G...',
                  controller: controller.descriptionTextController,
                ),
                textFormValueK(
                  largura,
                  'valor',
                  Icons.sell,
                  Colors.white,
                  apenasValor: true,
                  controller: controller.priceMaskedController,
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () async {
                    final picked = await controller.pickImage();
                    if (picked != null) {
                      controller.webImage.value = picked;
                      controller.mostrarEditor.value = true;
                    }
                  },
                  child: Obx(() {
                    Uint8List? imageBytesToDisplay;

                    // Prioriza a imagem recém-selecionada (webImage)
                    if (controller.webImage.value != null &&
                        !controller.mostrarEditor.value) {
                      imageBytesToDisplay = controller.webImage.value;
                    }
                    // Caso contrário, tenta usar a imagem pré-existente do item sendo editado
                    else if (controller.foodBeingEdited.value?.image != null &&
                        !controller.mostrarEditor.value) {
                      try {
                        // Decodifica a string Base64 para Uint8List
                        imageBytesToDisplay = base64Decode(
                          controller.foodBeingEdited.value!.image!,
                        );
                      } catch (e) {
                        // Imprime o erro se a decodificação falhar
                        if (kDebugMode) {
                          print('Erro ao decodificar imagem Base64: $e');
                        }
                        // Se houver erro, imageBytesToDisplay permanecerá nulo, levando ao placeholder de erro
                      }
                    }

                    // Se houver bytes de imagem para exibir, mostra o Container com a imagem
                    if (imageBytesToDisplay != null) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          image: DecorationImage(
                            image: MemoryImage(imageBytesToDisplay),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      // Se não houver bytes de imagem (ou se a decodificação falhou), mostra o placeholder
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          color: Colors.blueGrey[700],
                        ),
                        child: Icon(
                          // Use Icons.image para placeholder geral, ou Icons.broken_image após um erro de decodificação
                          controller.foodBeingEdited.value?.image != null &&
                                  imageBytesToDisplay == null
                              ? Icons
                                    .broken_image // Se tentou carregar uma imagem existente e falhou
                              : Icons.image, // Placeholder padrão
                          size: 100,
                          color: Colors.white54,
                        ),
                      );
                    }
                  }),
                ),
                SizedBox(height: 25),
                botaoForm(
                  id != null && id != 0 ? 'Atualizar' : 'Cadastrar',
                  () async {
                    if (id != null && id != 0) {
                      if (controller.webImage.value != null) {
                        await controller.updateFoodWithImage(id!);
                      } else {
                        await controller.updateFood(id!);
                      }
                    } else {
                      if (controller.webImage.value != null) {
                        await controller.addFoodWithImage();
                      } else {
                        await controller.addFood();
                      }
                    }
                    controller.fetchFoods();
                    context.beamToNamed('/Interface');
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
          Obx(() {
            if (controller.mostrarEditor.value &&
                controller.webImage.value != null) {
              return Positioned.fill(
                child: Material(
                  color: Colors.black38,
                  child: Stack(
                    children: [
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
            return const SizedBox.shrink();
          }),
        ],
      );
    });
  }
}
