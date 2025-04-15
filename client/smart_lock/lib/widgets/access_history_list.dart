import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessHistoryList extends StatefulWidget {
  const AccessHistoryList({Key? key}) : super(key: key);

  @override
  State<AccessHistoryList> createState() => _AccessHistoryListState();
}

class _AccessHistoryListState extends State<AccessHistoryList> {
  String _selectedFilter = 'all';
  String _selectedSort = 'recent';

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _accessLogs = [
    {
      'location': 'Main Entrance',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'Approved',
      'method': 'Card Scan',
    },
    {
      'location': 'Server Room',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'Denied',
      'method': 'Face Recognition',
    },
    {
      'location': 'Office Area',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'Approved',
      'method': 'Card Scan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'approved',
                child: Text('Approved'),
              ),
              const PopupMenuItem(
                value: 'denied',
                child: Text('Denied'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Most Recent'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Oldest First'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _accessLogs.length,
        itemBuilder: (context, index) {
          final log = _accessLogs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    log['status'] == 'Approved' ? Colors.green : Colors.red,
                child: Icon(
                  log['status'] == 'Approved' ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
              title: Text(log['location']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, y HH:mm').format(log['timestamp']),
                  ),
                  Text(log['method']),
                ],
              ),
              trailing: Text(
                log['status'],
                style: TextStyle(
                  color:
                      log['status'] == 'Approved' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _showLogDetails(log),
            ),
          );
        },
      ),
    );
  }

  void _showLogDetails(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Access Details - ${log['location']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Time: ${DateFormat('MMM d, y HH:mm').format(log['timestamp'])}'),
            const SizedBox(height: 8),
            Text('Method: ${log['method']}'),
            const SizedBox(height: 8),
            Text(
              'Status: ${log['status']}',
              style: TextStyle(
                color: log['status'] == 'Approved' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
