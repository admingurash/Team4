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
