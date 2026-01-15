import 'package:front_end_frotas/core/api_client.dart';
import 'package:front_end_frotas/core/token_storage.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:front_end_frotas/task/controllers/task_controller.dart';
import 'package:front_end_frotas/task/service/auth_service.dart';
import 'package:front_end_frotas/task/service/task_service.dart';
import 'package:front_end_frotas/widget/expansion_title.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskBindig extends Bindings {
  @override
  void dependencies() {
    final storage = TokenStorage();
    final client = http.Client();

    Get.lazyPut<TaskService>(() => TaskService(client, storage));
    Get.lazyPut<TaskController>(() => TaskController(Get.find<TaskService>()));
    Get.lazyPut<ExpansionTitleController>(
      () => ExpansionTitleController(),
      fenix: true,
    );
  }
}

class AuthBindig extends Bindings {
  @override
  void dependencies() {
    TaskBindig().dependencies();
    final storage = TokenStorage();
    final api = ApiClient(http.Client(), storage);
    Get.lazyPut<AuthService>(() => AuthService(api, storage));
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthService>()));
  }
}
