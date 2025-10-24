class RoomMoveSaveData {
  final int bookingRoomId;
  final int currencyId;
  final bool isManualRate;
  final bool isOverrideRate;
  final bool isTaxInclusive;
  final double manualRate;
  final int roomId;
  final int roomTypeId;

  RoomMoveSaveData({
    required this.bookingRoomId,
    required this.currencyId,
    required this.isManualRate,
    required this.isOverrideRate,
    required this.isTaxInclusive,
    required this.manualRate,
    required this.roomId,
    required this.roomTypeId,
  });

  factory RoomMoveSaveData.fromJson(Map<String, dynamic> json) {
    return RoomMoveSaveData(
      bookingRoomId: json['bookingRoomId'] is String
          ? int.tryParse(json['bookingRoomId']) ?? 0
          : json['bookingRoomId'] ?? 0,
      currencyId: json['currencyId'] is String
          ? int.tryParse(json['currencyId']) ?? 0
          : json['currencyId'] ?? 0,
      isManualRate: json['isManualRate'] ?? false,
      isOverrideRate: json['isOverrideRate'] ?? false,
      isTaxInclusive: json['isTaxInclusive'] ?? false,
      manualRate: json['manualRate'] is String
          ? double.tryParse(json['manualRate']) ?? 0.0
          : (json['manualRate'] ?? 0.0).toDouble(),
      roomId: json['roomId'] is String
          ? int.tryParse(json['roomId']) ?? 0
          : json['roomId'] ?? 0,
      roomTypeId: json['roomTypeId'] is String
          ? int.tryParse(json['roomTypeId']) ?? 0
          : json['roomTypeId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingRoomId': bookingRoomId,
      'currencyId': currencyId,
      'isManualRate': isManualRate,
      'isOverrideRate': isOverrideRate,
      'isTaxInclusive': isTaxInclusive,
      'manualRate': manualRate,
      'roomId': roomId,
      'roomTypeId': roomTypeId,
    };
  }

  @override
  String toString() {
    return 'RoomMoveSaveData(bookingRoomId: $bookingRoomId, currencyId: $currencyId, '
        'isManualRate: $isManualRate, isOverrideRate: $isOverrideRate, '
        'isTaxInclusive: $isTaxInclusive, manualRate: $manualRate, '
        'roomId: $roomId, roomTypeId: $roomTypeId)';
  }
}
