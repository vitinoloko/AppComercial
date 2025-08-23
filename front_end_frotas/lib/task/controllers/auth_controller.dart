import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final AuthService auth;

  AuthController(this.auth);

  var loading = false.obs;
  var error = RxnString();
  var user = Rxn<User>();

  Future<void> login(String username, String password) async {
    try {
      loading.value = true;
      error.value = null;

      final u = await auth.login(username: username, password: password);
      user.value = u; // guarda usuário logado
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> register(String username, String password) async {
    try {
      await auth.register(username: username, password: password, role: "user");
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> logout() async {
    await auth.logout();
    user.value = null;
  }
}
