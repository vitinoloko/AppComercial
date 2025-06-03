import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'food_model.dart'; // <- seu model

class FoodController extends GetxController {
  var foodList = <Food>[].obs;
  final String baseUrl = 'http://seu_ip:porta'; // ex: http://192.168.0.100:3000

  @override
  void onInit() {
    fetchFoods();
    super.onInit();
  }

  // Buscar todas as comidas
  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/foods'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        foodList.value = data.map((e) => Food.fromJson(e)).toList();
      } else {
        Get.snackbar('Erro', 'Falha ao carregar comidas');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }

  // Adicionar comida
  Future<void> addFood(Food food) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );

      if (response.statusCode == 201) {
        fetchFoods();
      } else {
        Get.snackbar('Erro', 'Não foi possível adicionar comida');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }
}
