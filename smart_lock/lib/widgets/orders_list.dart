import 'package:flutter/material.dart';

class AttendanceRecordsList extends StatelessWidget {
  const AttendanceRecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Records',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildRecordItem(
                  username: 'Frida Swift',
                  userId: 'ID: 1001',
                  checkInTime: '2024-03-21 09:00 AM',
                  checkOutTime: '2024-03-21 05:00 PM',
                  isPresent: true,
                ),
                _buildRecordItem(
                  username: 'Maria Sharapova',
                  userId: 'ID: 1002',
                  checkInTime: '2024-03-21 08:45 AM',
                  checkOutTime: '2024-03-21 04:30 PM',
                  isPresent: false,
                ),
                _buildRecordItem(
                  username: 'John Doe',
                  userId: 'ID: 1003',
                  checkInTime: '2024-03-21 09:15 AM',
                  isPresent: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem({
    required String username,
    required String userId,
    required String checkInTime,
    String? checkOutTime,
    required bool isPresent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    isPresent ? Colors.green[100] : Colors.grey[200],
                child: Text(
                  username[0],
                  style: TextStyle(
                    color: isPresent ? Colors.green[700] : Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userId,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPresent ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPresent ? 'Present' : 'Left',
                  style: TextStyle(
                    color: isPresent ? Colors.green[700] : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                    const SizedBox(height: 4),
                    Text(checkInTime, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              if (checkOutTime != null) ...[
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check Out',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(checkOutTime, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
