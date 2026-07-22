import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class IncomeExpenseDonutChartScreen extends StatelessWidget {
  const IncomeExpenseDonutChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Income vs Expense",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: IncomeExpenseDonutChart(),
        ),
      ),
    );
  }
}

class IncomeExpenseDonutChart extends StatelessWidget {
  const IncomeExpenseDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();
    final currency = Hive.box('settingsBox').get('currency', defaultValue: 'Currency');

    // Your Calculate utils
    final double totalPayments = Calculate.pMonth();   // expenses
    final double totalReceipts = Calculate.dMonth();   // income

    final double total = totalPayments + totalReceipts;

    return Column(
      children: [
        const SizedBox(height: 20),

        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 70,
              sections: [
                PieChartSectionData(
                  color: Colors.red,
                  value: totalPayments,
                  title: "${((totalPayments / total) * 100).toStringAsFixed(1)}%",
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: totalReceipts,
                  title: "${((totalReceipts / total) * 100).toStringAsFixed(1)}%",
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        // LEGEND
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem("Expenses", Colors.red),
            const SizedBox(width: 20),
            _legendItem("Income", Colors.green),
          ],
        ),

        const SizedBox(height: 30),

        // VALUES
        Column(
          children: [
            Text(
              "Income: ${formatter.format(totalReceipts)} $currency",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              "Expenses: ${formatter.format(totalPayments)} $currency",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 8, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
