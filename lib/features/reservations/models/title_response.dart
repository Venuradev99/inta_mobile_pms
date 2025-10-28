class TitleResponse {
  final int titleId;
  final String name;
  final String gender;
  final int indexId;
  final String deviceId;
  final int dtVersion;
  final String sysDateCreated;
  final String sysDateLastModified;
  final int sysVersion;
  final String rowVersion;
  final int createdBy;
  final int lastModifiedBy;
  final int status;

  TitleResponse({
    required this.titleId,
    required this.name,
    required this.gender,
    required this.indexId,
    required this.deviceId,
    required this.dtVersion,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.rowVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
  });

  /// Factory constructor to create from JSON
  factory TitleResponse.fromJson(Map<String, dynamic> json) {
    return TitleResponse(
      titleId: json['titleId'] ?? 0,
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      indexId: json['indexId'] ?? 0,
      deviceId: json['deviceId'] ?? '',
      dtVersion: json['dt_Version'] ?? 0,
      sysDateCreated: json['sys_DateCreated'] ?? '',
      sysDateLastModified: json['sys_DateLastModified'] ?? '',
      sysVersion: json['sys_Version'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'titleId': titleId,
      'name': name,
      'gender': gender,
      'indexId': indexId,
      'deviceId': deviceId,
      'dt_Version': dtVersion,
      'sys_DateCreated': sysDateCreated,
      'sys_DateLastModified': sysDateLastModified,
      'sys_Version': sysVersion,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
    };
  }

  /// toString override for debugging
  @override
  String toString() {
    return 'TitleResponse(titleId: $titleId, name: $name, gender: $gender, '
        'indexId: $indexId, deviceId: $deviceId, dtVersion: $dtVersion, '
        'sysDateCreated: $sysDateCreated, sysDateLastModified: $sysDateLastModified, '
        'sysVersion: $sysVersion, rowVersion: $rowVersion, createdBy: $createdBy, '
        'lastModifiedBy: $lastModifiedBy, status: $status)';
  }
}
