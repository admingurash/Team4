import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/access_request_form.dart';
import '../../widgets/access_history_list.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Smart Lock Dashboard',
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('New Access Request'),
              onTap: () => _showAccessRequestForm(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Access History'),
              onTap: () => _showAccessHistory(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => _showProfile(context),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.blue),
              title: const Text('Submit Access Request'),
              subtitle: const Text('Request access to a specific location'),
              onTap: () => _showAccessRequestForm(context),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.orange),
              title: const Text('Recent Access History'),
              subtitle: const Text('View your recent access records'),
              onTap: () => _showAccessHistory(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccessRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AccessRequestForm(),
    );
  }

  void _showAccessHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccessHistoryList(),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    // TODO: Implement profile screen
  }
}
