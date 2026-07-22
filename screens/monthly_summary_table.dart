import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/models/money.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MonthlySummaryTableScreen extends StatelessWidget {
  const MonthlySummaryTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Monthly Summary",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: MonthlySummaryTable(),
        ),
      ),
    );
  }
}

class MonthlySummaryTable extends StatefulWidget {
  const MonthlySummaryTable({super.key});

  @override
  State<MonthlySummaryTable> createState() => _MonthlySummaryTableState();
}

class _MonthlySummaryTableState extends State<MonthlySummaryTable> {
  final moneyBox = Hive.box<Money>('moneyBox');
  final formatter = NumberFormat.decimalPattern();

  int countTransactions(int month) {
    int count = 0;

    for (var m in moneyBox.values) {
      String raw = m.date.replaceAll("/", "-");
      final date = DateTime.tryParse(raw);

      if (date != null && date.month == month) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ⭐ Responsive table width & height
    final double tableWidth = screenWidth * 2.2;   
    final double tableHeight = screenHeight * 1;

    final months = const [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
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
      
              columns: const [
                DataColumn(label: Text("Month")),
                DataColumn(label: Text("Payments")),
                DataColumn(label: Text("Receipts")),
                DataColumn(label: Text("Profit/Loss")),
                DataColumn(label: Text("Transactions")),
              ],
      
              rows: List.generate(12, (i) {
                final monthIndex = i + 1;
      
                final payments = -Calculate.pMonthIndex(monthIndex);
                final receipts = Calculate.dMonthIndex(monthIndex);
                final profit = receipts + payments;
                final count = countTransactions(monthIndex);
      
                return DataRow(
                  cells: [
                    DataCell(Text(months[i])),
      
                    DataCell(Text(
                      formatter.format(payments),
                      style: const TextStyle(color: kRedColor),
                    )),
      
                    DataCell(Text(
                      formatter.format(receipts),
                      style: const TextStyle(color: kGreenColor),
                    )),
      
                    DataCell(Text(
                      formatter.format(profit),
                      style: TextStyle(
                        color: profit >= 0 ? kGreenColor : kRedColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
      
                    DataCell(Text(count.toString())),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
