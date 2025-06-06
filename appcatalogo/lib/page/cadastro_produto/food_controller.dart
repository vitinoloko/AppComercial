import 'dart:convert';
import 'package:appcatalogo/model/extendedimageeditor.dart';
import 'package:appcatalogo/model/food_model.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FoodController extends GetxController {
  var foodList = <Food>[].obs;
  var isLoading = false.obs;
  final RxBool mostrarEditor = false.obs;

  var webImage = Rx<Uint8List?>(null);
  var cellImage = Rx<String?>(null);

  final String baseUrl = 'http://localhost:3000/foods';

  @override
  void onInit() {
    fetchFoods();
    super.onInit();
  }

  Future<Uint8List?> pickAndEditImageComEditorCustom(
    BuildContext context,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return null;

    final originalBytes = await pickedFile.readAsBytes();

    // Abre a tela de edição personalizada
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
      return bytes; // <-- RETORNO AQUI
    }

    return null;
  }

  Future<void> fetchFoods() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        foodList.value = data.map((e) => Food.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFood(Food food) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );
      if (response.statusCode == 201) {
        final newFood = Food.fromJson(json.decode(response.body));
        foodList.add(newFood);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageAndAddFood({
    required String name,
    required String description,
    required double price,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        Get.snackbar('Aviso', 'Nenhuma imagem selecionada');
        return;
      }

      Uint8List imageBytes = await pickedFile.readAsBytes();

      Food food = Food(name: name, description: description, price: price);

      await addFoodWithImage(food, imageBytes);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao adicionar comida com imagem: $e');
    }
  }

  Future<void> addFoodWithImage(Food food, Uint8List imageBytes) async {
    try {
      isLoading.value = true;

      // Constrói o objeto Food com a imagem codificada em base64
      final foodWithImage = Food(
        name: food.name,
        description: food.description,
        price: food.price,
        image: base64Encode(imageBytes), // aqui é o segredo
      );

      // Envia o JSON do objeto Food já com imagem base64
      if (kDebugMode) {
        print('Base64 image length: ${foodWithImage.image?.length}');
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(foodWithImage.toJson()),
      );

      if (response.statusCode == 201) {
        final newFood = Food.fromJson(json.decode(response.body));
        foodList.add(newFood);
        Get.snackbar('Sucesso', 'Produto cadastrado com imagem!');
      } else {
        Get.snackbar('Erro', 'Falha ao cadastrar: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao cadastrar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFood(Food food) async {
    try {
      isLoading.value = true;
      final response = await http.patch(
        Uri.parse('$baseUrl/${food.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );
      if (response.statusCode == 200) {
        int index = foodList.indexWhere((e) => e.id == food.id);
        if (index != -1) {
          foodList[index] = food;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFoodWithImage(Food food, Uint8List imageBytes) async {
    try {
      isLoading.value = true;

      final updatedFood = Food(
        id: food.id,
        name: food.name,
        description: food.description,
        price: food.price,
        image: base64Encode(imageBytes),
      );

      final response = await http.patch(
        Uri.parse('$baseUrl/${food.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedFood.toJson()),
      );

      if (response.statusCode == 200) {
        int index = foodList.indexWhere((e) => e.id == food.id);
        if (index != -1) {
          foodList[index] = updatedFood;
          Get.snackbar('Sucesso', 'Comida atualizada com imagem');
        }
      } else {
        Get.snackbar('Erro', 'Erro ao atualizar imagem: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFood(int id) async {
    try {
      isLoading.value = true;
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        foodList.removeWhere((item) => item.id == id);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<Food?> getFoodById(int id) async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Food.fromJson(data);
      } else {
        Get.snackbar('Erro', 'Falha ao buscar comida com id $id');
        return null;
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao buscar comida: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
