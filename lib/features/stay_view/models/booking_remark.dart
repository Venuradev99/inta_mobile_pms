class BookingRemark {
  final int bookingRemarkId;
  final int bookingRoomId;
  final int createdBy;
  final String createdByUserName;
  final String description;
  final int hotelId;
  final int remarkId;
  final String remarkName;
  final int remarkTypeId;
  final String remarkTypeName;
  final String roomName;
  final int status;
  final DateTime sysDateCreated;

  BookingRemark({
    required this.bookingRemarkId,
    required this.bookingRoomId,
    required this.createdBy,
    required this.createdByUserName,
    required this.description,
    required this.hotelId,
    required this.remarkId,
    required this.remarkName,
    required this.remarkTypeId,
    required this.remarkTypeName,
    required this.roomName,
    required this.status,
    required this.sysDateCreated,
  });

  /// ✅ From JSON
  factory BookingRemark.fromJson(Map<String, dynamic> json) {
    return BookingRemark(
      bookingRemarkId: json['bookingRemarkId'] ?? 0,
      bookingRoomId: json['bookingRoomId'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      createdByUserName: json['createdByUserName'] ?? '',
      description: json['description'] ?? '',
      hotelId: json['hotelId'] ?? 0,
      remarkId: json['remarkId'] ?? 0,
      remarkName: json['remarkName'] ?? '',
      remarkTypeId: json['remarkTypeId'] ?? 0,
      remarkTypeName: json['remarkTypeName'] ?? '',
      roomName: json['roomName'] ?? '',
      status: json['status'] ?? 0,
      sysDateCreated: DateTime.parse(json['sysDateCreated']),
    );
  }

  /// ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingRemarkId': bookingRemarkId,
      'bookingRoomId': bookingRoomId,
      'createdBy': createdBy,
      'createdByUserName': createdByUserName,
      'description': description,
      'hotelId': hotelId,
      'remarkId': remarkId,
      'remarkName': remarkName,
      'remarkTypeId': remarkTypeId,
      'remarkTypeName': remarkTypeName,
      'roomName': roomName,
      'status': status,
      'sysDateCreated': sysDateCreated.toIso8601String(),
    };
  }

  /// ✅ toString override
  @override
  String toString() {
    return 'BookingRemark('
        'bookingRemarkId: $bookingRemarkId, '
        'bookingRoomId: $bookingRoomId, '
        'createdBy: $createdBy, '
        'createdByUserName: $createdByUserName, '
        'description: $description, '
        'hotelId: $hotelId, '
        'remarkId: $remarkId, '
        'remarkName: $remarkName, '
        'remarkTypeId: $remarkTypeId, '
        'remarkTypeName: $remarkTypeName, '
        'roomName: $roomName, '
        'status: $status, '
        'sysDateCreated: $sysDateCreated'
        ')';
  }
}
