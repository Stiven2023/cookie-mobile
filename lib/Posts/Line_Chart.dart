import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final List<Post> data;

  LineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <LineSeries<Post, DateTime>>[
        LineSeries<Post, DateTime>(
          dataSource: data,
          xValueMapper: (Post post, _) => post.date,
          yValueMapper: (Post post, _) => post.count,
        )
      ],
    );
  }
}

class Post {
  final DateTime date;
  final int count;

  Post({required this.date, required this.count});
}
