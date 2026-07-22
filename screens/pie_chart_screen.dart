import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/data/category_colors.dart';
import 'package:flutter_project/models/money.dart';
import 'package:hive/hive.dart';

class PieChartScreen extends StatelessWidget {
  const PieChartScreen({super.key});

  Map<String, double> calculateCategoryTotals(List<Money> items) {
    final Map<String, double> totals = {};

    for (var item in items) {
      double price = double.tryParse(item.price.replaceAll(",", "")) ?? 0;

      if (totals.containsKey(item.category)) {
        totals[item.category] = totals[item.category]! + price;
      } else {
        totals[item.category] = price;
      }
    }

    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Money>('moneyBox');
    final List<Money> items = box.values.toList();

    final totals = calculateCategoryTotals(items);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Category Pie Chart", style: TextStyle(color: Colors.white),),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: totals.isEmpty
              ? const Center(child: Text("No data available"))
              : Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: totals.entries.map((entry) {
                            final category = entry.key;
                            final value = entry.value;
      
                            return PieChartSectionData(
                              color: categoryColors[category] ?? Colors.grey,
                              value: value,
                              title: "",
                              radius: 60,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
      
                    const SizedBox(height: 20),
      
                    // LEGEND
                    Expanded(
                      child: ListView(
                        children: totals.entries.map((entry) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  categoryColors[entry.key] ?? Colors.grey,
                            ),
                            title: Text(entry.key),
                            trailing: Text(
                              entry.value.toStringAsFixed(2),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
