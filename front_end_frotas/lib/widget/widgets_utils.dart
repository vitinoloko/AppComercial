import 'dart:math';

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

final Map<String, Color> items = {
  'Pendente': Colors.red,
  'Em Andamento': Colors.amber,
  'Concluida': Colors.green,
};
var selectedValue = ''.obs;
var filterValue = ''.obs;
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
        items: items.keys
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

Widget dropfiltersFunc() {
  return Obx(
    () => Container(
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
          value: filterValue.value.isEmpty ? null : filterValue.value,
          onChanged: (value) {
            filterValue.value = value ?? ''; // Atualiza corretamente
          },
          items: items.keys
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
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

class SpinKitRing extends StatefulWidget {
  const SpinKitRing({
    super.key,
    required this.color,
    this.lineWidth = 7.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  });

  final Color color;
  final double size;
  final double lineWidth;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitRing> createState() => _SpinKitRingState();
}

class _SpinKitRingState extends State<SpinKitRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          })
          ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    _animation2 = Tween(begin: -2 / 3, end: 1 / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
    _animation3 = Tween(begin: 0.25, end: 5 / 6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: SpinKitRingCurve()),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ((_animation1.value) * 5 * pi / 6),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: CustomPaint(
            foregroundPainter: RingPainter(
              paintWidth: widget.lineWidth,
              trackColor: widget.color,
              progressPercent: _animation3.value,
              startAngle: pi * _animation2.value,
            ),
          ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({
    required this.paintWidth,
    this.progressPercent,
    this.startAngle,
    required this.trackColor,
  }) : trackPaint = Paint()
         ..color = trackColor
         ..style = PaintingStyle.stroke
         ..strokeWidth = paintWidth
         ..strokeCap = StrokeCap.square;

  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double? progressPercent;
  final double? startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - paintWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle!,
      2 * pi * progressPercent!,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SpinKitRingCurve extends Curve {
  const SpinKitRingCurve();

  @override
  double transform(double t) => (t <= 0.5) ? 2 * t : 2 * (1 - t);
}

class CustomSpinner extends StatelessWidget {
  const CustomSpinner({super.key, this.size = 24, this.lineWidth = 3});
  final double size;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: SpinKitRing(lineWidth: lineWidth, color: Colors.cyan, size: size),
    );
  }
}
