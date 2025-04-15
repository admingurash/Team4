import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class WorkerDashboardScreen extends StatelessWidget {
  const WorkerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: AuthService.getUserInfo(),
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
                _buildTaskSection(context),
                const SizedBox(height: 24),
                _buildUserOperationsSection(context),
                const SizedBox(height: 24),
                _buildReportsSection(context),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new task
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add task coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
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
              'Here\'s your work overview for today',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.task_alt,
                    title: 'Tasks',
                    value: '5',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.pending_actions,
                    title: 'Pending',
                    value: '3',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.check_circle,
                    title: 'Completed',
                    value: '2',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Assigned Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: View all tasks
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View all tasks coming soon')),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // TODO: Replace with actual task count
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.task),
                ),
                title: Text('Task ${index + 1}'),
                subtitle: Text(
                    'Due: ${DateTime.now().add(Duration(days: index + 1)).toString().split(' ')[0]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Edit task
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Edit task coming soon')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        // TODO: Complete task
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Complete task coming soon')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserOperationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Operations',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Verify New Users'),
                subtitle:
                    const Text('Review and approve new user registrations'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to user verification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('User verification coming soon')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text('Edit User Records'),
                subtitle: const Text('Update user information and permissions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to user management
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('User management coming soon')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.verified_user),
                title: const Text('Identity Verification'),
                subtitle: const Text('Process identity verification requests'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to identity verification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Identity verification coming soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reports',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.assessment),
                title: const Text('Task Reports'),
                subtitle: const Text('View task completion statistics'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to task reports
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task reports coming soon')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('User Activity'),
                subtitle: const Text('Monitor user engagement and activity'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to user activity reports
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('User activity reports coming soon')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Export Data'),
                subtitle: const Text('Export reports in various formats'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show export options
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export options coming soon')),
                  );
                },
              ),
            ],
          ),
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
}
