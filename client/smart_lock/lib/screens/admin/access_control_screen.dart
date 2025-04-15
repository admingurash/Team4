import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({Key? key}) : super(key: key);

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  final List<Map<String, dynamic>> _roles = [
    {
      'name': 'Admin',
      'permissions': ['Full Access', 'User Management', 'System Settings'],
      'color': Colors.red,
    },
    {
      'name': 'Manager',
      'permissions': ['User Management', 'Reports', 'Analytics'],
      'color': Colors.orange,
    },
    {
      'name': 'Staff',
      'permissions': ['View Reports', 'Basic Access'],
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accessControl),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new role
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role Management',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _roles.map((role) {
                    return SizedBox(
                      width: constraints.maxWidth > 600
                          ? (constraints.maxWidth - 32) / 2
                          : constraints.maxWidth,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield,
                                        color: role['color'] as Color,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        role['name'] as String,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      // Handle role actions
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit Role'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete Role'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Permissions',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.textTheme.bodyLarge?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (role['permissions'] as List<String>)
                                    .map((permission) {
                                  return Chip(
                                    label: Text(
                                      permission,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    backgroundColor: role['color'] as Color,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add new role
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Role'),
      ),
    );
  }
}
