class CheckinData {
  final int bookingRoomId;
  final int bookingStatus;
  final DateTime checkinDate;
  final String colorCode;
  final String groupColor;
  final String guestName;
  final int index;
  final int isCheckinDate;
  final bool isGroupBooking;
  final bool isGroupLeader;
  final int maintenanceBlockId;
  final int noOfNights;
  final String toolTipRemarks;

  CheckinData({
    required this.bookingRoomId,
    required this.bookingStatus,
    required this.checkinDate,
    required this.colorCode,
    required this.groupColor,
    required this.guestName,
    required this.index,
    required this.isCheckinDate,
    required this.isGroupBooking,
    required this.isGroupLeader,
    required this.maintenanceBlockId,
    required this.noOfNights,
    required this.toolTipRemarks,
  });

  factory CheckinData.fromJson(Map<String, dynamic> json) {
    return CheckinData(
      bookingRoomId: json['bookingRoomId'] ?? 0,
      bookingStatus: json['bookingStatus'] ?? 0,
      checkinDate: DateTime.parse(json['checkinDate']),
      colorCode: json['colorCode'] ?? '',
      groupColor: json['groupColor'] ?? '',
      guestName: json['guestName'] ?? '',
      index: json['index'] ?? 0,
      isCheckinDate: json['isCheckinDate'] ?? 0,
      isGroupBooking: json['isGroupBooking'] ?? false,
      isGroupLeader: json['isGroupLeader'] ?? false,
      maintenanceBlockId: json['maintenanceBlockId'] ?? 0,
      noOfNights: json['noOfNights'] ?? 0,
      toolTipRemarks: json['toolTipRemarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingRoomId': bookingRoomId,
      'bookingStatus': bookingStatus,
      'checkinDate': checkinDate.toIso8601String(),
      'colorCode': colorCode,
      'groupColor': groupColor,
      'guestName': guestName,
      'index': index,
      'isCheckinDate': isCheckinDate,
      'isGroupBooking': isGroupBooking,
      'isGroupLeader': isGroupLeader,
      'maintenanceBlockId': maintenanceBlockId,
      'noOfNights': noOfNights,
      'toolTipRemarks': toolTipRemarks,
    };
  }

  @override
  String toString() {
    return 'BookingRoom('
        'bookingRoomId: $bookingRoomId, '
        'bookingStatus: $bookingStatus, '
        'checkinDate: $checkinDate, '
        'colorCode: $colorCode, '
        'groupColor: $groupColor, '
        'guestName: $guestName, '
        'index: $index, '
        'isCheckinDate: $isCheckinDate, '
        'isGroupBooking: $isGroupBooking, '
        'isGroupLeader: $isGroupLeader, '
        'maintenanceBlockId: $maintenanceBlockId, '
        'noOfNights: $noOfNights, '
        'toolTipRemarks: $toolTipRemarks'
        ')';
  }
}
