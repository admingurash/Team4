import 'package:flutter/material.dart';
import '../models/user.dart';

class NavigationItem {
  final String title;
  final String route;
  final IconData icon;
  final List<String> requiredPermissions;

  NavigationItem({
    required this.title,
    required this.route,
    required this.icon,
    required this.requiredPermissions,
  });
}

class NavigationService {
  static final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Home',
      route: '/home',
      icon: Icons.home,
      requiredPermissions: [],
    ),
    NavigationItem(
      title: 'Admin Dashboard',
      route: '/admin',
      icon: Icons.admin_panel_settings,
      requiredPermissions: ['manage_users', 'manage_system'],
    ),
    NavigationItem(
      title: 'Worker Dashboard',
      route: '/worker',
      icon: Icons.work,
      requiredPermissions: ['view_tasks', 'edit_tasks'],
    ),
    NavigationItem(
      title: 'Reports',
      route: '/reports',
      icon: Icons.assessment,
      requiredPermissions: ['view_reports'],
    ),
    NavigationItem(
      title: 'Attendance',
      route: '/attendance',
      icon: Icons.calendar_today,
      requiredPermissions: ['manage_attendance'],
    ),
    NavigationItem(
      title: 'Profile',
      route: '/profile',
      icon: Icons.person,
      requiredPermissions: [],
    ),
  ];

  static List<NavigationItem> getNavigationItems(
      Map<String, bool> permissions) {
    return _navigationItems.where((item) {
      if (item.requiredPermissions.isEmpty) return true;
      return item.requiredPermissions
          .any((permission) => permissions[permission] == true);
    }).toList();
  }

  static String getInitialRoute(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin';
      case UserRole.worker:
        return '/worker';
      case UserRole.manager:
        return '/reports';
      case UserRole.guest:
        return '/home';
    }
  }

  static Widget buildRoleBasedDrawer(
    BuildContext context,
    Map<String, dynamic> userInfo,
  ) {
    final permissions = Map<String, bool>.from(userInfo['permissions'] as Map);
    final navigationItems = getNavigationItems(permissions);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userInfo['name']),
            accountEmail: Text(userInfo['email']),
            currentAccountPicture: CircleAvatar(
              child: Text(
                userInfo['name'][0].toUpperCase(),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    if (item.route != ModalRoute.of(context)?.settings.name) {
                      Navigator.pushReplacementNamed(context, item.route);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
