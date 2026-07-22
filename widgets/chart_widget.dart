import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/screens/new_transactions_screens.dart';
import 'package:flutter_project/utils/calculate.dart';
import 'package:flutter_project/utils/extention.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class BarChartScreen extends StatelessWidget {
  const BarChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Statistics",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPurpleColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: BarChartWidget(),
        ),
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

final settingsBox = Hive.box('settingsBox');
String get appCurrency =>
    settingsBox.get('currency', defaultValue: NewTransactionsScreens.currency);

class BarChartWidgetState extends State<BarChartWidget> {
  final settingsBox = Hive.box('settingsBox');
  String get appCurrency =>
      settingsBox.get('currency', defaultValue: 'Currency');

  int? touchedGroupIndex;

  final formatter = NumberFormat.decimalPattern();

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        handleBuiltInTouches: false,
        touchCallback: (event, response) {
          setState(() {
            final groupI = response?.spot?.touchedBarGroupIndex;
            if (event.isInterestedForInteractions && groupI != null) {
              touchedGroupIndex = groupI;
            } else {
              touchedGroupIndex = null;
            }
          });
        },
      );

  Widget getTitles(double value, TitleMeta meta) {
    final index2 = value.toInt();
    final isTouched2 = index2 == touchedGroupIndex;

    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: isTouched2
          ? (screenSize(context).screenWidth < 1004
              ? 10
              : screenSize(context).screenWidth * 0.008)
          : 0,
    );

    const labels = [
      "Daily Payments",
      "Daily Receipts",
      "Daily Profit/Loss",
      "Monthly Payments",
      "Monthly Receipts",
      "Monthly Profit/Loss",
      "Yearly Payments",
      "Yearly Receipts",
      "Yearly Profit/Loss",
    ];

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Transform.rotate(
          angle: 0,
          child: Text(labels[value.toInt()], style: style),
        ),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  Color barColor(double value) => value >= 0 ? kGreenColor : kRedColor;

  List<BarChartGroupData> get barGroups {
    final dailyP = -Calculate.pToday();
    final dailyR = Calculate.dToday();
    final dailyPL = dailyR + dailyP;

    final monthP = -Calculate.pMonth();
    final monthR = Calculate.dMonth();
    final monthPL = monthR + monthP;

    final yearP = -Calculate.pYear();
    final yearR = Calculate.dYear();
    final yearPL = yearR + yearP;

    final values = [
      dailyP,
      dailyR,
      dailyPL,
      monthP,
      monthR,
      monthPL,
      yearP,
      yearR,
      yearPL,
    ];

    return values.asMap().entries.map((entry) {
      int i = entry.key;
      double value = entry.value;

      final isTouched = i == touchedGroupIndex;

      String formatted = formatter.format(value.abs());

      if (value < 0) {
        formatted = "-$formatted $appCurrency";
      } else {
        formatted = "$formatted $appCurrency";
      }

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: value,
            color: barColor(value),
            width: screenSize(context).screenWidth < 1004
                ? 15
                : screenSize(context).screenWidth * 0.015,
            borderRadius: BorderRadius.circular(4),
            label: BarChartRodLabel(
              text: formatted,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isTouched
                    ? (screenSize(context).screenWidth < 1004
                        ? 15
                        : screenSize(context).screenWidth * 0.013)
                    : 0,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safePadding = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight;

    final double chartWidth = screenWidth * 0.9; 
    final double chartHeight =
        (screenHeight - appBarHeight - safePadding) * 0.7; 

    return Center(
      child: SizedBox(
        height: chartHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: const FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
