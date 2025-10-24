class MaintenanceblockSavePayload {
  final String fromDate;
  final String toDate;
  final int reason;
  final List<int> roomIdList;

  MaintenanceblockSavePayload({
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.roomIdList,
  });

  factory MaintenanceblockSavePayload.fromJson(Map<String, dynamic> json) {
    return MaintenanceblockSavePayload(
      fromDate: json['FromDate'] ?? '',
      toDate: json['ToDate'] ?? '',
      reason: json['Reason'] ?? 0,
      roomIdList: List<int>.from(json['RoomIdList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      'Reason': reason,
      'RoomIdList': roomIdList,
    };
  }

  @override
  String toString() {
    return 'MaintenanceblockSavePayload(fromDate: $fromDate, toDate: $toDate, reason: $reason, roomIdList: $roomIdList)';
  }
}
