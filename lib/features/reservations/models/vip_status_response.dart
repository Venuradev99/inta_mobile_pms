class VipStatusResponse{
  final int vipStatusId;
  final String name;
  final String description;
  final int createdBy;
  final int lastModifiedBy;
  final int status;
  final String createdByUserName;
  final String lastModifiedByUserName;
  final String statusName;
  final int hotelId;

  VipStatusResponse({
    required this.vipStatusId,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
    required this.createdByUserName,
    required this.lastModifiedByUserName,
    required this.statusName,
    required this.hotelId,
  });

  /// Factory constructor to create an object from JSON
  factory VipStatusResponse.fromJson(Map<String, dynamic> json) {
    return VipStatusResponse(
      vipStatusId: json['vipStatusId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
      createdByUserName: json['createdByUserName'] ?? '',
      lastModifiedByUserName: json['lastModifiedByUserName'] ?? '',
      statusName: json['statusName'] ?? '',
      hotelId: json['hotelId'] ?? 0,
    );
  }

  /// Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'vipStatusId': vipStatusId,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'statusName': statusName,
      'hotelId': hotelId,
    };
  }

  /// For easy debugging or logging
  @override
  String toString() {
    return 'VipStatusResponse(vipStatusId: $vipStatusId, name: $name, description: $description, '
        'createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, status: $status, '
        'createdByUserName: $createdByUserName, lastModifiedByUserName: $lastModifiedByUserName, '
        'statusName: $statusName, hotelId: $hotelId)';
  }
}
