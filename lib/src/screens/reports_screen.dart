import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports & Analytics"),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Info icon action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bar chart for task completion trends
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                            toY: 8,
                            color: Color(0xFF2196F3)), // Correct color usage
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xFF2196F3)), // Correct color usage
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                            toY: 5,
                            color: Color(0xFF2196F3)), // Correct color usage
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                            toY: 7,
                            color: Color(0xFF2196F3)), // Correct color usage
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            // Pie chart for task categories
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0, // No space between sections
                    centerSpaceRadius: 40, // Radius of the center space
                    sections: [
                      PieChartSectionData(
                        value: 50,
                        color: Color(0xFF4CAF50), // Correct color usage
                        title: 'Completed',
                        radius: 30,
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Color(0xFFF44336), // Correct color usage
                        title: 'Overdue',
                        radius: 30,
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Color(0xFFFFEB3B), // Correct color usage
                        title: 'Pending',
                        radius: 30,
                        showTitle: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Additional table or data section below the charts
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Task')),
                  DataColumn(label: Text('Completion Date')),
                  DataColumn(label: Text('Priority')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Task 1')),
                    DataCell(Text('2024-12-06')),
                    DataCell(Text('High')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Task 2')),
                    DataCell(Text('2024-12-05')),
                    DataCell(Text('Medium')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
