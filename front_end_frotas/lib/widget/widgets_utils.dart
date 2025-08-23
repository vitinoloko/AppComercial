import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textFieldPers({
  String hint = "Digite algo...",
  IconData? icon,
  TextEditingController? controller,
  String? erroText,
}) {
  return Theme(
    data: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        // ignore: deprecated_member_use
        selectionColor: Colors.blue.withOpacity(0.2),
        selectionHandleColor: Colors.blueAccent,
        cursorColor: Colors.white,
      ),
    ),

    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),

        cursorRadius: Radius.circular(50),
        cursorWidth: 3,
        cursorHeight: 20,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(icon, color: Colors.white),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(hint),
          ),
          errorText: erroText,

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
      ),
    ),
  );
}

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
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade900,
          foregroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // Adicione um padding horizontal se quiser um espaçamento interno consistente
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
    ),
  );
}

final List<String> items = ['Pendente', 'Em Andamento', 'Concluida'];
var selectedValue = ''.obs;
Widget dropFunc() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.blueGrey.shade800,
      borderRadius: BorderRadius.circular(6),
    ),

    child: DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        iconStyleData: IconStyleData(
          icon: Icon(Icons.expand_more, color: Colors.grey),
          openMenuIcon: Icon(
            Icons.expand_less_sharp,
            color: const Color.fromARGB(199, 120, 194, 255),
          ),
        ),
        isExpanded: true,
        hint: Text('Situação:', style: TextStyle(color: Colors.white)),
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        onChanged: (value) {
          selectedValue.value = value ?? ''; // Atualiza corretamente
        },
        items: items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[700],
          ),
        ),
      ),
    ),
  );
}

class AppStyles {
  static BorderRadius responseBordeRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 650) {
      return BorderRadius.zero;
    } else if (width < 960) {
      return BorderRadius.only(topRight: Radius.circular(16));
    } else {
      return const BorderRadius.horizontal(right: Radius.circular(0));
    }
  }
}
// Widget botaointeracao(
//   final String tipoTexto,
//   final TextStyle? estiloText,
//   final Function aoPressionar,
//   final IconData nomeDoIcone,
// ) {
//   return SizedBox(
//     height: 45,
//     child: TextButton.icon(
//       style: TextButton.styleFrom(
//         splashFactory: NoSplash.splashFactory,
//         overlayColor: Colors.blueGrey[400],
//         backgroundColor: Colors.blueGrey[800],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       ),

//       onPressed: () => aoPressionar(),
//       icon: Center(child: Icon(nomeDoIcone, color: Colors.white, size: 25)),
//       label: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(tipoTexto, style: estiloText),
//       ),
//     ),
//   );
// }
