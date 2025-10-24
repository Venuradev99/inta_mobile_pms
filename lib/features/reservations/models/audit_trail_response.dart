class AuditTrailResponse {
  final int bookingId;
  final String description;
  final int folioId;
  final int roomId;
  final String sysDateCreated;
  final int transactionLog;
  final int transactionType;
  final int userId;
  final String userName;
  final String transactionTypeName;
  final int hotelId;

  AuditTrailResponse({
    required this.bookingId,
    required this.description,
    required this.folioId,
    required this.roomId,
    required this.sysDateCreated,
    required this.transactionLog,
    required this.transactionType,
    required this.userId,
    required this.userName,
    required this.transactionTypeName,
    required this.hotelId,
  });

  factory AuditTrailResponse.fromJson(Map<String, dynamic> json) {
    return AuditTrailResponse(
      bookingId: json['bookingId'] ?? 0,
      description: json['description'] ?? '',
      folioId: json['folioId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      sysDateCreated: json['sys_DateCreated'] ?? '',
      transactionLog: json['transactionLog'] ?? 0,
      transactionType: json['transactionType'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      transactionTypeName: json['transactionTypeName'] ?? '',
      hotelId: json['hotelId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'description': description,
      'folioId': folioId,
      'roomId': roomId,
      'sys_DateCreated': sysDateCreated,
      'transactionLog': transactionLog,
      'transactionType': transactionType,
      'userId': userId,
      'userName': userName,
      'transactionTypeName': transactionTypeName,
      'hotelId': hotelId,
    };
  }

  @override
  String toString() {
    return 'AuditTrailResponse(bookingId: $bookingId, description: $description, folioId: $folioId, roomId: $roomId, sysDateCreated: $sysDateCreated, transactionLog: $transactionLog, transactionType: $transactionType, userId: $userId, userName: $userName, transactionTypeName: $transactionTypeName, hotelId: $hotelId)';
  }
}
