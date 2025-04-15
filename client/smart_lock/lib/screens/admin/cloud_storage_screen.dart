import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CloudStorageScreen extends StatefulWidget {
  const CloudStorageScreen({Key? key}) : super(key: key);

  @override
  State<CloudStorageScreen> createState() => _CloudStorageScreenState();
}

class _CloudStorageScreenState extends State<CloudStorageScreen> {
  bool _autoBackup = true;
  String _selectedInterval = 'daily';
  bool _encryptBackups = true;
  final double _storageUsed = 75.0; // percentage

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cloudStorage),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh storage info
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage Overview',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator(
                                      value: _storageUsed / 100,
                                      backgroundColor: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      strokeWidth: 10,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${_storageUsed.toInt()}%',
                                        style: theme.textTheme.headlineSmall,
                                      ),
                                      Text(
                                        'Used',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '7.5 GB of 10 GB used',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _storageItem(
                                'Backups',
                                '4.2 GB',
                                Icons.backup,
                                Colors.blue,
                                theme,
                              ),
                              const SizedBox(height: 16),
                              _storageItem(
                                'Logs',
                                '2.1 GB',
                                Icons.description,
                                Colors.orange,
                                theme,
                              ),
                              const SizedBox(height: 16),
                              _storageItem(
                                'Other',
                                '1.2 GB',
                                Icons.folder,
                                Colors.green,
                                theme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Backup Settings',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Automatic Backup'),
                      subtitle: const Text('Automatically backup system data'),
                      value: _autoBackup,
                      onChanged: (value) {
                        setState(() {
                          _autoBackup = value;
                        });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Backup Interval'),
                      subtitle: DropdownButton<String>(
                        value: _selectedInterval,
                        isExpanded: true,
                        onChanged: _autoBackup
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedInterval = newValue;
                                  });
                                }
                              }
                            : null,
                        items: const [
                          DropdownMenuItem(
                            value: 'hourly',
                            child: Text('Every Hour'),
                          ),
                          DropdownMenuItem(
                            value: 'daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'weekly',
                            child: Text('Weekly'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Encrypt Backups'),
                      subtitle: const Text('Secure backups with encryption'),
                      value: _encryptBackups,
                      onChanged: (value) {
                        setState(() {
                          _encryptBackups = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Backups',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.backup),
                          ),
                          title: Text('Backup ${index + 1}'),
                          subtitle: Text(
                            'Created on ${DateTime.now().subtract(Duration(days: index)).toString()}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Show backup options
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Create manual backup
        },
        icon: const Icon(Icons.backup),
        label: const Text('Backup Now'),
      ),
    );
  }

  Widget _storageItem(
    String title,
    String size,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              Text(
                size,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
