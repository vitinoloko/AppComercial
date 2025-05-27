import 'package:flutter/material.dart';

class Teste extends StatelessWidget {
  const Teste({super.key, required this.largura});
  final double largura;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius:
            MediaQuery.of(context).size.width < 1100
                ? BorderRadius.horizontal(right: Radius.circular(0))
                : BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(children: [
        
      ],),
    );
  }
}
