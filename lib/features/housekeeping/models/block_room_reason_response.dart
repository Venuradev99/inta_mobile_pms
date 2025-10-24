class BlockRoomReasonResponse {
  final int reasonId;
  final String name;
  final String? description;
  final int? reasonCategoryId;
  final bool? isBlackListReason;
  final int? indexId;
  final String? shortCode;
  final String? ipAddress;
  final String? deviceId;
  final int? hotelId;
  final String? sysDateCreated;
  final String? sysDateLastModified;
  final int? sysVersion;
  final int? createdBy;
  final int? lastModifiedBy;
  final String? rowVersion;
  final int? status;

 BlockRoomReasonResponse({
    required this.reasonId,
    required this.name,
    this.description,
    this.reasonCategoryId,
    this.isBlackListReason,
    this.indexId,
    this.shortCode,
    this.ipAddress,
    this.deviceId,
    this.hotelId,
    this.sysDateCreated,
    this.sysDateLastModified,
    this.sysVersion,
    this.createdBy,
    this.lastModifiedBy,
    this.rowVersion,
    this.status,
  });

  factory BlockRoomReasonResponse.fromJson(Map<String, dynamic> json) {
    return BlockRoomReasonResponse(
      reasonId: json['reasonId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      reasonCategoryId: json['reasonCategoryId'],
      isBlackListReason: json['isBlackListReason'],
      indexId: json['indexId'],
      shortCode: json['shortCode'],
      ipAddress: json['ipAddress'],
      deviceId: json['deviceId'],
      hotelId: json['hotelId'],
      sysDateCreated: json['sysDateCreated'],
      sysDateLastModified: json['sysDateLastModified'],
      sysVersion: json['sysVersion'],
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
      rowVersion: json['rowVersion'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reasonId': reasonId,
      'name': name,
      'description': description,
      'reasonCategoryId': reasonCategoryId,
      'isBlackListReason': isBlackListReason,
      'indexId': indexId,
      'shortCode': shortCode,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'hotelId': hotelId,
      'sysDateCreated': sysDateCreated,
      'sysDateLastModified': sysDateLastModified,
      'sysVersion': sysVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'rowVersion': rowVersion,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'BlockRoomReasonResponse(reasonId: $reasonId, name: $name)';
  }
}
