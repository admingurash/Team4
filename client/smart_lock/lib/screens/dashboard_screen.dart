import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data - in real app, this would come from your server
  final List<Map<String, dynamic>> _accessLogs = [
    {
      'userId': 'U12345',
      'userName': 'John Doe',
      'cardId': 'C789',
      'accessTime': DateTime.now().subtract(const Duration(minutes: 5)),
      'location': 'Main Entrance',
      'status': 'Granted',
    },
    {
      'userId': 'U12346',
      'userName': 'Jane Smith',
      'cardId': 'C790',
      'accessTime': DateTime.now().subtract(const Duration(minutes: 15)),
      'location': 'Server Room',
      'status': 'Denied',
    },
    {
      'userId': 'U12347',
      'userName': 'Bob Wilson',
      'cardId': 'C791',
      'accessTime': DateTime.now().subtract(const Duration(minutes: 30)),
      'location': 'Main Entrance',
      'status': 'Granted',
    },
  ];

  // Sample analytics data
  final Map<String, int> _locationStats = {
    'Main Entrance': 25,
    'Server Room': 10,
    'Office Area': 15,
    'Conference Room': 8,
    'Storage Room': 5,
  };

  final List<Map<String, dynamic>> _hourlyAccess = [
    {'hour': 9, 'count': 12},
    {'hour': 10, 'count': 18},
    {'hour': 11, 'count': 15},
    {'hour': 12, 'count': 10},
    {'hour': 13, 'count': 8},
    {'hour': 14, 'count': 20},
    {'hour': 15, 'count': 16},
  ];

  int _selectedTimeRange = 7; // days

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Smart Lock Dashboard',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment<int>(value: 7, label: Text('7D')),
              ButtonSegment<int>(value: 30, label: Text('30D')),
              ButtonSegment<int>(value: 90, label: Text('90D')),
            ],
            selected: {_selectedTimeRange},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedTimeRange = newSelection.first;
              });
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing data...')),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards in a responsive grid
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth > 900
                          ? (constraints.maxWidth - 32) / 3
                          : constraints.maxWidth > 600
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                      child: _buildStatCard(
                        context,
                        title: 'Total Access Today',
                        value: '45',
                        icon: Icons.door_front_door,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 900
                          ? (constraints.maxWidth - 32) / 3
                          : constraints.maxWidth > 600
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                      child: _buildStatCard(
                        context,
                        title: 'Access Denied',
                        value: '3',
                        icon: Icons.block,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 900
                          ? (constraints.maxWidth - 32) / 3
                          : constraints.maxWidth > 600
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                      child: _buildStatCard(
                        context,
                        title: 'Active Users',
                        value: '12',
                        icon: Icons.people,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Analytics Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Access by Location (Pie Chart)
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Access by Location',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: _locationStats.entries.map((entry) {
                                  final color = Colors.primaries[_locationStats
                                          .keys
                                          .toList()
                                          .indexOf(entry.key) %
                                      Colors.primaries.length];
                                  return PieChartSectionData(
                                    value: entry.value.toDouble(),
                                    title: '${entry.value}',
                                    radius: 80,
                                    color: color,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _locationStats.entries.map((entry) {
                              final color = Colors.primaries[_locationStats.keys
                                      .toList()
                                      .indexOf(entry.key) %
                                  Colors.primaries.length];
                              return Chip(
                                backgroundColor: color.withOpacity(0.1),
                                label: Text(
                                  '${entry.key}: ${entry.value}',
                                  style: TextStyle(color: color),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Hourly Access (Line Chart)
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hourly Access',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() <
                                                _hourlyAccess.length) {
                                          return Text(
                                            '${_hourlyAccess[value.toInt()]['hour']}:00',
                                          );
                                        }
                                        return const Text('');
                                      },
                                      reservedSize: 30,
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _hourlyAccess
                                        .asMap()
                                        .entries
                                        .map((entry) => FlSpot(
                                              entry.key.toDouble(),
                                              entry.value['count'].toDouble(),
                                            ))
                                        .toList(),
                                    isCurved: true,
                                    color: theme.colorScheme.primary,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ],
                                minY: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Access Logs
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Access Logs',
                          style: theme.textTheme.titleLarge,
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.history),
                          label: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: size.width > 1200 ? size.width - 64 : 1200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _accessLogs.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final log = _accessLogs[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                child: Text(
                                  log['userName'].toString()[0],
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              title: Text(log['userName'].toString()),
                              subtitle: Text(log['userId'].toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(log['location'].toString()),
                                      Text(
                                        _formatDateTime(
                                            log['accessTime'] as DateTime),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: log['status'] == 'Granted'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      log['status'].toString(),
                                      style: TextStyle(
                                        color: log['status'] == 'Granted'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
