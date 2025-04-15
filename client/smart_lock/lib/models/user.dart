enum UserRole { admin, manager, worker, guest }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  final Map<String, bool> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      department: json['department'],
      permissions: Map<String, bool>.from(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'department': department,
      'permissions': permissions,
    };
  }

  bool hasPermission(String permission) {
    return permissions[permission] ?? false;
  }

  bool isAdmin() => role == UserRole.admin;
  bool isManager() => role == UserRole.manager;
  bool isWorker() => role == UserRole.worker;
  bool isGuest() => role == UserRole.guest;

  bool canManageUsers() {
    return role == UserRole.admin || role == UserRole.manager;
  }

  bool canViewReports() {
    return role != UserRole.guest;
  }

  bool canExportData() {
    return role == UserRole.admin || role == UserRole.manager;
  }

  bool canManageAttendance() {
    return role != UserRole.guest;
  }
}
