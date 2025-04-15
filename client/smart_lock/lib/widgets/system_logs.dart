import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemLogs extends StatefulWidget {
  const SystemLogs({Key? key}) : super(key: key);

  @override
  State<SystemLogs> createState() => _SystemLogsState();
}

class _SystemLogsState extends State<SystemLogs> {
  String _selectedFilter = 'all';
  DateTimeRange? _dateRange;
  String _searchQuery = '';

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _logs = [
    {
      'id': '1',
      'type': 'access',
      'userName': 'John Doe',
      'action': 'Unlock Door',
      'location': 'Server Room',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'success',
      'details': 'Card scan successful',
    },
    {
      'id': '2',
      'type': 'security',
      'userName': 'System',
      'action': 'Failed Login Attempt',
      'location': 'Main Entrance',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'warning',
      'details': 'Invalid credentials',
    },
    {
      'id': '3',
      'type': 'system',
      'userName': 'System',
      'action': 'System Update',
      'location': 'All Locations',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'info',
      'details': 'Security patches applied',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search logs...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All Types'),
                        ),
                        DropdownMenuItem(
                          value: 'access',
                          child: Text('Access'),
                        ),
                        DropdownMenuItem(
                          value: 'security',
                          child: Text('Security'),
                        ),
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _dateRange == null
                              ? 'Select Date Range'
                              : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getLogTypeColor(log['type']),
                      child: Icon(
                        _getLogTypeIcon(log['type']),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(log['action']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${log['userName']} • ${log['location']}'),
                        Text(
                          DateFormat('MMM d, y HH:mm').format(log['timestamp']),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        log['status'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(log['status']),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Type', log['type']),
                            _buildDetailRow('Details', log['details']),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showLogDetails(log),
                                  icon: const Icon(Icons.info),
                                  label: const Text('View Details'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getLogTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'access':
        return Colors.blue;
      case 'security':
        return Colors.red;
      case 'system':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getLogTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'access':
        return Icons.lock_open;
      case 'security':
        return Icons.security;
      case 'system':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _showLogDetails(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Details - ${log['action']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('User', log['userName']),
            _buildDetailRow('Location', log['location']),
            _buildDetailRow(
                'Time', DateFormat('MMM d, y HH:mm').format(log['timestamp'])),
            _buildDetailRow('Type', log['type']),
            _buildDetailRow('Status', log['status']),
            _buildDetailRow('Details', log['details']),
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

  void _exportLogs() {
    // TODO: Implement log export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting logs...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
