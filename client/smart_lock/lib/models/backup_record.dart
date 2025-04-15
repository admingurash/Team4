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
