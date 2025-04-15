class Request {
  final String id;
  final String userId;
  final String type;
  final String status;
  final String location;
  final DateTime timestamp;
  final String? processedBy;
  final DateTime? processedAt;
  final String? notes;
  final Map<String, dynamic>? metadata;

  Request({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.location,
    required this.timestamp,
    this.processedBy,
    this.processedAt,
    this.notes,
    this.metadata,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      status: json['status'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      processedBy: json['processedBy'],
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      notes: json['notes'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'location': location,
      'notes': notes,
      'metadata': metadata,
    };
  }
}
