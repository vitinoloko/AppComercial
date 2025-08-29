import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/auth_service.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final AuthService auth;

  AuthController(this.auth);

  var loading = false.obs;
  var error = RxnString();
  var user = Rxn<User>();
  RxnString token = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadToken();
  }

  Future<void> login(String username, String password, {User? newUser}) async {
    try {
      loading.value = true;
      error.value = null;

      final u = await auth.login(username: username, password: password);
      user.value = u;
      token.value = await auth.storage.read(); // token já salvo pelo login

      // Salvar dados do usuário
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', u.id);
      await prefs.setString('username', u.username);
      await prefs.setString('role', u.role);
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
    user.value = null;
    token.value = null;
    await auth.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _loadUser() async {
    loading.value = true;
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('id');
    final username = prefs.getString('username');
    final role = prefs.getString('role');

    if (id != null && username != null && role != null) {
      user.value = User(id: id, username: username, role: role);
    }

    loading.value = false;
  }

  Future<void> _loadToken() async {
    final t = await auth.storage.read();
    if (t != null) token.value = t;
  }
}
