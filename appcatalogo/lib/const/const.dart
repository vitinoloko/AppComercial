import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TextStyle cadastroProdutoConst = TextStyle(
  color: Colors.white,
  fontSize: 20,
);

Widget botaointeracao(
  final String tipoTexto,
  final TextStyle? estiloText,
  final Function aoPressionar,
  final IconData nomeDoIcone,
) {
  return SizedBox(
    height: 45,
    child: TextButton.icon(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.blueGrey[400],
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),

      onPressed: () => aoPressionar(),
      icon: Center(child: Icon(nomeDoIcone, color: Colors.white, size: 25)),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(tipoTexto, style: estiloText),
      ),
    ),
  );
}

Widget formTextField() {
  return TextField();
}

class ExpansionTileController extends GetxController {
  // A variável que guarda o estado de expansão do tile
  RxBool isExpanded = false.obs;

  // Método para atualizar o estado
  void setExpanded(bool expanded) {
    isExpanded.value = expanded;
  }
}
