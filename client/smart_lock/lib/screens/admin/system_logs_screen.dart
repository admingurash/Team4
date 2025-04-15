import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({Key? key}) : super(key: key);

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  String _selectedLogType = 'all';
  String _selectedSeverity = 'all';

  final List<Map<String, dynamic>> _logs = List.generate(20, (index) {
    final severities = ['info', 'warning', 'error'];
    final types = ['system', 'access', 'user'];
    final severity = severities[index % 3];
    final type = types[index % 3];

    return {
      'timestamp': DateTime.now().subtract(Duration(minutes: index * 30)),
      'type': type,
      'severity': severity,
      'message': 'Sample log message for $type event with $severity severity',
    };
  });

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'system':
        return Icons.computer;
      case 'access':
        return Icons.lock;
      case 'user':
        return Icons.person;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // Export logs
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh logs
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedLogType,
                    decoration: const InputDecoration(
                      labelText: 'Log Type',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLogType = newValue;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Types'),
                      ),
                      DropdownMenuItem(
                        value: 'system',
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: 'access',
                        child: Text('Access'),
                      ),
                      DropdownMenuItem(
                        value: 'user',
                        child: Text('User'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSeverity,
                    decoration: const InputDecoration(
                      labelText: 'Severity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSeverity = newValue;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Severities'),
                      ),
                      DropdownMenuItem(
                        value: 'info',
                        child: Text('Info'),
                      ),
                      DropdownMenuItem(
                        value: 'warning',
                        child: Text('Warning'),
                      ),
                      DropdownMenuItem(
                        value: 'error',
                        child: Text('Error'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                final severity = log['severity'] as String;
                final type = log['type'] as String;
                final timestamp = log['timestamp'] as DateTime;
                final message = log['message'] as String;

                if ((_selectedLogType != 'all' && type != _selectedLogType) ||
                    (_selectedSeverity != 'all' &&
                        severity != _selectedSeverity)) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          _getSeverityColor(severity).withOpacity(0.1),
                      child: Icon(
                        _getTypeIcon(type),
                        color: _getSeverityColor(severity),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      message,
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '${timestamp.toString()} • ${type.toUpperCase()} • ${severity.toUpperCase()}',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // Show log details
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Clear logs
        },
        child: const Icon(Icons.delete_sweep),
      ),
    );
  }
}
