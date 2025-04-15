import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final userInfo = snapshot.data;
        if (userInfo == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please log in to continue'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Lock'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),
            ],
          ),
          drawer: NavigationService.buildRoleBasedDrawer(context, userInfo),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(context, userInfo),
                const SizedBox(height: 24),
                _buildQuickActions(context, userInfo),
                const SizedBox(height: 24),
                _buildRecentActivity(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(
      BuildContext context, Map<String, dynamic> userInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    userInfo['name'][0].toUpperCase(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${userInfo['name']}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        userInfo['email'],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, Map<String, dynamic> userInfo) {
    final permissions = Map<String, bool>.from(userInfo['permissions'] as Map);
    final actions = <Widget>[];

    if (permissions['view_tasks'] == true) {
      actions.add(
        _buildActionCard(
          context,
          icon: Icons.task_alt,
          title: 'View Tasks',
          onTap: () => Navigator.pushNamed(context, '/worker'),
        ),
      );
    }

    if (permissions['manage_attendance'] == true) {
      actions.add(
        _buildActionCard(
          context,
          icon: Icons.calendar_today,
          title: 'Attendance',
          onTap: () => Navigator.pushNamed(context, '/attendance'),
        ),
      );
    }

    if (permissions['view_reports'] == true) {
      actions.add(
        _buildActionCard(
          context,
          icon: Icons.assessment,
          title: 'Reports',
          onTap: () => Navigator.pushNamed(context, '/reports'),
        ),
      );
    }

    if (permissions['manage_users'] == true) {
      actions.add(
        _buildActionCard(
          context,
          icon: Icons.admin_panel_settings,
          title: 'Admin',
          onTap: () => Navigator.pushNamed(context, '/admin'),
        ),
      );
    }

    // Always add profile
    actions.add(
      _buildActionCard(
        context,
        icon: Icons.person,
        title: 'Profile',
        onTap: () => Navigator.pushNamed(context, '/profile'),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: actions,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: FirebaseService.getRecentActivities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final activities = snapshot.data ?? [];
            if (activities.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No recent activities'),
                ),
              );
            }

            return Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        _getActivityIcon(activity['type']),
                      ),
                    ),
                    title: Text(activity['description']),
                    subtitle: Text(
                      _formatTimestamp(activity['timestamp']),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Activity details coming soon'),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt;
      case 'attendance':
        return Icons.calendar_today;
      case 'user':
        return Icons.person;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';
    final DateTime dateTime = timestamp.toDate();
    return dateTime.toString().split('.')[0];
  }
}
