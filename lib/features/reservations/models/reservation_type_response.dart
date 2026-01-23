class ReservationTypeResponse {
  final int reservationTypeId;
  final String name;
  final String description;
  final int indexId;
  final String shortCode;
  final bool isSystemDefine;
  final String ipAddress;
  final String deviceId;
  final bool isConfirmed;
  final String colorCode;
  final String createdByUserName;
  final String lastModifiedByUserName;
  final int hotelId;
  final DateTime sysDateCreated;
  final DateTime sysDateLastModified;
  final int sysVersion;
  final int createdBy;
  final int lastModifiedBy;
  final String rowVersion;
  final int status;

  ReservationTypeResponse({
    required this.reservationTypeId,
    required this.name,
    required this.description,
    required this.indexId,
    required this.shortCode,
    required this.isSystemDefine,
    required this.ipAddress,
    required this.deviceId,
    required this.isConfirmed,
    required this.colorCode,
    required this.createdByUserName,
    required this.lastModifiedByUserName,
    required this.hotelId,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.rowVersion,
    required this.status,
  });

  factory ReservationTypeResponse.fromJson(Map<String, dynamic> json) {
    return ReservationTypeResponse(
      reservationTypeId: json['reservationTypeId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      indexId: json['indexId'] ?? 0,
      shortCode: json['shortCode'] ?? '',
      isSystemDefine: json['isSystemDefine'] ?? false,
      ipAddress: json['ipAddress'] ?? '',
      deviceId: json['deviceId'] ?? '',
      isConfirmed: json['isConfirmed'] ?? false,
      colorCode: json['colorCode'] ?? '',
      createdByUserName: json['createdByUserName'] ?? '',
      lastModifiedByUserName: json['lastModifiedByUserName'] ?? '',
      hotelId: json['hotelId'] ?? 0,
      sysDateCreated:
          DateTime.tryParse(json['sysDateCreated'] ?? '') ?? DateTime.now(),
      sysDateLastModified:
          DateTime.tryParse(json['sysDateLastModified'] ?? '') ??
          DateTime.now(),
      sysVersion: json['sysVersion'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservationTypeId': reservationTypeId,
      'name': name,
      'description': description,
      'indexId': indexId,
      'shortCode': shortCode,
      'isSystemDefine': isSystemDefine,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'isConfirmed': isConfirmed,
      'colorCode': colorCode,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'hotelId': hotelId,
      'sysDateCreated': sysDateCreated.toIso8601String(),
      'sysDateLastModified': sysDateLastModified.toIso8601String(),
      'sysVersion': sysVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'rowVersion': rowVersion,
      'status': status,
    };
  }
}
