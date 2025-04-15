class AttendanceData {
  final Owner owner;
  final String city;
  final String workLocation;
  final String projectLink;
  final String status;
  final List<String> teamMembers;

  AttendanceData({
    required this.owner,
    required this.city,
    required this.workLocation,
    required this.projectLink,
    required this.status,
    required this.teamMembers,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      owner: Owner.fromJson(json['owner']),
      city: json['city'],
      workLocation: json['workLocation'],
      projectLink: json['projectLink'],
      status: json['status'],
      teamMembers: List<String>.from(json['teamMembers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner.toJson(),
      'city': city,
      'workLocation': workLocation,
      'projectLink': projectLink,
      'status': status,
      'teamMembers': teamMembers,
    };
  }
}

class Owner {
  final String name;
  final String role;
  final String avatar;

  Owner({required this.name, required this.role, required this.avatar});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role, 'avatar': avatar};
  }
}
