import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:beamer/beamer.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final auth = Get.find<AuthController>(); // pega do binding

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 35, 37),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // Painel com dados do usuário
          Obx(() {
            if (auth.loading.value) {
              return Expanded(child: Center(child: CustomSpinner()));
            }

            final user = auth.user.value;
            if (user == null) {
              // mostra “Nenhum usuário logado” só depois do delay
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Nenhum usuário logado",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Usuário: ${user.username}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "Função: ${user.role}",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            );
          }),

          const Divider(color: Colors.white30),

          // Botões do menu
          Expanded(
            child: ListView(
              children: [
                botaoForm('Home Page', () {
                  context.beamToNamed('/home');
                }, iconM: Icons.home),
                botaoForm('Cadastro', () {
                  context.beamToNamed('/cadastro');
                }, iconM: Icons.candlestick_chart),
                botaoForm('Outra página', () {
                  context.beamToNamed('/sla');
                }, iconM: Icons.verified_user_rounded),

                const Divider(color: Colors.white30),

                // Botão de logout
                botaoForm('Logout', () async {
                  await auth.logout();
                  context.beamToNamed('/login');
                }, iconM: Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
