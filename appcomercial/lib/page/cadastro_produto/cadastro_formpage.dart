import 'package:flutter/material.dart';

class Cadastroformpage extends StatelessWidget {
  final double largura;
  final String? foodId;
  const Cadastroformpage({super.key, required this.largura, this.foodId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      decoration: const BoxDecoration(color: Colors.blue),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
           
          ],
        ),
      ),
    );
  }
}
