import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/models/money.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MonthlyCategoryTrendChartScreen extends StatelessWidget {
  const MonthlyCategoryTrendChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Monthly Category Trend",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: MonthlyCategoryTrendChart(),
        ),
      ),
    );
  }
}

class MonthlyCategoryTrendChart extends StatefulWidget {
  const MonthlyCategoryTrendChart({super.key});

  @override
  State<MonthlyCategoryTrendChart> createState() =>
      _MonthlyCategoryTrendChartState();
}

class _MonthlyCategoryTrendChartState
    extends State<MonthlyCategoryTrendChart> {
  final moneyBox = Hive.box<Money>('moneyBox');
  final formatter = NumberFormat.decimalPattern();

  late List<String> categories;
  late Map<String, bool> visible;

  @override
  void initState() {
    super.initState();

    categories = moneyBox.values.map((m) => m.category).toSet().toList();

    visible = {
      for (var c in categories) c: true,
    };
  }

  double categoryMonthTotal(String category, int month) {
    double total = 0;

    for (var m in moneyBox.values) {
      String raw = m.date.replaceAll("/", "-");
      final date = DateTime.tryParse(raw);

      if (date != null &&
          date.month == month &&
          m.category == category) {
        total += double.parse(m.price.replaceAll(",", ""));
      }
    }

    return total;
  }

  List<LineChartBarData> buildCategoryLines() {
    final List<Color> palette = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];

    List<LineChartBarData> lines = [];

    for (int c = 0; c < categories.length; c++) {
      final category = categories[c];

      if (!visible[category]!) continue;

      final color = palette[c % palette.length];

      final values = List.generate(12, (i) {
        return categoryMonthTotal(category, i + 1);
      });

      lines.add(
        LineChartBarData(
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: color.withOpacity(0.15),
          ),
          spots: List.generate(
            12,
            (i) => FlSpot((i + 1).toDouble(), values[i]),
          ),
        ),
      );
    }

    return lines;
  }

  double get minY {
    double minVal = 0;
    for (var cat in categories) {
      for (int m = 1; m <= 12; m++) {
        final v = categoryMonthTotal(cat, m);
        if (v < minVal) minVal = v;
      }
    }
    return minVal - 50;
  }

  double get maxY {
    double maxVal = 0;
    for (var cat in categories) {
      for (int m = 1; m <= 12; m++) {
        final v = categoryMonthTotal(cat, m);
        if (v > maxVal) maxVal = v;
      }
    }
    return maxVal + 50;
  }

  @override
  Widget build(BuildContext context) {
    final palette = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];

    final double chartWidth = MediaQuery.of(context).size.width * 0.92;

    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(categories.length, (i) {
            final category = categories[i];
            final color = palette[i % palette.length];

            return FilterChip(
              label: Text(category),
              selected: visible[category]!,
              selectedColor: color.withOpacity(0.25),
              checkmarkColor: Colors.white,
              backgroundColor: Colors.grey.shade200,
              onSelected: (val) {
                setState(() {
                  visible[category] = val;
                });
              },
            );
          }),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 350,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),

                  lineTouchData: const LineTouchData(enabled: false),

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                          ];

                          if (value < 1 || value > 12) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt() - 1],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,   // smaller font
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,   // smaller font
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),

                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),

                  lineBarsData: buildCategoryLines(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
