class DayUseResponse {
  final DateTime bookingDate;
  final int bookingRoomId;
  final int roomTypeId;
  final String roomTypeName;
  final int roomId;
  final String roomName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int bookingRoomOwnerId;
  final String bookingRoomOwnerName;
  final String colorCode;
  final int status;

  DayUseResponse({
    required this.bookingDate,
    required this.bookingRoomId,
    required this.roomTypeId,
    required this.roomTypeName,
    required this.roomId,
    required this.roomName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookingRoomOwnerId,
    required this.bookingRoomOwnerName,
    required this.colorCode,
    required this.status,
  });

  /// Factory constructor
  factory DayUseResponse.fromJson(Map<String, dynamic> json) {
    return DayUseResponse(
      bookingDate: DateTime.parse(json['bookingDate']),
      bookingRoomId: json['bookingRoomId'],
      roomTypeId: json['roomTypeId'],
      roomTypeName: json['roomTypeName'],
      roomId: json['roomId'],
      roomName: json['roomName'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      bookingRoomOwnerId: json['bookingRoomOwnerId'],
      bookingRoomOwnerName: json['bookingRoomOwnerName'],
      colorCode: json['colorCode'],
      status: json['status'],
    );
  }

  /// Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      "bookingDate": bookingDate.toIso8601String(),
      "bookingRoomId": bookingRoomId,
      "roomTypeId": roomTypeId,
      "roomTypeName": roomTypeName,
      "roomId": roomId,
      "roomName": roomName,
      "checkInDate": checkInDate.toIso8601String(),
      "checkOutDate": checkOutDate.toIso8601String(),
      "bookingRoomOwnerId": bookingRoomOwnerId,
      "bookingRoomOwnerName": bookingRoomOwnerName,
      "colorCode": colorCode,
      "status": status,
    };
  }
}
