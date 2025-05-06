import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Attendance System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Attendance System'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Records List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAttendanceRecord(
                  'John Doe',
                  'ID001',
                  DateTime.now().subtract(const Duration(hours: 2)),
                  null,
                ),
                _buildAttendanceRecord(
                  'Jane Smith',
                  'ID002',
                  DateTime.now().subtract(const Duration(hours: 4)),
                  DateTime.now().subtract(const Duration(hours: 1)),
                ),
                _buildAttendanceRecord(
                  'Bob Johnson',
                  'ID003',
                  DateTime.now().subtract(const Duration(hours: 3)),
                  null,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new attendance record
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAttendanceRecord(
    String name,
    String id,
    DateTime checkIn,
    DateTime? checkOut,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(name[0])),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: $id',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        checkOut == null ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    checkOut == null ? 'Present' : 'Left',
                    style: TextStyle(
                      color:
                          checkOut == null
                              ? Colors.green[700]
                              : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check In',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        _formatDateTime(checkIn),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                if (checkOut != null) ...[
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check Out',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          _formatDateTime(checkOut),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
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
