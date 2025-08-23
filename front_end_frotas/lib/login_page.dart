import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final username = TextEditingController();
  final password = TextEditingController();
  final auth = Get.find<AuthController>();

  LoginPage({super.key});
  RxBool olhos = true.obs;
  final RxString emailError = "".obs;
  final RxString senhaError = "".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Center(
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color.fromARGB(122, 0, 0, 0),

              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 53, 53, 53),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TextField(
                      controller: username,
                      cursorOpacityAnimates: true,
                      cursorWidth: 2,
                      cursorHeight: 15,

                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Gmail'),
                        ),
                        errorText: emailError.value == ''
                            ? null
                            : emailError.value,

                        hintStyle: TextStyle(
                          color: Color.fromARGB(151, 255, 255, 255),
                          fontSize: 10,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          /////////////  focada
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 120, 194, 255),
                            width: 2.5,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 53, 53, 53),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TextField(
                      cursorErrorColor: Colors.red,
                      controller: password,
                      cursorOpacityAnimates: true,
                      cursorWidth: 2,
                      cursorHeight: 15,

                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('senha'),
                        ),
                        errorText: senhaError.value == ''
                            ? null
                            : emailError.value,
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            olhos.value = !olhos.value;
                          },
                          icon: Icon(
                            color: Colors.white,
                            olhos.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        hintStyle: TextStyle(
                          color: Color.fromARGB(151, 255, 255, 255),
                          fontSize: 10,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          /////////////  focada
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 120, 194, 255),
                            width: 2.5,
                          ),
                        ),
                      ),
                      cursorColor: Colors.white,
                      obscureText: olhos.value,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 53, 53, 53),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                      ),
                      onPressed: auth.loading.value
                          ? null
                          : () async {
                              await auth.login(username.text, password.text);
                              if (auth.user.value != null) {
                                context.beamToNamed('/home');
                              }
                            },

                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: username,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: password,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),

//             // erro
//             Obx(
//               () => auth.error.value != null
//                   ? Text(
//                       auth.error.value!,
//                       style: const TextStyle(color: Colors.red),
//                     )
//                   : const SizedBox.shrink(),
//             ),

//             // botão de login
            // Obx(
            //   () => FilledButton(
            //     onPressed: auth.loading.value
            //         ? null
            //         : () async {
            //             await auth.login(username.text, password.text);
            //             if (auth.user.value != null) {
            //               context.beamToNamed('/home');
            //             }
            //           },
            //     child: Text(auth.loading.value ? 'Entrando...' : 'Entrar'),
            //   ),
            // ),

//             const SizedBox(height: 8),

//             // botão de registro
//             TextButton(
//               onPressed: () async {
//                 await auth.register(username.text, password.text);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Registrado! Faça login.')),
//                 );
//               },
//               child: const Text('Registrar (rápido)'),
//             ),
//           ],
//         ),
//       ),
//     );
