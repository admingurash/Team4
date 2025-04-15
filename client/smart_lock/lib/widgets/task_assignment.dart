import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskAssignment extends StatefulWidget {
  const TaskAssignment({Key? key}) : super(key: key);

  @override
  State<TaskAssignment> createState() => _TaskAssignmentState();
}

class _TaskAssignmentState extends State<TaskAssignment> {
  final _formKey = GlobalKey<FormState>();
  String _selectedWorker = '';
  String _selectedPriority = 'medium';
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _workers = [
    {
      'id': '1',
      'name': 'John Doe',
      'department': 'Security',
      'activeTasks': 2,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'department': 'Maintenance',
      'activeTasks': 1,
    },
    {
      'id': '3',
      'name': 'Bob Wilson',
      'department': 'IT',
      'activeTasks': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Assignment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assign New Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Worker',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedWorker.isEmpty ? null : _selectedWorker,
                        items: _workers.map<DropdownMenuItem<String>>((worker) {
                          return DropdownMenuItem<String>(
                            value: worker['id'],
                            child: Text(
                              '${worker['name']} (${worker['department']}) - ${worker['activeTasks']} active tasks',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWorker = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a worker';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Task Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Task Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedPriority,
                        items: const [
                          DropdownMenuItem(
                            value: 'low',
                            child: Text('Low'),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'high',
                            child: Text('High'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Due Date'),
                        subtitle: Text(
                          DateFormat('MMM d, y').format(_selectedDueDate),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDueDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDueDate = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitTask,
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Assign Task'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Active Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workers.length,
                itemBuilder: (context, index) {
                  final worker = _workers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _getPriorityColor(worker['activeTasks']),
                        child: Text(
                          worker['activeTasks'].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(worker['name']),
                      subtitle: Text(worker['department']),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _viewWorkerTasks(worker),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(int activeTasks) {
    if (activeTasks >= 3) {
      return Colors.red;
    } else if (activeTasks >= 1) {
      return Colors.orange;
    }
    return Colors.green;
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement task submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task assigned successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _viewWorkerTasks(Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${worker['name']}\'s Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Department: ${worker['department']}'),
            Text('Active Tasks: ${worker['activeTasks']}'),
            const SizedBox(height: 16),
            // TODO: Implement task list view
            const Text('Task list will be displayed here'),
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
