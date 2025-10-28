class IdentityTypeResponse {
  final int identityTypeId;
  final String name;
  final String description;
  final int indexId;
  final String shortCode;
  final String ipAddress;
  final String deviceId;
  final int createdBy;
  final int lastModifiedBy;
  final int status;
  final String createdByUserName;
  final String lastModifiedByUserName;
  final String statusName;

  IdentityTypeResponse({
    required this.identityTypeId,
    required this.name,
    required this.description,
    required this.indexId,
    required this.shortCode,
    required this.ipAddress,
    required this.deviceId,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
    required this.createdByUserName,
    required this.lastModifiedByUserName,
    required this.statusName,
  });

  /// Factory to create an instance from JSON
  factory IdentityTypeResponse.fromJson(Map<String, dynamic> json) {
    return IdentityTypeResponse(
      identityTypeId: json['identityTypeId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      indexId: json['indexId'] ?? 0,
      shortCode: json['shortCode'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      deviceId: json['deviceId'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
      createdByUserName: json['createdByUserName'] ?? '',
      lastModifiedByUserName: json['lastModifiedByUserName'] ?? '',
      statusName: json['statusName'] ?? '',
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'identityTypeId': identityTypeId,
      'name': name,
      'description': description,
      'indexId': indexId,
      'shortCode': shortCode,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'statusName': statusName,
    };
  }

  /// For debugging/logging
  @override
  String toString() {
    return 'IdentityTypeResponse(identityTypeId: $identityTypeId, name: $name, description: $description, '
        'indexId: $indexId, shortCode: $shortCode, ipAddress: $ipAddress, deviceId: $deviceId, '
        'createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, status: $status, '
        'createdByUserName: $createdByUserName, lastModifiedByUserName: $lastModifiedByUserName, '
        'statusName: $statusName)';
  }
}
