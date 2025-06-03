import 'dart:convert';
import 'package:appcatalogo/model/food_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FoodController extends GetxController {
  var foodList = <Food>[].obs;

  final String baseUrl =
      'http://localhost:3000/foods'; // ⬅️ Coloque seu IP aqui

  @override
  void onInit() {
    fetchFoods();
    super.onInit();
  }

  /// 🔹 Listar comidas
  Future<void> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
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

  /// 🔸 Adicionar comida
  Future<void> addFood(Food food) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(food.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchFoods();
        Get.snackbar('Sucesso', 'Comida adicionada');
      } else {
        Get.snackbar('Erro', 'Falha ao adicionar comida');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }
}
