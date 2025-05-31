import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryData {
  final String category;
  final double value;

  const CategoryData(this.category, this.value);
}

/// Dados estáticos de exemplo
const List<CategoryData> chartData = [
  CategoryData('Eletrônicos', 35),
  CategoryData('Roupas', 28),
  CategoryData('Alimentos', 34),
  CategoryData('Outros', 20),
];

Widget meuGrafico() {
  return SizedBox(
    height: 150,
    child: SfCircularChart(
      legend: Legend(
        position: LegendPosition.left,
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      series: <CircularSeries>[
        DoughnutSeries<CategoryData, String>(
          radius: '100%',
          dataSource: chartData,
          xValueMapper: (CategoryData data, _) => data.category,
          yValueMapper: (CategoryData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    ),
  );
}
