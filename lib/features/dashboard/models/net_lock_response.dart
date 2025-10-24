class NetLockResponse {
  final int bookingRoomId;
  final int bookingId;
  final String reservationNo;
  final int roomId;
  final int roomTypeId;
  final int rateTypeId;
  final String roomName;
  final int bookingRoomOwnerId;
  final String bookingGuest;
  final String bookingGuestWithTitle;
  final String pax;
  final String arrivalDate;
  final int noOfAdults;
  final int noOfChildren;
  final String arrivalTime;
  final String departureDate;
  final String departureTime;
  final dynamic rateOffered; // can be null
  final String roomTypeName;
  final String rateTypeName;
  final int recordLockedBy;
  final String recordLockedUserName;
  final int status;
  final int hotelId;

  NetLockResponse({
    required this.bookingRoomId,
    required this.bookingId,
    required this.reservationNo,
    required this.roomId,
    required this.roomTypeId,
    required this.rateTypeId,
    required this.roomName,
    required this.bookingRoomOwnerId,
    required this.bookingGuest,
    required this.bookingGuestWithTitle,
    required this.pax,
    required this.arrivalDate,
    required this.noOfAdults,
    required this.noOfChildren,
    required this.arrivalTime,
    required this.departureDate,
    required this.departureTime,
    this.rateOffered,
    required this.roomTypeName,
    required this.rateTypeName,
    required this.recordLockedBy,
    required this.recordLockedUserName,
    required this.status,
    required this.hotelId,
  });

  factory NetLockResponse.fromJson(Map<String, dynamic> json) {
    return NetLockResponse(
      bookingRoomId: json['bookingRoomId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      reservationNo: json['reservationNo'] ?? '',
      roomId: json['roomId'] ?? 0,
      roomTypeId: json['roomTypeId'] ?? 0,
      rateTypeId: json['rateTypeId'] ?? 0,
      roomName: json['roomName'] ?? '',
      bookingRoomOwnerId: json['bookingRoomOwnerId'] ?? 0,
      bookingGuest: json['bookingGuest'] ?? '',
      bookingGuestWithTitle: json['bookingGuestWithTitle'] ?? '',
      pax: json['pax'] ?? '',
      arrivalDate: json['arrivalDate'] ?? '',
      noOfAdults: json['noOfAdults'] ?? 0,
      noOfChildren: json['noOfChildren'] ?? 0,
      arrivalTime: json['arrivalTime'] ?? '',
      departureDate: json['departureDate'] ?? '',
      departureTime: json['departureTime'] ?? '',
      rateOffered: json['rateOffered'],
      roomTypeName: json['roomTypeName'] ?? '',
      rateTypeName: json['rateTypeName'] ?? '',
      recordLockedBy: json['recordLockedBy'] ?? 0,
      recordLockedUserName: json['recordLockedUserName'] ?? '',
      status: json['status'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingRoomId': bookingRoomId,
      'bookingId': bookingId,
      'reservationNo': reservationNo,
      'roomId': roomId,
      'roomTypeId': roomTypeId,
      'rateTypeId': rateTypeId,
      'roomName': roomName,
      'bookingRoomOwnerId': bookingRoomOwnerId,
      'bookingGuest': bookingGuest,
      'bookingGuestWithTitle': bookingGuestWithTitle,
      'pax': pax,
      'arrivalDate': arrivalDate,
      'noOfAdults': noOfAdults,
      'noOfChildren': noOfChildren,
      'arrivalTime': arrivalTime,
      'departureDate': departureDate,
      'departureTime': departureTime,
      'rateOffered': rateOffered,
      'roomTypeName': roomTypeName,
      'rateTypeName': rateTypeName,
      'recordLockedBy': recordLockedBy,
      'recordLockedUserName': recordLockedUserName,
      'status': status,
      'hotelId': hotelId,
    };
  }

  @override
  String toString() {
    return 'NetLockResponse(bookingRoomId: $bookingRoomId, reservationNo: $reservationNo, roomName: $roomName, bookingGuest: $bookingGuest, roomTypeName: $roomTypeName, status: $status)';
  }
}
