import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:intl/intl.dart';

class DailyTrendLineChartScreen extends StatelessWidget {
  const DailyTrendLineChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Daily Trend",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DailyTrendChart(),
        ),
      ),
    );
  }
}

class DailyTrendChart extends StatefulWidget {
  const DailyTrendChart({super.key});

  @override
  State<DailyTrendChart> createState() => _DailyTrendChartState();
}

class _DailyTrendChartState extends State<DailyTrendChart> {
  final formatter = NumberFormat.decimalPattern();

  int get daysInMonth {
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }

  // Generate daily data for the current month
  List<double> get dailyPayments => List.generate(daysInMonth, (i) {
        return -Calculate.pDayIndex(i + 1); // negative for payments
      });

  List<double> get dailyReceipts => List.generate(daysInMonth, (i) {
        return Calculate.dDayIndex(i + 1);
      });

  List<double> get dailyProfitLoss => List.generate(daysInMonth, (i) {
        return Calculate.dDayIndex(i + 1) - Calculate.pDayIndex(i + 1);
      });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safePadding = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight;

    // ⭐ Responsive width & height
    final double chartWidth = screenWidth * 0.9; // force scroll
    final double chartHeight = (screenHeight - appBarHeight - safePadding) * 0.7;

    return Center(
      child: SizedBox(
        height: chartHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            child: LineChart(
              LineChartData(
                minY: _findMinY(),
                maxY: _findMaxY(),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        if (value < 1 || value > daysInMonth) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),

                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                lineBarsData: [
                  _buildLine(dailyPayments, Colors.red, "Payments"),
                  _buildLine(dailyReceipts, Colors.green, "Receipts"),
                  _buildLine(dailyProfitLoss, Colors.blue, "Profit/Loss"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLine(List<double> values, Color color, String label) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.15),
      ),
      spots: List.generate(
        values.length,
        (i) => FlSpot((i + 1).toDouble(), values[i]),
      ),
    );
  }

  double _findMinY() {
    final all = [...dailyPayments, ...dailyReceipts, ...dailyProfitLoss];
    return all.reduce((a, b) => a < b ? a : b) - 20;
  }

  double _findMaxY() {
    final all = [...dailyPayments, ...dailyReceipts, ...dailyProfitLoss];
    return all.reduce((a, b) => a > b ? a : b) + 20;
  }
}
