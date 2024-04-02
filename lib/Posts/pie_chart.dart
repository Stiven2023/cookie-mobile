import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomPieChart extends StatelessWidget {
  final List<PieChartData> data;

  CustomPieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Ajusta este valor para cambiar la altura del gráfico
      width: 130, // Ajusta este valor para cambiar el ancho del gráfico
      child: SfCircularChart(
        series: <CircularSeries>[
          PieSeries<PieChartData, String>(
            dataSource: data,
            xValueMapper: (PieChartData data, _) => data.category,
            yValueMapper: (PieChartData data, _) => data.value,
            pointColorMapper: (PieChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

class PieChartData {
  final String category;
  final int value;
  final Color color;

  PieChartData(this.category, this.value, this.color);
}
