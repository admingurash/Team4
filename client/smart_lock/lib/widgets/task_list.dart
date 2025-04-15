import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String _selectedFilter = 'all';
  String _selectedSort = 'priority';

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': 'Verify Server Room Access',
      'description': 'Review and approve access request for Server Room',
      'priority': 'high',
      'status': 'pending',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'location': 'Server Room',
    },
    {
      'id': '2',
      'title': 'Update Access Cards',
      'description': 'Update access card permissions for new employees',
      'priority': 'medium',
      'status': 'in_progress',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'location': 'Main Office',
    },
    {
      'id': '3',
      'title': 'Security System Check',
      'description': 'Perform routine security system maintenance',
      'priority': 'low',
      'status': 'completed',
      'dueDate': DateTime.now().add(const Duration(days: 3)),
      'location': 'All Floors',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.filter_list),
                      items: const [
                        DropdownMenuItem(
                            value: 'all', child: Text('All Tasks')),
                        DropdownMenuItem(
                            value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(
                            value: 'in_progress', child: Text('In Progress')),
                        DropdownMenuItem(
                            value: 'completed', child: Text('Completed')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      isExpanded: true,
                      icon: const Icon(Icons.sort),
                      items: const [
                        DropdownMenuItem(
                            value: 'priority', child: Text('By Priority')),
                        DropdownMenuItem(
                            value: 'due_date', child: Text('By Due Date')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(task['priority']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d').format(task['dueDate']),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(task['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(task['status']),
                          style: TextStyle(
                            color: _getStatusColor(task['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['description'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (task['status'] != 'completed') ...[
                                    OutlinedButton(
                                      onPressed: () => _updateTaskStatus(task),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      child: const Text('Update Status'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _completeTask(task),
                                      child: const Text('Mark as Complete'),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  void _updateTaskStatus(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current status: ${_getStatusText(task['status'])}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: task['status'],
              decoration: const InputDecoration(
                labelText: 'New Status',
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(
                    value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                setState(() {
                  task['status'] = value;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _completeTask(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Task'),
        content:
            const Text('Are you sure you want to mark this task as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                task['status'] = 'completed';
              });
              Navigator.pop(context);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
