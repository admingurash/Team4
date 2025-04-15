import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  void _addUser(BuildContext context) {
    // Implement add user functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.createUser),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.userName),
            ),
            TextField(
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
              // Add user logic
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _exportUsers() {
    // Implement export users functionality
  }

  void _editUser(BuildContext context, int index) {
    // Implement edit user functionality
  }

  void _deleteUser(int index) {
    // Implement delete user functionality
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
                  onPressed: _exportUsers,
                  icon: const Icon(Icons.download),
                  label: Text(l10n.exportData),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Sample count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('User ${index + 1}'),
                      subtitle: Text('user${index + 1}@example.com'),
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
