class UnblockMaintenanceBlockPayload {
  final int maintenanceBlockId;
  final int hotelId;
  final int roomId;
  final int roomTypeId;
  final int reasonId;
  final String blockedBy;
  final String blockedOn;
  final String fromDate;
  final String toDate;
  final String reasonName;
  final String roomName;
  final String roomTypeName;
  final List<String> name;
  final int status;
  final List<UnblockDateRange> unblockDateRanges;

  UnblockMaintenanceBlockPayload({
    required this.maintenanceBlockId,
    required this.hotelId,
    required this.roomId,
    required this.roomTypeId,
    required this.reasonId,
    required this.blockedBy,
    required this.blockedOn,
    required this.fromDate,
    required this.toDate,
    required this.reasonName,
    required this.roomName,
    required this.roomTypeName,
    required this.name,
    required this.status,
    required this.unblockDateRanges,
  });

  factory UnblockMaintenanceBlockPayload.fromJson(Map<String, dynamic> json) {
    return UnblockMaintenanceBlockPayload(
      maintenanceBlockId: json['maintenanceBlockId'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      roomTypeId: json['roomTypeId'] ?? 0,
      reasonId: json['reasonId'] ?? 0,
      blockedBy: json['blockedBy'] ?? '',
      blockedOn: json['blockedOn'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      reasonName: json['reasonName'] ?? '',
      roomName: json['roomName'] ?? '',
      roomTypeName: json['roomTypeName'] ?? '',
      name: (json['name'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'] ?? 0,
      unblockDateRanges: (json['unblockDateRanges'] as List?)
              ?.map((e) => UnblockDateRange.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenanceBlockId': maintenanceBlockId,
      'hotelId': hotelId,
      'roomId': roomId,
      'roomTypeId': roomTypeId,
      'reasonId': reasonId,
      'blockedBy': blockedBy,
      'blockedOn': blockedOn,
      'fromDate': fromDate,
      'toDate': toDate,
      'reasonName': reasonName,
      'roomName': roomName,
      'roomTypeName': roomTypeName,
      'name': name,
      'status': status,
      'unblockDateRanges':
          unblockDateRanges.map((e) => e.toJson()).toList(),
    };
  }
}

class UnblockDateRange {
  final String fromDate;
  final String toDate;
  final int index;
  final bool isMain;
  final bool isOverlap;
  final String minDate;
  final String maxDate;

  UnblockDateRange({
    required this.fromDate,
    required this.toDate,
    required this.index,
    required this.isMain,
    required this.isOverlap,
    required this.minDate,
    required this.maxDate,
  });

  factory UnblockDateRange.fromJson(Map<String, dynamic> json) {
    return UnblockDateRange(
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      index: json['index'] ?? 0,
      isMain: json['isMain'] ?? false,
      isOverlap: json['isOverlap'] ?? false,
      minDate: json['minDate'] ?? '',
      maxDate: json['maxDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate,
      'toDate': toDate,
      'index': index,
      'isMain': isMain,
      'isOverlap': isOverlap,
      'minDate': minDate,
      'maxDate': maxDate,
    };
  }
}
