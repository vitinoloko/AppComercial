import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front_end_frotas/widget/expansion_title.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';
import 'package:get/get.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});
  final ExpansionTitleController _expansionTitleController = Get.put(
    ExpansionTitleController(),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 29, 35, 37),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: botaoForm('Home Page', () {
                  context.beamToNamed('/home');
                  print('indo para tela home..');
                }, iconM: Icons.home),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: botaoForm('Cada', () {
                  context.beamToNamed('/cadastro');
                  print('indo para tela cadastro..');
                }, iconM: Icons.candlestick_chart),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: botaoForm('aiaiaiai', () {
                  context.beamToNamed('/sla');
                }, iconM: Icons.verified_user_rounded),
              ),
            ],
          ),

          TextButton(
            onPressed: () {
              context.beamToNamed('/home');
              print('indo para tela home..');
            },
            child: Text(
              'Botao para voltar para home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.beamToNamed('/cadastro');
              print('indo para tela cadastro..');
            },
            child: Text(
              'Botao para voltar para cadastro',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
