class WorkOrderAuditTrailItem {
  final int id;
  final int hotelId;
  final String name;
  final String transactionTypeName;
  final String description;
  final int userId;
  final String userName;
  final DateTime sysDateCreated;

  WorkOrderAuditTrailItem({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.transactionTypeName,
    required this.description,
    required this.userId,
    required this.userName,
    required this.sysDateCreated,
  });

  factory WorkOrderAuditTrailItem.fromJson(Map<String, dynamic> json) {
    return WorkOrderAuditTrailItem(
      id: json['id'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
      name: json['name'] ?? '',
      transactionTypeName: json['transactionTypeName'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      sysDateCreated: DateTime.parse(json['sys_DateCreated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'transactionTypeName': transactionTypeName,
      'description': description,
      'userId': userId,
      'userName': userName,
      'sys_DateCreated': sysDateCreated.toIso8601String(),
    };
  }
}
