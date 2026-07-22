import 'package:flutter/material.dart';
import 'package:flutter_project/screens/daily_trend_line_chart_screen.dart';
import 'package:flutter_project/screens/income_expense_donut_chart_screen.dart';
import 'package:flutter_project/screens/monthly_category_trend_chart_screen.dart';
import 'package:flutter_project/screens/monthly_category_trend_table_screen.dart';
import 'package:flutter_project/screens/monthly_summary_table.dart';
import 'package:flutter_project/screens/monthly_trend_line_chart_screen.dart';
import 'package:flutter_project/screens/pie_chart_screen.dart';
import 'package:flutter_project/utils/extention.dart';
import 'package:flutter_project/widgets/chart_widget.dart';
import 'package:flutter_project/widgets/hover_icon_button.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 15.0, left: 15.0),
              child: Text('Transactions Management', style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 20 : screenSize(context).screenWidth*0.015),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 15.0, left: 15.0),
              child: Text('Tables', style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 15 : screenSize(context).screenWidth*0.013),),
            ),
            // MoneyInfpWidget(fistText: 'Today\'s receipts: ',fistPrice: Calculate.dToday().toString(),secondText: 'Today\'s payments: ',secondPrice: Calculate.pToday().toString()),
            // MoneyInfpWidget(fistText: 'This month\'s receipts: ',fistPrice: Calculate.dMonth().toString(),secondText: 'This month\'s payments: ',secondPrice: Calculate.pMonth().toString()),
            // MoneyInfpWidget(fistText: 'This year\'s receipts: ',fistPrice: Calculate.dYear().toString(),secondText: 'This year\'s payments: ',secondPrice: Calculate.pYear().toString()),
            // Expanded(child: DataTableTransaction(),),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    HoverIconButton(
                      icon: Icons.table_chart,
                      color: Colors.greenAccent,
                      label: "Monthly Trend",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MonthlySummaryTableScreen()),
                        );
                      },
                    ),
                    HoverIconButton(
                      icon: Icons.table_chart,
                      color: Colors.redAccent,
                      label: "Monthly Category",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MonthlyCategoryTrendTableScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 15.0, left: 15.0),
              child: Text('Charts', style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 15 : screenSize(context).screenWidth*0.013),),
            ),
            
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    HoverIconButton(
                      icon: Icons.bar_chart,
                      color: Colors.green,
                      label: "Bar Chart",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BarChartScreen()),
                        );
                      },
                    ),
                      
                    HoverIconButton(
                      icon: Icons.pie_chart,
                      color: Colors.blue,
                      label: "Pie Chart",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PieChartScreen()),
                        );
                      },
                    ),
                
                    HoverIconButton(
                      icon: Icons.donut_large,
                      color: Colors.purple,
                      label: "Income vs Expense",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const IncomeExpenseDonutChartScreen()),
                        );
                      },
                    ),
                
                    HoverIconButton(
                      icon: Icons.stacked_line_chart,
                      color: Colors.red,
                      label: "Daily Trend",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DailyTrendLineChartScreen()),
                        );
                      },
                    ),
                
                    HoverIconButton(
                      icon: Icons.multiline_chart,
                      color: Colors.yellow,
                      label: "Monthly Trend",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MonthlyTrendLineChartScreen()),
                        );
                      },
                    ),
                
                    HoverIconButton(
                      icon: Icons.line_axis_rounded,
                      color: Colors.black,
                      label: "Monthly Category",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MonthlyCategoryTrendChartScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MoneyInfpWidget extends StatelessWidget {
//   final String fistText;
//   final String secondText;
//   final String fistPrice;
//   final String secondPrice;
//   const MoneyInfpWidget({Key? key, required this.fistText, required this.secondText, required this.fistPrice, required this.secondPrice,}) :super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Expanded(child: Text(secondPrice,textAlign: TextAlign.right, style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.01),)),
//           Expanded(child: Text(secondText, textAlign: TextAlign.right, style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.01),)),
//           Expanded(child: Text(fistPrice, textAlign: TextAlign.right, style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.01),)),
//           Expanded(child: Text(fistText, style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.01),)),
//         ],
//       ),
//       );
//   }
// }