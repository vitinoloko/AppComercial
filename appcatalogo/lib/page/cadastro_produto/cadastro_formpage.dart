import 'package:appcatalogo/const/const.dart';
import 'package:appcatalogo/model/extendedimageeditor.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// MUDANÇA: AGORA É UM STATELESSWIDGET NOVAMENTE!
class CadastroFormpage extends StatelessWidget {
  final double largura;
  final int? id;

  const CadastroFormpage({super.key, required this.largura, this.id});

  @override
  Widget build(BuildContext context) {
    final FoodController controller = Get.find();

    // Chamamos loadFoodForEditing uma vez no pós-frame callback
    // Isso evita chamar a função durante o ciclo de build direto e garante que
    // o controlador esteja pronto. O FoodController gerencia se a recarga é necessária.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFoodForEditing(id);
    });

    // O Obx aqui observa 'dadosCarregadosForm' e reconstrói se o estado de carregamento mudar.
    // Os TextFields agora usam os controladores que estão no FoodController,
    // que persistem e mantêm o estado de digitação.
    return Obx(() {
      if (!controller.dadosCarregadosForm.value) {
        return Container(
          width: largura,
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: MediaQuery.of(context).size.width < 1100
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
              borderRadius: MediaQuery.of(context).size.width < 1100
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
                  controller: controller
                      .nameTextController, // Usa o controller do FoodController
                ),
                textFormTypeK(
                  largura,
                  'obs',
                  Icons.info_outline,
                  Colors.white,
                  controller: controller
                      .descriptionTextController, // Usa o controller do FoodController
                ),
                textFormValueK(
                  largura,
                  'valor',
                  Icons.sell,
                  Colors.white,
                  apenasValor: true,
                  controller: controller
                      .priceMaskedController, // Usa o controller do FoodController
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await controller.pickImage();
                    if (picked != null) {
                      controller.webImage.value = picked;
                      controller.mostrarEditor.value = true;
                    }
                  },
                  child: const Text('Selecionar imagem'),
                ),
                const SizedBox(height: 12),
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
                ElevatedButton(
                  onPressed: () async {
                    // Os valores já estão nos controladores do FoodController
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
                    context.beamToNamed('/Interface');
                  },
                  child: Text(
                    id != null && id != 0 ? 'Atualizar' : 'Cadastrar',
                  ),
                ),
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
