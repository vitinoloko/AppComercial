import 'dart:convert';
import 'package:appcatalogo/model/extendedimageeditor.dart';
import 'package:appcatalogo/model/food_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Importe para TextEditingController, MoneyMaskedTextController
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FoodController extends GetxController {
  var foodList = <Food>[].obs;
  var isLoading = false.obs; // Para a lista de comidas

  // --- NOVAS VARIÁVEIS REATIVAS PARA O FORMULÁRIO DE CADASTRO/EDIÇÃO ---
  var foodName = ''.obs;
  var foodDescription = ''.obs;
  var foodPrice = 0.0.obs;
  var currentEditingFoodId = Rx<int?>(
    null,
  ); // Armazena o ID do item que está sendo editado

  var webImage = Rx<Uint8List?>(null); // Imagem para cadastro/edição
  var cellImage = Rx<String?>(null); // Mantenha se ainda usa para mobile (path)
  var mostrarEditor = false.obs; // Para o editor de imagem

  // Usaremos 'dadosCarregadosForm' para o estado de carregamento do FORMULÁRIO
  // para não confundir com isLoading (da lista de comidas)
  var dadosCarregadosForm = false.obs;

  final String baseUrl = 'http://localhost:3000/foods';

  @override
  void onInit() {
    fetchFoods(); // Carrega a lista de comidas ao iniciar o app
    super.onInit();
  }

  // --- NOVO MÉTODO PARA CARREGAR DADOS DO FORMULÁRIO DE EDIÇÃO ---
  Future<void> loadFoodForEditing(int? id) async {
    // Se o ID for o mesmo e os dados já estiverem carregados, evita recarregar
    if (currentEditingFoodId.value == id && dadosCarregadosForm.isTrue) {
      print(
        'DEBUG: loadFoodForEditing - Dados já carregados para ID $id. Pulando recarga.',
      );
      return;
    }

    print('DEBUG: loadFoodForEditing - Iniciando carga para ID: $id');
    dadosCarregadosForm.value =
        false; // Começa o indicador de carregamento do formulário
    currentEditingFoodId.value = id; // Atualiza o ID do item sendo editado

    // Limpa os dados atuais nos observáveis do controller
    foodName.value = '';
    foodDescription.value = '';
    foodPrice.value = 0.0;
    webImage.value = null; // Limpa a imagem também

    if (id != null && id != 0) {
      final food = await getFoodById(
        id,
      ); // Usa o método existente para buscar a comida
      if (food != null) {
        print('DEBUG: Food ID $id encontrado: ${food.name}');
        foodName.value = food.name;
        foodDescription.value = food.description;
        foodPrice.value = food.price;
        if (food.image != null && food.image!.isNotEmpty) {
          try {
            webImage.value = base64Decode(food.image!);
            print(
              'DEBUG: Imagem Base64 decodificada para ID $id, tamanho: ${webImage.value?.length} bytes',
            );
          } catch (e) {
            print(
              'ERRO: Não foi possível decodificar a imagem Base64 para ID $id: $e',
            );
            webImage.value = null;
          }
        }
      } else {
        print('AVISO: Item com ID $id NÃO ENCONTRADO no backend para edição.');
      }
    } else {
      print(
        'DEBUG: Preparando para NOVO cadastro (ID é nulo/zero), limpando campos.',
      );
    }
    dadosCarregadosForm.value = true; // Finaliza o carregamento do formulário
    print('DEBUG: loadFoodForEditing - Carga finalizada para ID: $id');
  }

  // --- MÉTODOS EXISTENTES (AJUSTADOS PARA USAR AS NOVAS VARIÁVEIS REATIVAS) ---

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
      return bytes;
    }
    return null;
  }

  // Métodos de CRUD para a lista de comidas
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

  // AJUSTADO: Usa as variáveis reativas do controller
  Future<void> addFood() async {
    try {
      isLoading.value =
          true; // Pode usar outra variável de loading para o formulário se preferir
      final food = Food(
        name: foodName.value,
        description: foodDescription.value,
        price: foodPrice.value,
      );
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );
      if (response.statusCode == 201) {
        final newFood = Food.fromJson(json.decode(response.body));
        foodList.add(newFood);
        // Limpa os campos após adicionar (opcional, dependendo do UX)
        foodName.value = '';
        foodDescription.value = '';
        foodPrice.value = 0.0;
        webImage.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // AJUSTADO: Usa as variáveis reativas do controller
  Future<void> addFoodWithImage() async {
    try {
      isLoading.value = true; // Pode usar outra variável de loading
      final foodWithImage = Food(
        name: foodName.value,
        description: foodDescription.value,
        price: foodPrice.value,
        image: webImage.value != null ? base64Encode(webImage.value!) : null,
      );

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
        // Limpa os campos após adicionar (opcional)
        foodName.value = '';
        foodDescription.value = '';
        foodPrice.value = 0.0;
        webImage.value = null;
      }
    } catch (e) {
      if (kDebugMode) print('Error adding food with image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // AJUSTADO: Usa as variáveis reativas do controller
  Future<void> updateFood(int idToUpdate) async {
    try {
      isLoading.value = true;
      final updatedFood = Food(
        id: idToUpdate,
        name: foodName.value,
        description: foodDescription.value,
        price: foodPrice.value,
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
      }
    } finally {
      isLoading.value = false;
    }
  }

  // AJUSTADO: Usa as variáveis reativas do controller
  Future<void> updateFoodWithImage(int idToUpdate) async {
    try {
      isLoading.value = true;
      final updatedFood = Food(
        id: idToUpdate,
        name: foodName.value,
        description: foodDescription.value,
        price: foodPrice.value,
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
      }
    } catch (e) {
      if (kDebugMode) print('Error updating food with image: $e');
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

  // Este método já estava ok
  Future<Food?> getFoodById(int id) async {
    try {
      isLoading.value = true; // ou uma variável de loading mais específica
      print('DEBUG: Tentando buscar Food com ID: $id');
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      print('DEBUG: getFoodById - Status Code: ${response.statusCode}');
      print('DEBUG: getFoodById - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: getFoodById - Dados JSON decodificados: $data');
        return Food.fromJson(data);
      } else {
        print(
          'ERRO: getFoodById - Falha ao buscar item: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('ERRO CATCH: getFoodById - Exceção: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
