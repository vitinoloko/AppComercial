import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.largura, required this.paginas});

  final Map<String, Widget> paginas;
  final double largura;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 72, 91, 100),
        borderRadius: MediaQuery.of(context).size.width < 1100
            ? BorderRadius.horizontal(left: Radius.circular(0))
            : BorderRadius.horizontal(left: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // Você pode colocar qualquer widget fixo aqui, por enquanto deixa vazio ou com texto
          const SizedBox(height: 20),
          const Text('Menu lateral'),
          // etc
        ],
      ),
    );
  }
}
