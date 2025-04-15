import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String _userInfoKey = 'user_info';
  static const String _guestModeKey = 'guest_mode';

  static bool _isGuestMode = false;
  static Map<String, dynamic>? _userInfo;

  // Test users for development
  static final Map<String, Map<String, dynamic>> _testUsers = {
    'admin@example.com': {
      'password': 'admin123',
      'role': UserRole.admin,
      'permissions': {
        'manage_users': true,
        'view_reports': true,
        'export_data': true,
        'manage_attendance': true,
        'verify_users': true,
        'edit_user_records': true,
      },
    },
    'manager@example.com': {
      'password': 'manager123',
      'role': UserRole.manager,
      'permissions': {
        'view_reports': true,
        'export_data': true,
        'manage_attendance': true,
        'verify_users': true,
      },
    },
    'worker@example.com': {
      'password': 'worker123',
      'role': UserRole.worker,
      'permissions': {
        'view_tasks': true,
        'edit_tasks': true,
        'verify_users': true,
        'edit_user_records': true,
      },
    },
  };

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isGuestMode = prefs.getBool(_guestModeKey) ?? false;

    if (_isGuestMode) {
      await loginAsGuest();
    }
  }

  static Future<bool> login(String email, String password) async {
    // Check against test users
    final userData = _testUsers[email];
    if (userData == null || userData['password'] != password) {
      return false;
    }

    // Create user object
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@')[0],
      email: email,
      role: userData['role'] as UserRole,
      department: 'IT', // Default department for test users
      permissions: Map<String, bool>.from(userData['permissions'] as Map),
    );

    // Save user session
    await _saveUserSession(user);
    return true;
  }

  static Future<void> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, true);
    _isGuestMode = true;

    final guestUser = User(
      id: 'guest',
      name: 'Guest User',
      email: 'guest@example.com',
      role: UserRole.guest,
      department: 'None',
      permissions: {
        'view_tasks': true,
      },
    );

    await _saveUserSession(guestUser);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
    await prefs.remove(_guestModeKey);
    _isGuestMode = false;
    _userInfo = null;
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    if (_isGuestMode) {
      return _userInfo;
    }

    final prefs = await SharedPreferences.getInstance();
    final userInfoStr = prefs.getString(_userInfoKey);
    if (userInfoStr == null) {
      return null;
    }

    return _userInfo;
  }

  static Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    _userInfo = user.toJson();
    await prefs.setString(_userInfoKey, _userInfo.toString());
  }

  // Permission checks
  static Future<bool> canManageUsers() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['manage_users'] ?? false;
  }

  static Future<bool> canViewReports() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['view_reports'] ?? false;
  }

  static Future<bool> canExportData() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['export_data'] ?? false;
  }

  static Future<bool> canManageAttendance() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['manage_attendance'] ?? false;
  }

  static Future<bool> canVerifyUsers() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['verify_users'] ?? false;
  }

  static Future<bool> canEditUserRecords() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['edit_user_records'] ?? false;
  }

  // Worker-specific permissions
  static Future<bool> canViewTasks() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['view_tasks'] ?? false;
  }

  static Future<bool> canEditTasks() async {
    final userInfo = await getUserInfo();
    if (userInfo == null) return false;
    return userInfo['permissions']['edit_tasks'] ?? false;
  }

  // Worker-specific API methods
  static Future<List<Map<String, dynamic>>> getAssignedTasks() async {
    // TODO: Implement API call
    return [
      {
        'id': '1',
        'title': 'Verify New User Registration',
        'description': 'Review and approve pending user registrations',
        'status': 'pending',
        'dueDate': DateTime.now().add(const Duration(days: 1)),
      },
      {
        'id': '2',
        'title': 'Update User Records',
        'description': 'Update department information for 5 users',
        'status': 'in_progress',
        'dueDate': DateTime.now().add(const Duration(days: 2)),
      },
      {
        'id': '3',
        'title': 'Generate Task Report',
        'description': 'Create a report of completed tasks for the week',
        'status': 'pending',
        'dueDate': DateTime.now().add(const Duration(days: 3)),
      },
    ];
  }

  static Future<void> updateTaskStatus(String taskId, String status) async {
    // TODO: Implement API call
    print('Updating task $taskId to status: $status');
  }

  static Future<List<Map<String, dynamic>>>
      getPendingUserVerifications() async {
    // TODO: Implement API call
    return [
      {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'department': 'Engineering',
        'requestDate': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'department': 'Marketing',
        'requestDate': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];
  }

  static Future<void> verifyUser(String userId, bool approved) async {
    // TODO: Implement API call
    print('Verifying user $userId: ${approved ? 'approved' : 'rejected'}');
  }

  static Future<List<Map<String, dynamic>>> getUserActivityReport() async {
    // TODO: Implement API call
    return [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'activeUsers': 45,
        'newRegistrations': 3,
        'completedTasks': 12,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'activeUsers': 42,
        'newRegistrations': 2,
        'completedTasks': 10,
      },
    ];
  }

  // Admin-specific API methods
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    // TODO: Implement API call
    return [
      {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'worker',
        'status': 'active',
        'lastLogin': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'role': 'manager',
        'status': 'active',
        'lastLogin': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];
  }

  static Future<void> createUser(Map<String, dynamic> userData) async {
    // TODO: Implement API call
    print('Creating user: ${userData['email']}');
  }

  static Future<void> updateUser(
      String userId, Map<String, dynamic> userData) async {
    // TODO: Implement API call
    print('Updating user $userId: ${userData['email']}');
  }

  static Future<void> deleteUser(String userId) async {
    // TODO: Implement API call
    print('Deleting user: $userId');
  }

  static Future<void> updateUserRole(String userId, String role) async {
    // TODO: Implement API call
    print('Updating role for user $userId to: $role');
  }

  static Future<List<Map<String, dynamic>>> getSystemLogs() async {
    // TODO: Implement API call
    return [
      {
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'type': 'login',
        'user': 'john@example.com',
        'details': 'Successful login',
      },
      {
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'type': 'security',
        'user': 'system',
        'details': 'Failed login attempt',
      },
    ];
  }

  static Future<Map<String, dynamic>> getSystemMetrics() async {
    // TODO: Implement API call
    return {
      'totalUsers': 150,
      'activeUsers': 45,
      'storageUsed': '375GB',
      'totalStorage': '500GB',
      'lastBackup': DateTime.now().subtract(const Duration(hours: 2)),
      'systemUptime': '7 days',
    };
  }

  static Future<void> updateSecurityPolicy(Map<String, dynamic> policy) async {
    // TODO: Implement API call
    print('Updating security policy: ${policy['name']}');
  }

  static Future<void> generateBackup() async {
    // TODO: Implement API call
    print('Generating system backup');
  }

  static Future<void> restoreBackup(String backupId) async {
    // TODO: Implement API call
    print('Restoring backup: $backupId');
  }

  static Future<List<Map<String, dynamic>>> getBackupHistory() async {
    // TODO: Implement API call
    return [
      {
        'id': '1',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'size': '2.5GB',
        'status': 'completed',
      },
      {
        'id': '2',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'size': '2.3GB',
        'status': 'completed',
      },
    ];
  }

  static Future<void> unlockAccount(String userId) async {
    // TODO: Implement API call
    print('Unlocking account for user: $userId');
  }

  static Future<void> resetUserPassword(String userId) async {
    // TODO: Implement API call
    print('Resetting password for user: $userId');
  }

  static Future<Map<String, dynamic>> getApiKeys() async {
    // TODO: Implement API call
    return {
      'production': {
        'key': 'prod_*****',
        'created': DateTime.now().subtract(const Duration(days: 30)),
        'lastUsed': DateTime.now().subtract(const Duration(hours: 1)),
      },
      'development': {
        'key': 'dev_*****',
        'created': DateTime.now().subtract(const Duration(days: 15)),
        'lastUsed': DateTime.now().subtract(const Duration(hours: 2)),
      },
    };
  }

  static Future<void> rotateApiKey(String keyId) async {
    // TODO: Implement API call
    print('Rotating API key: $keyId');
  }

  static Future<void> revokeApiKey(String keyId) async {
    // TODO: Implement API call
    print('Revoking API key: $keyId');
  }

  // Admin permission checks
  static bool isAdmin() {
    if (_isGuestMode) return false;
    return _userInfo?['role'] == UserRole.admin;
  }

  static bool canManageSystem() {
    if (_isGuestMode) return false;
    return isAdmin();
  }

  static bool canManageSecurity() {
    if (_isGuestMode) return false;
    return isAdmin();
  }

  static bool canViewAnalytics() {
    if (_isGuestMode) return false;
    return isAdmin() || _userInfo?['permissions']?.contains('view_reports') ??
        false;
  }

  static bool canManageSettings() {
    if (_isGuestMode) return false;
    return isAdmin();
  }

  static bool canOverrideAccounts() {
    if (_isGuestMode) return false;
    return isAdmin();
  }
}
