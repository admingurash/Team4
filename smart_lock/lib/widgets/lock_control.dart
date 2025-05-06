import 'package:flutter/material.dart';

class LockControl extends StatefulWidget {
  const LockControl({super.key});

  @override
  State<LockControl> createState() => _LockControlState();
}

class _LockControlState extends State<LockControl> {
  bool isLocked = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {},
              ),
              const Text(
                'NEW MODERN\nDT Santa Monica',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Lock Control
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLocked = !isLocked;
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isLocked ? Icons.lock_outline : Icons.lock_open,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Status Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusItem(Icons.wifi, 'Online'),
              _buildStatusItem(Icons.battery_charging_full, '51%'),
              _buildStatusItem(Icons.lock_outline, 'Closed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
