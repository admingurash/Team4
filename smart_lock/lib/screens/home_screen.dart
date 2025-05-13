import 'package:flutter/material.dart';
import '../widgets/lock_control.dart';
import '../widgets/feature_grid.dart';
import '../widgets/orders_list.dart';
import 'logs_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lock Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Notifications'),
                      content: const Text('No new notifications.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LogsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Lock Control Section
            Expanded(
              flex: 2,
              child: Container(
                color: Theme.of(context).primaryColor,
                child: const LockControl(),
              ),
            ),
            // Features and Records Section
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: const [
                    FeatureGrid(),
                    Expanded(child: AttendanceRecordsList()),
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
