import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import '../models/user.dart';
import '../models/system_metrics.dart';
import '../models/system_log.dart';
import '../models/backup_record.dart';
import '../models/api_key.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<Map<String, dynamic>?> _userInfoFuture;
  late Future<SystemMetrics> _metricsFuture;
  late Future<List<SystemLog>> _logsFuture;
  late Future<List<BackupRecord>> _backupsFuture;
  late Future<Map<String, ApiKey>> _apiKeysFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = AuthService.getUserInfo();
    _metricsFuture = AdminService.getSystemMetrics()
        .then((data) => SystemMetrics.fromJson(data));
    _logsFuture = AdminService.getSystemLogs()
        .then((data) => data.map((log) => SystemLog.fromJson(log)).toList());
    _backupsFuture = AdminService.getBackupHistory().then(
        (data) => data.map((backup) => BackupRecord.fromJson(backup)).toList());
    _apiKeysFuture = AdminService.getApiKeys().then((data) => {
          'production': ApiKey.fromJson(data['production']),
          'development': ApiKey.fromJson(data['development']),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show system notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('System notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final userInfo = snapshot.data;
          if (userInfo == null) {
            return const Center(child: Text('No user data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context, userInfo),
                const SizedBox(height: 24),
                _buildSystemOverviewSection(context),
                const SizedBox(height: 24),
                _buildUserManagementSection(context),
                const SizedBox(height: 24),
                _buildSecuritySection(context),
                const SizedBox(height: 24),
                _buildAnalyticsSection(context),
                const SizedBox(height: 24),
                _buildSystemSettingsSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(
      BuildContext context, Map<String, dynamic> userInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${userInfo['name']}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'System Administrator Dashboard',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<SystemMetrics>(
              future: _metricsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final metrics = snapshot.data;
                if (metrics == null) {
                  return const Text('No metrics available');
                }

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.people,
                        title: 'Total Users',
                        value: metrics.totalUsers.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.security,
                        title: 'Active Sessions',
                        value: metrics.activeUsers.toString(),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.warning,
                        title: 'Storage Used',
                        value: metrics.storageUsed,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemOverviewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        FutureBuilder<SystemMetrics>(
          future: _metricsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final metrics = snapshot.data;
            if (metrics == null) {
              return const Text('No metrics available');
            }

            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.memory),
                    title: const Text('System Status'),
                    subtitle: Text('Uptime: ${metrics.systemUptime}'),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                    onTap: () {
                      // TODO: Show detailed system status
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Storage Usage'),
                    subtitle: Text(
                        '${metrics.storageUsed} of ${metrics.totalStorage}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Show storage details
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('Last Backup'),
                    subtitle: Text(_formatDateTime(metrics.lastBackup)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Show backup details
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Management',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Create New User'),
                subtitle: const Text('Add a new user or worker'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to user creation
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Manage Users'),
                subtitle: const Text('View and edit user accounts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to user list
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Access Control'),
                subtitle: const Text('Manage roles and permissions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to access control
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        FutureBuilder<Map<String, ApiKey>>(
          future: _apiKeysFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final apiKeys = snapshot.data;
            if (apiKeys == null) {
              return const Text('No API keys available');
            }

            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.key),
                    title: const Text('API Keys'),
                    subtitle: Text(
                        'Last used: ${_formatDateTime(apiKeys['production']!.lastUsed)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to API keys management
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security Policies'),
                    subtitle: const Text('Configure security settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to security policies
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Account Recovery'),
                    subtitle: const Text('Manage account recovery options'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to account recovery
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics & Reports',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<SystemLog>>(
          future: _logsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final logs = snapshot.data;
            if (logs == null || logs.isEmpty) {
              return const Text('No logs available');
            }

            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Real-time Analytics'),
                    subtitle: Text('Latest log: ${logs.first.details}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to analytics dashboard
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.assessment),
                    title: const Text('Generate Reports'),
                    subtitle: const Text('Create and export reports'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to report generation
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('System Logs'),
                    subtitle: Text('${logs.length} recent entries'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to system logs
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSystemSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<BackupRecord>>(
          future: _backupsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final backups = snapshot.data;
            if (backups == null || backups.isEmpty) {
              return const Text('No backups available');
            }

            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud),
                    title: const Text('Cloud Storage'),
                    subtitle: Text(
                        'Latest backup: ${_formatDateTime(backups.first.timestamp)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to cloud storage settings
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification Settings'),
                    subtitle: const Text('Configure system notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to notification settings
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('General Settings'),
                    subtitle: const Text('Configure system preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to general settings
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
