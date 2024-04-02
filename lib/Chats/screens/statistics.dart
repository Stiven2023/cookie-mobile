import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

const String baseUrl = 'https://cokie-chat-api.onrender.com';

class ChatData {
  final String month;
  final int messageCount;

  ChatData(this.month, this.messageCount);
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int selectedYear = DateTime.now().year;
  List<ChatData> chartData = [];
  List<ChatData> hourlyChartData = [];
  int totalMessagesForSelectedYear = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndProcessChatData();
  }

  Future<void> _fetchAndProcessChatData() async {
    final chats = await getAllChats(context);
    final processedData = _getMessageCountByMonthAndYear(chats, selectedYear);
    final processedHourlyData = _getMessageCountByHour(chats);
    _filterAndShowMonths(processedData);
    _filterAndShowHourly(processedHourlyData);
  }

  void _filterAndShowMonths(List<ChatData> filteredChartData) {
    setState(() {
      chartData = filteredChartData;
      totalMessagesForSelectedYear =
          chartData.fold(0, (prev, element) => prev + element.messageCount);
    });
  }

  void _filterAndShowHourly(List<ChatData> filteredHourlyChartData) {
    setState(() {
      hourlyChartData = filteredHourlyChartData;
    });
  }

  Future<List<Map<String, dynamic>>> getAllChats(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/chats'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> chats = [];

        for (var item in data) {
          chats.add(item as Map<String, dynamic>);
        }

        return chats;
      } else {
        throw Exception('Error al obtener chats');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener chats: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<int>(
                value: selectedYear,
                items: <int>[2024, 2023].map<DropdownMenuItem<int>>(
                  (int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    _fetchAndProcessChatData();
                  });
                },
              ),
            ),
            SizedBox(
              height: 400,
              child: Card(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Mensajes por Mes',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <BarSeries<ChatData, String>>[
                            BarSeries<ChatData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChatData data, _) => data.month,
                              yValueMapper: (ChatData data, _) =>
                                  data.messageCount,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total de mensajes para el año $selectedYear: $totalMessagesForSelectedYear',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: chartData.map((data) {
                          return Text(
                            '${data.month}: ${data.messageCount} mensajes',
                            style: TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: Card(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Frecuencia Horaria de Mensajes',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SfSparkLineChart.custom(
                          dataCount: hourlyChartData.length,
                          xValueMapper: (index) => hourlyChartData[index].month,
                          yValueMapper: (index) =>
                              hourlyChartData[index].messageCount.toDouble(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: hourlyChartData.map((data) {
                          return Text(
                            '${data.month}: ${data.messageCount} mensajes',
                            style: TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChatData> _getMessageCountByMonthAndYear(
      List<Map<String, dynamic>> chats, int selectedYear) {
    final messageCounts = <String, int>{};
    for (var chat in chats) {
      final date = DateTime.parse(chat['createdAt']);
      if (date.year == selectedYear) {
        final month = date.month.toString();
        messageCounts[month] =
            messageCounts.containsKey(month) ? messageCounts[month]! + 1 : 1;
      }
    }

    final chartData = <ChatData>[];
    for (var month in messageCounts.keys) {
      chartData.add(ChatData(month, messageCounts[month]!));
    }

    return chartData;
  }

  List<ChatData> _getMessageCountByHour(List<Map<String, dynamic>> chats) {
    final messageCounts = <String, int>{};
    for (var chat in chats) {
      final date = DateTime.parse(chat['createdAt']);
      final hour = '${date.hour}';
      messageCounts[hour] =
          messageCounts.containsKey(hour) ? messageCounts[hour]! + 1 : 1;
    }

    final chartData = <ChatData>[];
    for (var hour in messageCounts.keys) {
      chartData.add(ChatData(hour, messageCounts[hour]!));
    }

    return chartData;
  }
}
