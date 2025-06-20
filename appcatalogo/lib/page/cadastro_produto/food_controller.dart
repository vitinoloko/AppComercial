import 'dart:convert';
import 'package:appcatalogo/const/extendedimageeditor.dart';
import 'package:appcatalogo/model/food/food_model.dart'; // Make sure this path is correct for your Food model
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class FoodController extends GetxController {
  var foodList = <Food>[].obs;
  var isLoading = false.obs;

  // --- CONTROLADORES DE TEXTO ---
  late TextEditingController nameTextController;
  late TextEditingController descriptionTextController;
  late MoneyMaskedTextController priceMaskedController;

  // --- Adicione esta linha para definir 'foodBeingEdited' ---
  final Rx<Food?> foodBeingEdited = Rx<Food?>(
    null,
  ); // Variável reativa para o Food sendo editado

  var foodName = ''.obs;
  var foodDescription = ''.obs;
  var foodPrice = 0.0.obs;
  var currentEditingFoodId = Rx<int?>(null);

  var webImage = Rx<Uint8List?>(null);
  var cellImage = Rx<String?>(null);
  var mostrarEditor = false.obs;

  var dadosCarregadosForm = false.obs;

  final String baseUrl = 'http://localhost:3000/foods';

  @override
  void onInit() {
    super.onInit();
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    priceMaskedController = MoneyMaskedTextController(
      initialValue: 0.0,
      leftSymbol: 'R\$ ',
      decimalSeparator: ',',
      thousandSeparator: '.',
    );

    nameTextController.addListener(
      () => foodName.value = nameTextController.text,
    );
    descriptionTextController.addListener(
      () => foodDescription.value = descriptionTextController.text,
    );
    priceMaskedController.addListener(
      () => foodPrice.value = priceMaskedController.numberValue,
    );

    fetchFoods();
  }

  @override
  void onClose() {
    nameTextController.dispose();
    descriptionTextController.dispose();
    priceMaskedController.dispose();
    super.onClose();
  }

  Future<void> loadFoodForEditing(int? id) async {
    if (currentEditingFoodId.value == id && dadosCarregadosForm.isTrue) {
      if (kDebugMode) {
        print(
          'DEBUG: loadFoodForEditing - Dados já carregados para ID $id. Pulando recarga.',
        );
      }
      return;
    }

    if (kDebugMode) {
      print('DEBUG: loadFoodForEditing - Iniciando carga para ID: $id');
    }
    dadosCarregadosForm.value = false;
    currentEditingFoodId.value = id;

    nameTextController.clear();
    descriptionTextController.clear();
    priceMaskedController.updateValue(0.0);
    webImage.value = null;
    foodBeingEdited.value =
        null; // Limpa o foodBeingEdited ao iniciar uma nova carga

    if (id != null && id != 0) {
      final food = await getFoodById(id);
      if (food != null) {
        if (kDebugMode) print('DEBUG: Food ID $id encontrado: ${food.name}');

        // --- Atribua o Food carregado à variável 'foodBeingEdited' ---
        foodBeingEdited.value = food;

        nameTextController.text = food.name;
        descriptionTextController.text = food.description;
        priceMaskedController.updateValue(food.price);

        if (food.image != null && food.image!.isNotEmpty) {
          try {
            webImage.value = base64Decode(food.image!);
          } catch (e) {
            if (kDebugMode) {
              print(
                'ERRO: loadFoodForEditing - Não foi possível decodificar imagem Base64 para ID $id: $e',
              );
            }
            webImage.value = null;
          }
        }
      } else {
        if (kDebugMode) {
          print(
            'AVISO: loadFoodForEditing - Item com ID $id NÃO ENCONTRADO no backend para edição.',
          );
        }
      }
    }
    dadosCarregadosForm.value = true;
  }

  // ... (restante do seu código: pickAndEditImageComEditorCustom, pickAndCropImage, pickImage, fetchFoods, addFood, addFoodWithImage, updateFood, updateFoodWithImage, deleteFood, getFoodById)
  // Certifique-se de que o restante do seu código está abaixo desta linha

  Future<Uint8List?> pickAndEditImageComEditorCustom(
    BuildContext context,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return null;
    final originalBytes = await pickedFile.readAsBytes();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageEditorWidget(imageBytes: originalBytes),
      ),
    );
    if (result is Uint8List) {
      return result;
    }
    return null;
  }

  Future<EditedImageResult?> pickAndCropImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    final result = await Navigator.push<EditedImageResult>(
      context,
      MaterialPageRoute(builder: (_) => ImageEditorWidget(imageBytes: bytes)),
    );
    return result;
  }

  Future<Uint8List?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      final bytes = result.files.single.bytes;
      webImage.value = bytes;
      cellImage.value = result.files.single.path;
      if (kDebugMode) {
        print(
          'DEBUG: pickImage - Tamanho da imagem selecionada (bytes): ${bytes!.length}',
        );
      }
      return bytes;
    }
    return null;
  }

  Future<void> fetchFoods() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(baseUrl));
      if (kDebugMode) {
        print('DEBUG: fetchFoods - Status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        foodList.value = data.map((e) => Food.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFood() async {
    if (kDebugMode) {
      print(
        'DEBUG: addFood - Adicionando nova comida: ${nameTextController.text}',
      );
    }
    try {
      isLoading.value = true;
      final food = Food(
        name: nameTextController.text,
        description: descriptionTextController.text,
        price: priceMaskedController.numberValue,
      );
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );
      if (response.statusCode == 201) {
        final newFood = Food.fromJson(json.decode(response.body));
        foodList.add(newFood);
        if (kDebugMode) {
          print(
            'DEBUG: addFood - Sucesso: Comida adicionada (ID: ${newFood.id})',
          );
        }
        nameTextController.clear();
        descriptionTextController.clear();
        priceMaskedController.updateValue(0.0);
        webImage.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFoodWithImage() async {
    if (kDebugMode) {
      print(
        'DEBUG: addFoodWithImage - Adicionando nova comida com imagem: ${nameTextController.text}',
      );
    }
    try {
      isLoading.value = true;
      final foodWithImage = Food(
        name: nameTextController.text,
        description: descriptionTextController.text,
        price: priceMaskedController.numberValue,
        image: webImage.value != null ? base64Encode(webImage.value!) : null,
      );

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(foodWithImage.toJson()),
      );

      if (response.statusCode == 201) {
        final newFood = Food.fromJson(json.decode(response.body));
        foodList.add(newFood);
        if (kDebugMode) {
          print(
            'DEBUG: addFoodWithImage - Sucesso: Comida com imagem adicionada (ID: ${newFood.id})',
          );
        }
        nameTextController.clear();
        descriptionTextController.clear();
        priceMaskedController.updateValue(0.0);
        webImage.value = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'ERRO: addFoodWithImage - Falha ao adicionar comida com imagem: $e',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFood(int idToUpdate) async {
    if (kDebugMode) {
      print('DEBUG: updateFood - Atualizando comida ID: $idToUpdate');
    }
    try {
      isLoading.value = true;
      final updatedFood = Food(
        id: idToUpdate,
        name: nameTextController.text,
        description: descriptionTextController.text,
        price: priceMaskedController.numberValue,
      );
      final response = await http.patch(
        Uri.parse('$baseUrl/$idToUpdate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedFood.toJson()),
      );
      if (response.statusCode == 200) {
        int index = foodList.indexWhere((e) => e.id == idToUpdate);
        if (index != -1) {
          foodList[index] = updatedFood;
        }
        if (kDebugMode) {
          print(
            'DEBUG: updateFood - Sucesso: Comida ID $idToUpdate atualizada.',
          );
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFoodWithImage(int idToUpdate) async {
    if (kDebugMode) {
      print(
        'DEBUG: updateFoodWithImage - Atualizando comida com imagem ID: $idToUpdate',
      );
    }
    try {
      isLoading.value = true;
      final updatedFood = Food(
        id: idToUpdate,
        name: nameTextController.text,
        description: descriptionTextController.text,
        price: priceMaskedController.numberValue,
        image: webImage.value != null ? base64Encode(webImage.value!) : null,
      );

      final response = await http.patch(
        Uri.parse('$baseUrl/$idToUpdate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedFood.toJson()),
      );

      if (response.statusCode == 200) {
        int index = foodList.indexWhere((e) => e.id == idToUpdate);
        if (index != -1) {
          foodList[index] = updatedFood;
        }
        if (kDebugMode) {
          print(
            'DEBUG: updateFoodWithImage - Sucesso: Comida com imagem ID $idToUpdate atualizada.',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'ERRO: updateFoodWithImage - Falha ao atualizar comida com imagem: $e',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFood(int id) async {
    if (kDebugMode) print('DEBUG: deleteFood - Excluindo comida ID: $id');
    try {
      isLoading.value = true;
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        foodList.removeWhere((item) => item.id == id);
        if (kDebugMode) {
          print('DEBUG: deleteFood - Sucesso: Comida ID $id deletada.');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<Food?> getFoodById(int id) async {
    if (kDebugMode) {
      print('DEBUG: getFoodById - Tentando buscar Food com ID: $id');
    }
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Food.fromJson(data);
      } else {
        if (kDebugMode) {
          print(
            'ERRO: getFoodById - Falha ao buscar item ID $id: ${response.statusCode}',
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('ERRO CATCH: getFoodById - Exceção: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
