import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/user_management.dart';
import '../../widgets/system_logs.dart';
import '../../widgets/task_assignment.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Admin Dashboard',
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.admin_panel_settings, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () => _showUserManagement(context),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Task Assignment'),
              onTap: () => _showTaskAssignment(context),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('System Logs'),
              onTap: () => _showSystemLogs(context),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security Settings'),
              onTap: () => _showSecuritySettings(context),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Administrator!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildDashboardCard(
                context,
                'User Management',
                Icons.people,
                Colors.blue,
                () => _showUserManagement(context),
              ),
              _buildDashboardCard(
                context,
                'Task Assignment',
                Icons.task,
                Colors.orange,
                () => _showTaskAssignment(context),
              ),
              _buildDashboardCard(
                context,
                'System Logs',
                Icons.assessment,
                Colors.green,
                () => _showSystemLogs(context),
              ),
              _buildDashboardCard(
                context,
                'Security Settings',
                Icons.security,
                Colors.red,
                () => _showSecuritySettings(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserManagement(),
      ),
    );
  }

  void _showTaskAssignment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskAssignment(),
      ),
    );
  }

  void _showSystemLogs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SystemLogs(),
      ),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    // TODO: Implement security settings screen
  }
}
