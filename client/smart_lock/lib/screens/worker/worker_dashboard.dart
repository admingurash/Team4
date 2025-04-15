import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/task_list.dart';
import '../../widgets/access_verification.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Worker Dashboard',
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.engineering, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Worker Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('My Tasks'),
              onTap: () => _showTasks(context),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Verify Access'),
              onTap: () => _showAccessVerification(context),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Reports'),
              onTap: () => _showReports(context),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Worker!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.task, color: Colors.orange),
              title: const Text('Pending Tasks'),
              subtitle: const Text('View and manage your assigned tasks'),
              onTap: () => _showTasks(context),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: const Text('Access Verification'),
              subtitle: const Text('Verify pending access requests'),
              onTap: () => _showAccessVerification(context),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.assessment, color: Colors.blue),
              title: const Text('Daily Reports'),
              subtitle: const Text('View access logs and statistics'),
              onTap: () => _showReports(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showTasks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskList(),
      ),
    );
  }

  void _showAccessVerification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccessVerification(),
      ),
    );
  }

  void _showReports(BuildContext context) {
    // TODO: Implement reports screen
  }
}
