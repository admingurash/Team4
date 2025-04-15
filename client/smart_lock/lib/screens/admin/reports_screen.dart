import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedTimeRange = '7days';
  String _selectedReport = 'access';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // Export report
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: _selectedTimeRange,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedTimeRange = newValue;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: '7days',
                              child: Text('Last 7 Days'),
                            ),
                            DropdownMenuItem(
                              value: '30days',
                              child: Text('Last 30 Days'),
                            ),
                            DropdownMenuItem(
                              value: '90days',
                              child: Text('Last 90 Days'),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: _selectedReport,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedReport = newValue;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'access',
                              child: Text('Access Report'),
                            ),
                            DropdownMenuItem(
                              value: 'users',
                              child: Text('User Activity'),
                            ),
                            DropdownMenuItem(
                              value: 'system',
                              child: Text('System Health'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Access Trends',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                          ),
                          titlesData: const FlTitlesData(show: true),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                const FlSpot(0, 3),
                                const FlSpot(2.6, 2),
                                const FlSpot(4.9, 5),
                                const FlSpot(6.8, 3.1),
                                const FlSpot(8, 4),
                                const FlSpot(9.5, 3),
                                const FlSpot(11, 4),
                              ],
                              isCurved: true,
                              color: theme.colorScheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Report',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('User')),
                          DataColumn(label: Text('Action')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Location')),
                        ],
                        rows: List.generate(10, (index) {
                          return DataRow(
                            cells: [
                              DataCell(Text('2024-03-${index + 1}')),
                              DataCell(Text('User ${index + 1}')),
                              const DataCell(Text('Card Scan')),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    index % 2 == 0 ? 'Success' : 'Pending',
                                    style: TextStyle(
                                      color: index % 2 == 0
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text('Location ${index + 1}')),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Generate new report
        },
        icon: const Icon(Icons.add),
        label: const Text('Generate Report'),
      ),
    );
  }
}
