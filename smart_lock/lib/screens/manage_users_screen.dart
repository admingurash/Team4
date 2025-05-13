import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  // Example user data
  List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'id': 'ID001',
      'email': 'john@example.com',
      'role': 'Admin',
    },
    {
      'name': 'Jane Smith',
      'id': 'ID002',
      'email': 'jane@example.com',
      'role': 'User',
    },
    {
      'name': 'Bob Johnson',
      'id': 'ID003',
      'email': 'bob@example.com',
      'role': 'User',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'csv') _exportCSV();
              if (value == 'pdf') _exportPDF();
              if (value == 'txt') _exportTXT();
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'csv', child: Text('Export CSV')),
                  const PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
                  const PopupMenuItem(value: 'txt', child: Text('Export TXT')),
                ],
            icon: const Icon(Icons.download),
            tooltip: 'Export Users',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(child: Text(user['name']![0])),
            title: Text(user['name']!),
            subtitle: Text('${user['id']} • ${user['email']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.person),
                  tooltip: 'View Profile',
                  onPressed: () => _showUserProfile(user),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  onPressed: () => _editUser(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () => _deleteUser(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Export as CSV
  void _exportCSV() {
    final List<List<String>> rows = [
      ['Name', 'ID', 'Email', 'Role'],
      ...users.map((u) => [u['name']!, u['id']!, u['email']!, u['role']!]),
    ];
    String csvData = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute('download', 'users.csv')
          ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('CSV exported!')));
  }

  // Export as PDF
  void _exportPDF() async {
    final List<List<String>> rows = [
      ['Name', 'ID', 'Email', 'Role'],
      ...users.map((u) => [u['name']!, u['id']!, u['email']!, u['role']!]),
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
          ..setAttribute('download', 'users.pdf')
          ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('PDF exported!')));
  }

  // Export as TXT
  void _exportTXT() {
    final String textData = [
      'Name, ID, Email, Role',
      ...users.map(
        (u) => '${u['name']}, ${u['id']}, ${u['email']}, ${u['role']}',
      ),
    ].join('\n');
    final bytes = utf8.encode(textData);
    final blob = html.Blob([bytes], 'text/plain');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute('download', 'users.txt')
          ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('TXT exported!')));
  }

  void _showUserProfile(Map<String, String> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('User Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user['name']}'),
                Text('ID: ${user['id']}'),
                Text('Email: ${user['email']}'),
                Text('Role: ${user['role']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _editUser(int index) {
    final user = users[index];
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    final roleController = TextEditingController(text: user['role']);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    users[index] = {
                      'name': nameController.text,
                      'id': user['id']!,
                      'email': emailController.text,
                      'role': roleController.text,
                    };
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete User'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    users.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}
