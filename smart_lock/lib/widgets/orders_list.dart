import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
          const SizedBox(height: 8),
          // Export Buttons Row
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _exportCSV(context),
                icon: const Icon(Icons.table_chart),
                label: const Text('Export CSV'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _exportPDF(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export PDF'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _exportFile(context),
                icon: const Icon(Icons.file_present),
                label: const Text('Export File'),
              ),
            ],
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
    return GestureDetector(
      onTap: () {
        _showUserDetailsDialog(
          context: context,
          username: username,
          userId: userId,
          checkInTime: checkInTime,
          checkOutTime: checkOutTime,
          isPresent: isPresent,
        );
      },
      child: Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                        Text(
                          checkOutTime,
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

  // Show user details dialog
  void _showUserDetailsDialog({
    required BuildContext context,
    required String username,
    required String userId,
    required String checkInTime,
    String? checkOutTime,
    required bool isPresent,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $username'),
              Text('User ID: $userId'),
              Text('Check In: $checkInTime'),
              Text('Check Out: ${checkOutTime ?? "-"}'),
              Text('Status: ${isPresent ? "Present" : "Left"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// --- Export Logic Stubs ---
void _exportCSV(BuildContext context) {
  // Example attendance data
  final List<List<String>> rows = [
    ['Username', 'User ID', 'Check In', 'Check Out', 'Status'],
    [
      'Frida Swift',
      'ID: 1001',
      '2024-03-21 09:00 AM',
      '2024-03-21 05:00 PM',
      'Present',
    ],
    [
      'Maria Sharapova',
      'ID: 1002',
      '2024-03-21 08:45 AM',
      '2024-03-21 04:30 PM',
      'Left',
    ],
    ['John Doe', 'ID: 1003', '2024-03-21 09:15 AM', '', 'Present'],
  ];

  // Convert to CSV
  String csvData = const ListToCsvConverter().convert(rows);

  // Create a blob and trigger download
  final bytes = utf8.encode(csvData);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor =
      html.AnchorElement(href: url)
        ..setAttribute('download', 'attendance_records.csv')
        ..click();
  html.Url.revokeObjectUrl(url);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('CSV exported!')));
}

void _exportPDF(BuildContext context) async {
  // Example attendance data
  final List<List<String>> rows = [
    ['Username', 'User ID', 'Check In', 'Check Out', 'Status'],
    [
      'Frida Swift',
      'ID: 1001',
      '2024-03-21 09:00 AM',
      '2024-03-21 05:00 PM',
      'Present',
    ],
    [
      'Maria Sharapova',
      'ID: 1002',
      '2024-03-21 08:45 AM',
      '2024-03-21 04:30 PM',
      'Left',
    ],
    ['John Doe', 'ID: 1003', '2024-03-21 09:15 AM', '', 'Present'],
  ];

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table.fromTextArray(data: rows);
      },
    ),
  );

  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor =
      html.AnchorElement(href: url)
        ..setAttribute('download', 'attendance_records.pdf')
        ..click();
  html.Url.revokeObjectUrl(url);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('PDF exported!')));
}

void _exportFile(BuildContext context) {
  // Example attendance data as plain text
  final String textData = [
    'Username, User ID, Check In, Check Out, Status',
    'Frida Swift, ID: 1001, 2024-03-21 09:00 AM, 2024-03-21 05:00 PM, Present',
    'Maria Sharapova, ID: 1002, 2024-03-21 08:45 AM, 2024-03-21 04:30 PM, Left',
    'John Doe, ID: 1003, 2024-03-21 09:15 AM, , Present',
  ].join('\n');

  final bytes = utf8.encode(textData);
  final blob = html.Blob([bytes], 'text/plain');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor =
      html.AnchorElement(href: url)
        ..setAttribute('download', 'attendance_records.txt')
        ..click();
  html.Url.revokeObjectUrl(url);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('TXT exported!')));
}
