class SystemMetrics {
  final int totalUsers;
  final int activeUsers;
  final String storageUsed;
  final String totalStorage;
  final DateTime lastBackup;
  final String systemUptime;

  SystemMetrics({
    required this.totalUsers,
    required this.activeUsers,
    required this.storageUsed,
    required this.totalStorage,
    required this.lastBackup,
    required this.systemUptime,
  });

  factory SystemMetrics.fromJson(Map<String, dynamic> json) {
    return SystemMetrics(
      totalUsers: json['totalUsers'],
      activeUsers: json['activeUsers'],
      storageUsed: json['storageUsed'],
      totalStorage: json['totalStorage'],
      lastBackup: DateTime.parse(json['lastBackup']),
      systemUptime: json['systemUptime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'storageUsed': storageUsed,
      'totalStorage': totalStorage,
      'lastBackup': lastBackup.toIso8601String(),
      'systemUptime': systemUptime,
    };
  }
}

class SystemLog {
  final DateTime timestamp;
  final String type;
  final String user;
  final String details;

  SystemLog({
    required this.timestamp,
    required this.type,
    required this.user,
    required this.details,
  });

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      user: json['user'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'user': user,
      'details': details,
    };
  }
}

class BackupRecord {
  final String id;
  final DateTime timestamp;
  final String size;
  final String status;

  BackupRecord({
    required this.id,
    required this.timestamp,
    required this.size,
    required this.status,
  });

  factory BackupRecord.fromJson(Map<String, dynamic> json) {
    return BackupRecord(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      size: json['size'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'size': size,
      'status': status,
    };
  }
}

class ApiKey {
  final String key;
  final DateTime created;
  final DateTime lastUsed;

  ApiKey({
    required this.key,
    required this.created,
    required this.lastUsed,
  });

  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      key: json['key'],
      created: DateTime.parse(json['created']),
      lastUsed: DateTime.parse(json['lastUsed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'created': created.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
    };
  }
}
