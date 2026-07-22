import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class DataTableTransaction extends StatelessWidget {
  const DataTableTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();
    final currency = Hive.box('settingsBox').get('currency', defaultValue: 'Currency');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 400,
        columns: const [
          DataColumn2(label: Text('Period'), size: ColumnSize.L),
          DataColumn(label: Text('Payments')),
          DataColumn(label: Text('Receipts')),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text('Today')),
            DataCell(Text("${formatter.format(Calculate.pToday())} $currency")),
            DataCell(Text("${formatter.format(Calculate.dToday())} $currency")),
          ]),
          DataRow(cells: [
            const DataCell(Text('This Month')),
            DataCell(Text("${formatter.format(Calculate.pMonth())} $currency")),
            DataCell(Text("${formatter.format(Calculate.dMonth())} $currency")),
          ]),
          DataRow(cells: [
            const DataCell(Text('This Year')),
            DataCell(Text("${formatter.format(Calculate.pYear())} $currency")),
            DataCell(Text("${formatter.format(Calculate.dYear())} $currency")),
          ]),
        ],
      ),
    );
  }
}
