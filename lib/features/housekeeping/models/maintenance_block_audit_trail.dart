class MaintenanceBlockAuditTrail {
  final int id;
  final int hotelId;
  final String name;
  final String description;
  final String transactionTypeName;
  final int userId;
  final String userName;
  final DateTime sysDateCreated;

  MaintenanceBlockAuditTrail({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.transactionTypeName,
    required this.userId,
    required this.userName,
    required this.sysDateCreated,
  });

  factory MaintenanceBlockAuditTrail.fromJson(Map<String, dynamic> json) {
    return MaintenanceBlockAuditTrail(
      id: json['id'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      transactionTypeName: json['transactionTypeName'] ?? '',
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      sysDateCreated: json['sys_DateCreated'] != null
          ? DateTime.parse(json['sys_DateCreated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'description': description,
      'transactionTypeName': transactionTypeName,
      'userId': userId,
      'userName': userName,
      'sys_DateCreated': sysDateCreated.toIso8601String(),
    };
  }
}
