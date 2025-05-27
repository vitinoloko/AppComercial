import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nomeUser = TextEditingController();
    String senhaT = 'bds';
    String gmailT = 'bds';
    final TextEditingController controllerSenha = TextEditingController();
    final TextEditingController controllerGmail = TextEditingController();
    final RxString emailError = "".obs;
    final RxString senhaError = "".obs;
    RxBool olhos = true.obs;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/fundo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: TextField(
                    controller: nomeUser,
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
                        child: Text('Nome do Usuario'),
                      ),

                      hintStyle: TextStyle(
                        color: Color.fromARGB(151, 255, 255, 255),
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 17),
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

                SizedBox(height: 16),
                Obx(
                  () => Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 53, 53, 53),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TextField(
                      controller: controllerGmail,
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
                        errorText:
                            emailError.value == '' ? null : emailError.value,

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
                      color: const Color.fromARGB(255, 53, 53, 53),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TextField(
                      cursorErrorColor: Colors.red,
                      controller: controllerSenha,
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
                        errorText:
                            senhaError.value == '' ? null : emailError.value,
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
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                    ),
                    onPressed: () {
                      if (controllerGmail.text.trim().isEmpty) {
                        emailError.value = "Campo obrigatório";
                      } else {
                        emailError.value = "";
                      }

                      if (controllerSenha.text.trim().isEmpty) {
                        senhaError.value = "Campo obrigatório";
                      } else {
                        senhaError.value = "";
                      }

                      if (senhaT == controllerSenha.text &&
                          gmailT == controllerGmail.text) {
                        context.beamToNamed("/");
                      } else {
                        Get.snackbar(
                          'Opss',
                          '',
                          backgroundColor: const Color.fromARGB(
                            255,
                            37,
                            37,
                            37,
                          ),
                          borderColor: const Color.fromARGB(158, 244, 67, 54),
                          borderRadius: 15,
                          borderWidth: 3,
                          colorText: Colors.white,
                          margin: EdgeInsets.symmetric(
                            horizontal: Get.width > 600 ? Get.width * 0.3 : 16,
                          ),
                          maxWidth:
                              Get.width > 600 ? Get.width * 0.4 : Get.width * 5,
                          snackPosition: SnackPosition.TOP,
                          forwardAnimationCurve: Curves.fastOutSlowIn,
                          reverseAnimationCurve: Curves.easeInOut,
                          duration: Duration(seconds: 3),
                          messageText: Text(
                            'Ocorreu um erro inesperado, Verifique se a Senha ou Email estão corretos!!',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        );
                      }
                    },

                    child: const Text(
                      'login',
                      style: TextStyle(color: Colors.white),
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
