class MaintenanceBlockItem {
  final int maintenanceBlockId;
  final int roomId;
  final int roomTypeId;
  final String roomName;
  final String roomTypeName;
  final String fromDate;
  final String toDate;
  final int reasonId;
  final String reasonName;
  final String blockedBy;
  final String blockedOn;
  final int status;
  final int hotelId;

  MaintenanceBlockItem({
    required this.maintenanceBlockId,
    required this.roomId,
    required this.roomTypeId,
    required this.roomName,
    required this.roomTypeName,
    required this.fromDate,
    required this.toDate,
    required this.reasonId,
    required this.reasonName,
    required this.blockedBy,
    required this.blockedOn,
    required this.status,
    required this.hotelId,
  });

  /// ✅ From JSON
  factory MaintenanceBlockItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceBlockItem(
      maintenanceBlockId: json['maintenanceBlockId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      roomTypeId: json['roomTypeId'] ?? 0,
      roomName: json['roomName'] ?? '',
      roomTypeName: json['roomTypeName'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      reasonId: json['reasonId'] ?? 0,
      reasonName: json['reasonName'] ?? '',
      blockedBy: json['blockedBy'] ?? '',
      blockedOn: json['blockedOn'] ?? '',
      status: json['status'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
    );
  }

  /// ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'maintenanceBlockId': maintenanceBlockId,
      'roomId': roomId,
      'roomTypeId': roomTypeId,
      'roomName': roomName,
      'roomTypeName': roomTypeName,
      'fromDate': fromDate,
      'toDate': toDate,
      'reasonId': reasonId,
      'reasonName': reasonName,
      'blockedBy': blockedBy,
      'blockedOn': blockedOn,
      'status': status,
      'hotelId': hotelId,
    };
  }

  @override
  String toString() {
    return 'MaintenanceBlockItem('
        'maintenanceBlockId: $maintenanceBlockId, '
        'roomId: $roomId, '
        'roomTypeId: $roomTypeId, '
        'roomName: $roomName, '
        'roomTypeName: $roomTypeName, '
        'fromDate: $fromDate, '
        'toDate: $toDate, '
        'reasonId: $reasonId, '
        'reasonName: $reasonName, '
        'blockedBy: $blockedBy, '
        'blockedOn: $blockedOn, '
        'status: $status, '
        'hotelId: $hotelId'
        ')';
  }
}
