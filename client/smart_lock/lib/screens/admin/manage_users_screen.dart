import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  // Sample user data
  List<Map<String, String>> users = List.generate(
      10,
      (i) => {
            'name': 'User ${i + 1}',
            'email': 'user${i + 1}@example.com',
            'role': i == 0 ? 'Admin' : 'User',
            'id': 'ID${(i + 1).toString().padLeft(3, '0')}',
          });

  void _addUser(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.createUser),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.userName),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.userEmail),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                users.add({
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': 'User',
                  'id': 'ID${(users.length + 1).toString().padLeft(3, '0')}',
                });
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _exportUsers(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Export CSV'),
            onTap: () {
              _exportCSV();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Export PDF'),
            onTap: () {
              _exportPDF();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_present),
            title: const Text('Export TXT'),
            onTap: () {
              _exportTXT();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _exportCSV() {
    final List<List<String>> rows = [
      ['Name', 'Email', 'Role', 'ID'],
      ...users.map((u) => [u['name']!, u['email']!, u['role']!, u['id']!]),
    ];
    String csvData = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'users.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV exported!')),
    );
  }

  void _exportPDF() async {
    final List<List<String>> rows = [
      ['Name', 'Email', 'Role', 'ID'],
      ...users.map((u) => [u['name']!, u['email']!, u['role']!, u['id']!]),
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
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'users.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF exported!')),
    );
  }

  void _exportTXT() {
    final String textData = [
      'Name, Email, Role, ID',
      ...users
          .map((u) => '${u['name']}, ${u['email']}, ${u['role']}, ${u['id']}'),
    ].join('\n');
    final bytes = utf8.encode(textData);
    final blob = html.Blob([bytes], 'text/plain');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'users.txt')
      ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TXT exported!')),
    );
  }

  void _editUser(BuildContext context, int index) {
    final user = users[index];
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.userName),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.userEmail),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                users[index] = {
                  ...user,
                  'name': nameController.text,
                  'email': emailController.text,
                };
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Role: ${user['role']}'),
            Text('ID: ${user['id']}'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageUsers),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addUser(context),
                  icon: const Icon(Icons.person_add),
                  label: Text(l10n.createUser),
                ),
                ElevatedButton.icon(
                  onPressed: () => _exportUsers(context),
                  icon: const Icon(Icons.download),
                  label: Text(l10n.exportData),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(user['name']!),
                      subtitle: Text(user['email']!),
                      onTap: () => _showUserProfile(context, user),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editUser(context, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteUser(index),
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
      ),
    );
  }
}
