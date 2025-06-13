import 'package:appcatalogo/const/const.dart';
import 'package:appcatalogo/model/extendedimageeditor.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

// MUDANÇA: AGORA É UM STATELESSWIDGET
class CadastroFormpage extends StatelessWidget {
  final double largura;
  final int? id;

  const CadastroFormpage({super.key, required this.largura, this.id});

  @override
  Widget build(BuildContext context) {
    final FoodController controller = Get.find();

    // MUDANÇA: Chamamos loadFoodForEditing usando WidgetsBinding.instance.addPostFrameCallback
    // Isso evita chamar Rx.value = ... durante o ciclo de build direto.
    // O controller gerencia se deve ou não recarregar (ver loadFoodForEditing)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFoodForEditing(id);
    });

    // MUDANÇA: Criamos os TextEditingControllers localmente, mas eles escutam
    // as mudanças nas variáveis reativas do FoodController.
    // Importante: use Obx aqui para que os TextFields se reconstruam se os valores do controller mudarem.
    return Obx(() {
      // MUDANÇA: Gerenciamento de carregamento do formulário
      if (!controller.dadosCarregadosForm.value) {
        // Usa dadosCarregadosForm
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

      // Controllers de texto (agora são locais ao build, mas seus valores são observados)
      final nameTextController = TextEditingController(
        text: controller.foodName.value,
      );
      final descriptionTextController = TextEditingController(
        text: controller.foodDescription.value,
      );
      final priceMaskedController = MoneyMaskedTextController(
        initialValue: controller.foodPrice.value,
        leftSymbol: 'R\$ ',
        decimalSeparator: ',',
        thousandSeparator: '.',
      );

      // MUDANÇA: Listener para atualizar as variáveis reativas do controller
      // É crucial adicionar esses listeners APÓS o TextController ser criado e inicializado com o valor inicial
      // para evitar loops infinitos ou comportamento inesperado.
      // O `WidgetsBinding.instance.addPostFrameCallback` assegura que isso aconteça depois do build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Remove listeners antigos para evitar duplicação em reconstruções
        nameTextController.removeListener(
          () {},
        ); // Placeholder para remover todos
        descriptionTextController.removeListener(() {});
        priceMaskedController.removeListener(() {});

        // Adiciona novos listeners
        nameTextController.addListener(
          () => controller.foodName.value = nameTextController.text,
        );
        descriptionTextController.addListener(
          () =>
              controller.foodDescription.value = descriptionTextController.text,
        );
        priceMaskedController.addListener(
          () => controller.foodPrice.value = priceMaskedController.numberValue,
        );

        // Força a atualização do texto mascarado se o valor inicial for diferente
        if (priceMaskedController.numberValue != controller.foodPrice.value) {
          priceMaskedController.updateValue(controller.foodPrice.value);
        }
      });

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
                  controller: nameTextController, // Usa o controller local
                ),
                textFormTypeK(
                  largura,
                  'obs',
                  Icons.info_outline,
                  Colors.white,
                  controller:
                      descriptionTextController, // Usa o controller local
                ),
                textFormValueK(
                  largura,
                  'valor',
                  Icons.sell,
                  Colors.white,
                  apenasValor: true,
                  controller: priceMaskedController, // Usa o controller local
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
                    // MUDANÇA: Chamamos os métodos de salvar/atualizar sem passar 'Food'
                    // Os valores já estão nas variáveis reativas do controller
                    if (id != null && id != 0) {
                      if (controller.webImage.value != null) {
                        await controller.updateFoodWithImage(
                          id!,
                        ); // Passa apenas o ID
                      } else {
                        await controller.updateFood(id!); // Passa apenas o ID
                      }
                    } else {
                      if (controller.webImage.value != null) {
                        await controller.addFoodWithImage(); // Não passa nada
                      } else {
                        await controller.addFood(); // Não passa nada
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
