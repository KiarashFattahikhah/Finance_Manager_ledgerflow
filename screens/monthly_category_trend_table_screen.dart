import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/models/money.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MonthlyCategoryTrendTableScreen extends StatelessWidget {
  const MonthlyCategoryTrendTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Monthly Category Trend (Table)",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: MonthlyCategoryTrendTable(),
        ),
      ),
    );
  }
}

class MonthlyCategoryTrendTable extends StatefulWidget {
  const MonthlyCategoryTrendTable({super.key});

  @override
  State<MonthlyCategoryTrendTable> createState() =>
      _MonthlyCategoryTrendTableState();
}

class _MonthlyCategoryTrendTableState
    extends State<MonthlyCategoryTrendTable> {
  final moneyBox = Hive.box<Money>('moneyBox');
  final formatter = NumberFormat.decimalPattern();

  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = moneyBox.values.map((m) => m.category).toSet().toList();
  }

  double categoryMonthTotal(String category, int month) {
    double total = 0;

    for (var m in moneyBox.values) {
      String raw = m.date.replaceAll("/", "-");
      final date = DateTime.tryParse(raw);

      if (date != null &&
          date.month == month &&
          m.category == category) {
        total += double.tryParse(m.price.replaceAll(",", "")) ?? 0;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ⭐ Responsive table size
    final double tableWidth = screenWidth * 2.2;
    final double tableHeight = screenHeight * 1;

    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    return Center(
      child: SizedBox(
        height: tableHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(kPurpleColor),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              columns: [
                const DataColumn(label: Text("Category")),
                ...months.map((m) => DataColumn(label: Text(m))).toList(),
                const DataColumn(label: Text("Total")),
              ],

              rows: categories.map((category) {
                final monthlyValues = List.generate(12, (i) {
                  return categoryMonthTotal(category, i + 1);
                });

                final yearlyTotal = monthlyValues.fold(0.0, (a, b) => a + b);

                return DataRow(
                  cells: [
                    DataCell(Text(category)),

                    ...monthlyValues.map((value) {
                      return DataCell(
                        Text(
                          formatter.format(value),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),

                    DataCell(
                      Text(
                        formatter.format(yearlyTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
