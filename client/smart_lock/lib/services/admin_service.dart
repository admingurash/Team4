import '../models/system_log.dart';
import '../models/backup_record.dart';
import '../models/user.dart';

class AdminService {
  static Future<List<User>> getUsers() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.admin,
        department: 'IT',
        permissions: {
          'manage_users': true,
          'view_reports': true,
          'export_data': true,
        },
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: UserRole.manager,
        department: 'HR',
        permissions: {
          'view_reports': true,
          'export_data': true,
        },
      ),
      User(
        id: '3',
        name: 'Bob Wilson',
        email: 'bob@example.com',
        role: UserRole.worker,
        department: 'Operations',
        permissions: {
          'view_tasks': true,
          'edit_tasks': true,
        },
      ),
    ];
  }

  static Future<void> updateUserRole(String userId, UserRole newRole) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> updateUserPermissions(
      String userId, Map<String, bool> permissions) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<List<SystemLog>> getSystemLogs() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      SystemLog(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: 'login',
        user: 'john@example.com',
        details: 'User logged in successfully',
      ),
      SystemLog(
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'error',
        user: 'system',
        details: 'Failed to connect to database',
      ),
    ];
  }

  static Future<List<BackupRecord>> getBackupHistory() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      BackupRecord(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        size: '2.5 GB',
        status: 'completed',
      ),
      BackupRecord(
        id: '2',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        size: '2.4 GB',
        status: 'completed',
      ),
    ];
  }

  static Future<void> createBackup() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> restoreBackup(String backupId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<Map<String, dynamic>> getSystemMetrics() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'total_users': 150,
      'active_users': 120,
      'total_attendance_records': 5000,
      'system_uptime': '99.9%',
      'storage_usage': '75%',
    };
  }
}
