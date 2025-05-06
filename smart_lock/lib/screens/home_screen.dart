import 'package:flutter/material.dart';
import '../widgets/lock_control.dart';
import '../widgets/feature_grid.dart';
import '../widgets/orders_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
