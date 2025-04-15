import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
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
                _buildProfileHeader(context, userInfo),
                const SizedBox(height: 24),
                _buildPersonalInfoSection(context, userInfo),
                const SizedBox(height: 24),
                _buildSettingsSection(context),
                const SizedBox(height: 24),
                _buildNotificationsSection(context),
                if (!AuthService.isGuestMode) ...[
                  const SizedBox(height: 24),
                  _buildDangerZone(context),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, Map<String, dynamic> userInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                userInfo['name'][0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userInfo['name'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              userInfo['email'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (userInfo['role'] != 'guest') ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  userInfo['role'].toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(
      BuildContext context, Map<String, dynamic> userInfo) {
    return _buildSection(
      context,
      title: 'Personal Information',
      children: [
        _buildInfoTile(
          context,
          icon: Icons.person_outline,
          title: 'Full Name',
          subtitle: userInfo['name'],
          onTap: () => _showEditDialog(context, 'name', userInfo['name']),
        ),
        _buildInfoTile(
          context,
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: userInfo['email'],
          onTap: () => _showEditDialog(context, 'email', userInfo['email']),
        ),
        if (userInfo['department'] != null)
          _buildInfoTile(
            context,
            icon: Icons.business_outlined,
            title: 'Department',
            subtitle: userInfo['department'],
            onTap: () =>
                _showEditDialog(context, 'department', userInfo['department']),
          ),
        _buildInfoTile(
          context,
          icon: Icons.calendar_today_outlined,
          title: 'Member Since',
          subtitle: 'January 1, 2024', // TODO: Add actual date
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Settings',
      children: [
        _buildSettingsTile(
          context,
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => _showChangePasswordDialog(context),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'English',
          onTap: () => _showLanguageDialog(context),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.palette_outlined,
          title: 'Theme',
          subtitle: 'System',
          onTap: () => _showThemeDialog(context),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Notifications',
      children: [
        _buildNotificationTile(
          context,
          title: 'Task Updates',
          subtitle: 'Get notified about task changes',
          value: true,
          onChanged: (value) =>
              _updateNotificationSetting(context, 'task_updates', value),
        ),
        _buildNotificationTile(
          context,
          title: 'Attendance Reminders',
          subtitle: 'Daily attendance check-in reminders',
          value: true,
          onChanged: (value) => _updateNotificationSetting(
              context, 'attendance_reminders', value),
        ),
        _buildNotificationTile(
          context,
          title: 'System Alerts',
          subtitle: 'Important system notifications',
          value: true,
          onChanged: (value) =>
              _updateNotificationSetting(context, 'system_alerts', value),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return _buildSection(
      context,
      title: 'Danger Zone',
      children: [
        _buildDangerTile(
          context,
          icon: Icons.logout,
          title: 'Log Out',
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.edit_outlined) : null,
      onTap: onTap,
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDangerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: const TextStyle(color: Colors.red)),
      onTap: onTap,
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    String field,
    String currentValue,
  ) async {
    final controller = TextEditingController(text: currentValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${field.capitalize()}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.capitalize(),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result != currentValue) {
      // TODO: Implement update logic
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully')),
        );
      }
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (newController.text == confirmController.text) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New passwords do not match'),
                  ),
                );
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );

    if (result == true) {
      // TODO: Implement password change logic
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
      }
    }
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context, 'en'),
            ),
            ListTile(
              title: const Text('Spanish'),
              onTap: () => Navigator.pop(context, 'es'),
            ),
            ListTile(
              title: const Text('French'),
              onTap: () => Navigator.pop(context, 'fr'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      // TODO: Implement language change logic
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Language changed to ${result.toUpperCase()}')),
        );
      }
    }
  }

  Future<void> _showThemeDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              onTap: () => Navigator.pop(context, 'system'),
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () => Navigator.pop(context, 'light'),
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () => Navigator.pop(context, 'dark'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      // TODO: Implement theme change logic
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Theme changed to ${result.capitalize()}')),
        );
      }
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (result == true) {
      await AuthService.logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _updateNotificationSetting(
      BuildContext context, String setting, bool value) {
    // TODO: Implement notification setting update logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting ${value ? 'enabled' : 'disabled'}'),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
