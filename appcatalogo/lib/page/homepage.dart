import 'package:appcatalogo/const/const.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart' hide ExpansionTileController;
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.largura, required this.paginas});

  final Map<String, Widget> paginas;
  final double largura;
  final ExpansionTileController _expansionController = Get.put(
    ExpansionTileController(),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 72, 91, 100),
        borderRadius: MediaQuery.of(context).size.width < 1200
            ? BorderRadius.horizontal(left: Radius.circular(0))
            : BorderRadius.horizontal(left: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            width: 280,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/aaaa.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Você pode colocar qualquer widget fixo aqui, por enquanto deixa vazio ou com texto
          const SizedBox(height: 20),

          // etc
          Obx(() {
            return ExpansionTile(
              collapsedTextColor: Colors.white,
              textColor: Colors.white,
              // iconColor: Colors.amber,
              iconColor: Color(0xFF4ACFD9),
              collapsedIconColor: Colors.white,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.assignment),
                    SizedBox(width: 7),
                    Text(
                      "Cadastro/Catalogo",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              initiallyExpanded: _expansionController.isExpanded.value,
              onExpansionChanged: (expanded) {
                _expansionController.setExpanded(
                  expanded,
                ); // Atualiza o estado de expansão
              },
              children: [
                botaointeracao('Catalogo', cadastroProdutoConst, () {
                  context.beamToNamed('/Interface');
                }, Icons.fastfood_rounded),
                botaointeracao('Cadastro de Produto', cadastroProdutoConst, () {
                  context.beamToNamed('/Interface/Cadastro');
                }, Icons.add),
                botaoIcons('Carrinho', cadastroProdutoConst, () {
                  context.beamToNamed('/Cart');
                }, Icons.shopping_cart),
              ],
            );
          }),
        ],
      ),
    );
  }
}
