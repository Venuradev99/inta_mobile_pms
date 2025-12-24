import 'package:inta_mobile_pms/features/stay_view/models/available_rooms.dart';

class UnassignBookingItem {
  final DateTime bookingDate;
  final int bookingRoomId;
  final int roomTypeId;
  final String roomTypeName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int bookingRoomOwnerId;
  final String bookingRoomOwnerName;
  List<AvailableRooms>? availableRooms;

  UnassignBookingItem({
    required this.bookingDate,
    required this.bookingRoomId,
    required this.roomTypeId,
    required this.roomTypeName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookingRoomOwnerId,
    required this.bookingRoomOwnerName,
    this.availableRooms,
  });

  // From JSON
  factory UnassignBookingItem.fromJson(Map<String, dynamic> json) {
    return UnassignBookingItem(
      bookingDate: DateTime.parse(json['bookingDate']),
      bookingRoomId: json['bookingRoomId'],
      roomTypeId: json['roomTypeId'],
      roomTypeName: json['roomTypeName'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      bookingRoomOwnerId: json['bookingRoomOwnerId'],
      bookingRoomOwnerName: json['bookingRoomOwnerName'],
      availableRooms: json['availableRooms'] != null
          ? List<AvailableRooms>.from(
              json['availableRooms'].map((x) => AvailableRooms.fromJson(x)),
            )
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingDate': bookingDate.toIso8601String(),
      'bookingRoomId': bookingRoomId,
      'roomTypeId': roomTypeId,
      'roomTypeName': roomTypeName,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'bookingRoomOwnerId': bookingRoomOwnerId,
      'bookingRoomOwnerName': bookingRoomOwnerName,
      'availableRooms': availableRooms?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'UnassignBookingItem(bookingDate: $bookingDate, bookingRoomId: $bookingRoomId, roomTypeId: $roomTypeId, roomTypeName: $roomTypeName, checkInDate: $checkInDate, checkOutDate: $checkOutDate, bookingRoomOwnerId: $bookingRoomOwnerId, bookingRoomOwnerName: $bookingRoomOwnerName, availableRooms: ${availableRooms?.map((e) => e.toString()).toList()})';
  }
}
