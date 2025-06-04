import 'dart:convert';
import 'package:appcatalogo/model/food_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FoodController extends GetxController {
  var foodList = <Food>[].obs;
  var isLoading = false.obs;

  // Troque 'localhost' pelo IP da sua máquina se for usar Flutter Web
  final String baseUrl = 'http://localhost:3000/foods';

  @override
  void onInit() {
    fetchFoods();
    super.onInit();
  }

  Future<void> fetchFoods() async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        foodList.value = data.map((e) => Food.fromJson(e)).toList();
      } else {
        Get.snackbar('Erro', 'Falha ao carregar comidas');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao buscar comidas: $e');
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        foodList.add(Food.fromJson(data));
        Get.snackbar('Sucesso', 'Comida adicionada');
      } else {
        Get.snackbar('Erro', 'Falha ao adicionar comida');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao adicionar comida: $e');
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

  Future<void> updateFood(Food food) async {
    try {
      isLoading.value = true;

      final response = await http.patch(
        Uri.parse('$baseUrl/${food.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );

      if (response.statusCode == 200) {
        int index = foodList.indexWhere((element) => element.id == food.id);
        if (index != -1) {
          foodList[index] = food;
        }
        Get.snackbar('Sucesso', 'Comida atualizada');
      } else {
        Get.snackbar('Erro', 'Falha ao atualizar comida');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar comida: $e');
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
        Get.snackbar('Sucesso', 'Item deletado');
      } else {
        Get.snackbar('Erro', 'Falha ao deletar o item');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao deletar o item: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
