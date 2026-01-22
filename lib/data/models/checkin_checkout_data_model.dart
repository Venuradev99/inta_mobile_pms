class CheckinCheckoutDataModel {
  final int reservationSettingId;
  final int settingGroup;
  final String settingSuperType;
  final String name;
  final bool isEnabled;
  final String value1;
  final String value2;
  final int indexId;
  final int hotelId;
  final DateTime sysDateCreated;
  final DateTime sysDateLastModified;
  final int sysVersion;
  final String rowVersion;
  final int createdBy;
  final int lastModifiedBy;
  final int status;

  CheckinCheckoutDataModel({
    required this.reservationSettingId,
    required this.settingGroup,
    required this.settingSuperType,
    required this.name,
    required this.isEnabled,
    required this.value1,
    required this.value2,
    required this.indexId,
    required this.hotelId,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.rowVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
  });

  /// ✅ JSON → Model
  factory CheckinCheckoutDataModel.fromJson(Map<String, dynamic> json) {
    return CheckinCheckoutDataModel(
      reservationSettingId: json['reservationSettingId'] ?? 0,
      settingGroup: json['settingGroup'] ?? 0,
      settingSuperType: json['settingSuperType'] ?? '',
      name: json['name'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      value1: json['value1'] ?? '',
      value2: json['value2'] ?? '',
      indexId: json['indexId'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
      sysDateCreated: DateTime.parse(json['sys_DateCreated']),
      sysDateLastModified: DateTime.parse(json['sys_DateLastModified']),
      sysVersion: json['sys_Version'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservationSettingId': reservationSettingId,
      'settingGroup': settingGroup,
      'settingSuperType': settingSuperType,
      'name': name,
      'isEnabled': isEnabled,
      'value1': value1,
      'value2': value2,
      'indexId': indexId,
      'hotelId': hotelId,
      'sys_DateCreated': sysDateCreated.toIso8601String(),
      'sys_DateLastModified': sysDateLastModified.toIso8601String(),
      'sys_Version': sysVersion,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
    };
  }
}
