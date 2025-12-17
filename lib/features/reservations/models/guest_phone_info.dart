class GuestPhoneInfo {
  int createdBy;
  int guestId;
  int guestPhoneId;
  int guestPhoneNumberId;
  String? ipAddress;
  bool isPrimary;
  int lastModifiedBy;
  String number;
  String rowVersion;
  int status;
  DateTime sysDateCreated;
  DateTime sysDateLastModified;
  int sysVersion;
  int type;

  GuestPhoneInfo({
    required this.createdBy,
    required this.guestId,
    required this.guestPhoneId,
    required this.guestPhoneNumberId,
    this.ipAddress,
    required this.isPrimary,
    required this.lastModifiedBy,
    required this.number,
    required this.rowVersion,
    required this.status,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.type,
  });

  factory GuestPhoneInfo.fromJson(Map<String, dynamic> json) {
    return GuestPhoneInfo(
      createdBy: json['createdBy'] ?? 0,
      guestId: json['guestId'] ?? 0,
      guestPhoneId: json['guestPhoneId'] ?? 0,
      guestPhoneNumberId: json['guestPhoneNumberId'] ?? 0,
      ipAddress: json['ipAddress'],
      isPrimary: json['isPrimary'] ?? false,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      number: json['number'] ?? "",
      rowVersion: json['rowVersion'] ?? "",
      status: json['status'] ?? 0,
      sysDateCreated: json['sysDateCreated'] != null
          ? DateTime.parse(json['sysDateCreated'])
          : DateTime.now(),
      sysDateLastModified: json['sysDateLastModified'] != null
          ? DateTime.parse(json['sysDateLastModified'])
          : DateTime.now(),
      sysVersion: json['sysVersion'] ?? 0,
      type: json['type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdBy': createdBy,
      'guestId': guestId,
      'guestPhoneId': guestPhoneId,
      'guestPhoneNumberId': guestPhoneNumberId,
      'ipAddress': ipAddress,
      'isPrimary': isPrimary,
      'lastModifiedBy': lastModifiedBy,
      'number': number,
      'rowVersion': rowVersion,
      'status': status,
      'sysDateCreated': sysDateCreated.toIso8601String(),
      'sysDateLastModified': sysDateLastModified.toIso8601String(),
      'sysVersion': sysVersion,
      'type': type,
    };
  }
}
