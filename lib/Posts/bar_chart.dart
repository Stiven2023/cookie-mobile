import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatelessWidget {
  final List<dynamic> data;

  BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red[300]!,
      Colors.green[200]!,
      Colors.blue[200]!,
      Colors.purple[200]!,
      Colors.yellow[200]!,
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ColumnSeries>[
        ColumnSeries<dynamic, String>(
          dataSource: data,
          xValueMapper: (dynamic post, _) => post['NickName'],
          yValueMapper: (dynamic post, _) => post['PostCount'],
          pointColorMapper: (dynamic post, int index) =>
              colors[index % colors.length],
        )
      ],
    );
  }
}
