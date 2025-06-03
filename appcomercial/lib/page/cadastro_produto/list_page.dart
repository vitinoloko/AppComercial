import 'package:flutter/material.dart';

class Interface extends StatelessWidget {
  const Interface({super.key, required this.largura});
  final double largura;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius:
            MediaQuery.of(context).size.width < 1100
                ? const BorderRadius.horizontal(right: Radius.circular(0))
                : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(children: []),
    );
  }
}
