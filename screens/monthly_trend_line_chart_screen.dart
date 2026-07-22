import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:intl/intl.dart';

class MonthlyTrendLineChartScreen extends StatelessWidget {
  const MonthlyTrendLineChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Monthly Trend",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: MonthlyTrendChart(),
        ),
      ),
    );
  }
}

class MonthlyTrendChart extends StatefulWidget {
  const MonthlyTrendChart({super.key});

  @override
  State<MonthlyTrendChart> createState() => _MonthlyTrendChartState();
}

class _MonthlyTrendChartState extends State<MonthlyTrendChart> {
  final formatter = NumberFormat.decimalPattern();

  // Generate 12 months of data using your Calculate utils
  List<double> get monthlyPayments => List.generate(12, (i) {
        return -Calculate.pMonthIndex(i + 1); // negative for payments
      });

  List<double> get monthlyReceipts => List.generate(12, (i) {
        return Calculate.dMonthIndex(i + 1);
      });

  List<double> get monthlyProfitLoss => List.generate(12, (i) {
        return Calculate.dMonthIndex(i + 1) - Calculate.pMonthIndex(i + 1);
      });

  @override
  Widget build(BuildContext context) {
    // ⭐ Responsive width using MediaQuery
    final double chartWidth = MediaQuery.of(context).size.width * 0.9;
    final double chartHeight = MediaQuery.of(context).size.height * 0.6;

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
                              fontSize: 10, // smaller font
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
                            fontSize: 10, // smaller font
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
                  _buildLine(monthlyPayments, Colors.red, "Payments"),
                  _buildLine(monthlyReceipts, Colors.green, "Receipts"),
                  _buildLine(monthlyProfitLoss, Colors.blue, "Profit/Loss"),
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
        12,
        (i) => FlSpot((i + 1).toDouble(), values[i]),
      ),
    );
  }

  double _findMinY() {
    final all = [...monthlyPayments, ...monthlyReceipts, ...monthlyProfitLoss];
    return all.reduce((a, b) => a < b ? a : b) - 50;
  }

  double _findMaxY() {
    final all = [...monthlyPayments, ...monthlyReceipts, ...monthlyProfitLoss];
    return all.reduce((a, b) => a > b ? a : b) + 50;
  }
}
