import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

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
                ? const BorderRadius.horizontal(right: Radius.circular(0))
                : const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // 🗺️ Mapa ocupando todo o espaço restante
          Expanded(
            child: FlutterMap(
              options: MapOptions(),

              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
