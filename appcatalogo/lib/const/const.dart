import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

final TextStyle corDialog = TextStyle(color: Colors.white, fontSize: 20);
final TextStyle cadastroProdutoConst = TextStyle(
  color: Colors.white,
  fontSize: 20,
);
final TextStyle corPedido = TextStyle(color: Colors.white, fontSize: 25);

Widget tooltipForm(String nomeFuncao, Widget child) {
  return Tooltip(
    message: nomeFuncao,
    decoration: BoxDecoration(
      color: const Color.fromARGB(214, 0, 0, 0), // Fundo escuro
      borderRadius: BorderRadius.circular(8), // Cantos arredondados
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    waitDuration: const Duration(milliseconds: 300), // Tempo até aparecer
    showDuration: const Duration(seconds: 2), // Quanto tempo fica visível
    child: child,
  );
}

Widget botaoForm(
  String nomeBot,
  Function aoPressionar, {
  IconData? iconM,
  Color? iconMcor,
}) {
  return SizedBox(
    height: 45,
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        // Adicione um padding horizontal se quiser um espaçamento interno consistente
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      // Remova o SizedBox que definia a largura fixa
      child: Row(
        // O Row vai se ajustar ao tamanho do conteúdo (Ícone + Texto)
        mainAxisSize: MainAxisSize
            .min, // Faz o Row ocupar o mínimo de espaço horizontal necessário
        mainAxisAlignment: MainAxisAlignment
            .center, // Centraliza o conteúdo se houver espaço extra
        children: [
          if (iconM != null) ...[
            Icon(iconM, color: iconMcor),
            const SizedBox(width: 8),
          ],
          Text(nomeBot),
        ],
      ),
      onPressed: () => aoPressionar(),
    ),
  );
}

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

final cartController = Get.find<CartController>();
Widget botaoIcons(
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
      icon: Center(
        child: Badge.count(
          count: cartController.cartItemCount,
          child: Icon(nomeDoIcone, color: Colors.white, size: 25),
        ),
      ),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(tipoTexto, style: estiloText),
      ),
    ),
  );
}

MoneyMaskedTextController controlePrecoEstimado = MoneyMaskedTextController();
Widget textFormValueK(
  /////////////////   campo do valor
  double largura,
  String tipo,
  IconData icone,
  Color cordoicone, {
  double? tamanho,
  TextAlign? linha,
  TextInputType? valorNumero,
  bool apenasValor = false,
  TextEditingController? controller,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blueGrey[900],
      borderRadius: BorderRadius.circular(8),
    ),
    child: SizedBox(
      width: largura,
      child: TextField(
        cursorOpacityAnimates: true,
        cursorWidth: 2,
        cursorHeight: 18,
        controller: controller ?? (apenasValor ? controlePrecoEstimado : null),
        textAlign: linha ?? TextAlign.start,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),

          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icone, color: cordoicone, size: tamanho),
              SizedBox(width: 8), // Espaço entre o ícone e o texto
              Text(tipo),
            ],
          ),
          hintStyle: TextStyle(
            color: const Color.fromARGB(151, 255, 255, 255),
            fontSize: 10,
          ),
          labelStyle: TextStyle(color: Colors.white, fontSize: 17),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            /////////////  focada
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 120, 194, 255),
              width: 2.5,
            ),
          ),
        ),
        cursorColor: Colors.white,
        keyboardType: apenasValor ? TextInputType.number : valorNumero,
        inputFormatters: apenasValor
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ]
            : [],
      ),
    ),
  );
}

TextEditingController controleNumeracao = TextEditingController();
Widget textFormTypeK(
  double largura,
  String tipo,
  IconData icone,
  Color cordoicone, {
  double? tamanho,
  TextAlign? linha,
  TextInputType? numeros,
  String? info,
  bool apenasnumero = false,
  TextEditingController? controller,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blueGrey[900],
      borderRadius: BorderRadius.circular(8),
    ),
    child: SizedBox(
      width: largura,
      child: TextField(
        cursorOpacityAnimates: true,
        cursorWidth: 2,
        cursorHeight: 15,
        controller: controller ?? (apenasnumero ? controleNumeracao : null),
        textAlign: linha ?? TextAlign.start,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(icone, color: cordoicone, size: tamanho),
                SizedBox(width: 8), // Espaço entre o ícone e o texto
                Text(tipo),
              ],
            ),
          ),
          hintText: info,
          hintStyle: TextStyle(
            color: const Color.fromARGB(151, 255, 255, 255),
            fontSize: 10,
          ),
          labelStyle: TextStyle(color: Colors.white, fontSize: 17),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            /////////////  focada
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 120, 194, 255),
              width: 2.5,
            ),
          ),
        ),
        cursorColor: Colors.white,
        keyboardType: apenasnumero ? TextInputType.number : numeros,
        inputFormatters: apenasnumero
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ]
            : [],
      ),
    ),
  );
}

class ExpansionTileController extends GetxController {
  // A variável que guarda o estado de expansão do tile
  RxBool isExpanded = false.obs;

  // Método para atualizar o estado
  void setExpanded(bool expanded) {
    isExpanded.value = expanded;
  }
}
