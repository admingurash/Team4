class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final String assignedBy;
  final String status;
  final String priority;
  final DateTime dueDate;
  final DateTime? completedAt;
  final String? notes;
  final List<Map<String, String>>? attachments;
  final List<String>? relatedRequests;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedBy,
    required this.status,
    required this.priority,
    required this.dueDate,
    this.completedAt,
    this.notes,
    this.attachments,
    this.relatedRequests,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assignedTo'],
      assignedBy: json['assignedBy'],
      status: json['status'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['dueDate']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      notes: json['notes'],
      attachments: json['attachments'] != null
          ? List<Map<String, String>>.from(json['attachments'])
          : null,
      relatedRequests: json['relatedRequests'] != null
          ? List<String>.from(json['relatedRequests'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'status': status,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'notes': notes,
      'attachments': attachments,
      'relatedRequests': relatedRequests,
    };
  }
}
