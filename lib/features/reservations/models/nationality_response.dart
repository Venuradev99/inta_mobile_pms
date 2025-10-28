class NationalityResponse {
  final int nationalityId;
  final String name;
  final String description;
  final int indexId;
  final String shortCode;
  final String ipAddress;
  final String deviceId;
  final String sysDateCreated;
  final String sysDateLastModified;
  final int sysVersion;
  final String rowVersion;
  final int createdBy;
  final int lastModifiedBy;
  final int status;

  NationalityResponse({
    required this.nationalityId,
    required this.name,
    required this.description,
    required this.indexId,
    required this.shortCode,
    required this.ipAddress,
    required this.deviceId,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.rowVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
  });

  /// Factory constructor to create object from JSON
  factory NationalityResponse.fromJson(Map<String, dynamic> json) {
    return NationalityResponse(
      nationalityId: json['nationalityId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      indexId: json['indexId'] ?? 0,
      shortCode: json['shortCode'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      deviceId: json['deviceId'] ?? '',
      sysDateCreated: json['sys_DateCreated'] ?? '',
      sysDateLastModified: json['sys_DateLastModified'] ?? '',
      sysVersion: json['sys_Version'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  /// Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'nationalityId': nationalityId,
      'name': name,
      'description': description,
      'indexId': indexId,
      'shortCode': shortCode,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'sys_DateCreated': sysDateCreated,
      'sys_DateLastModified': sysDateLastModified,
      'sys_Version': sysVersion,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'NationalityResponse(nationalityId: $nationalityId, name: $name, description: $description, indexId: $indexId, '
        'shortCode: $shortCode, ipAddress: $ipAddress, deviceId: $deviceId, sysDateCreated: $sysDateCreated, '
        'sysDateLastModified: $sysDateLastModified, sysVersion: $sysVersion, rowVersion: $rowVersion, '
        'createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, status: $status)';
  }
}
