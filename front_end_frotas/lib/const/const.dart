import 'package:flutter/material.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';

const TextStyle kColorsTextCard = TextStyle(color: Colors.white);

Color getStatusColor(String? status) {
  return items[status ?? 'Pendente'] ?? Colors.red;
}

Text textForm(String algo) {
  return Text(
    algo,
    style: kColorsTextCard,
    overflow: TextOverflow.ellipsis, // corta com "..."
    maxLines: 1,
    softWrap: true,
  );
}

Icon iconsForm(IconData icon) {
  return Icon(icon, color: Colors.white);
}
