class ReservationSearchRequest {
  final int businessSourceId;
  final bool exceptCancelled;
  final String fromDate;
  final bool isArrivalDate;
  final int reservationTypeId;
  final int roomId;
  final int roomTypeId;
  final String searchByName;
  final int searchType;
  final int status;
  final String toDate;
  final int businessCategoryId;

  ReservationSearchRequest({
    required this.businessSourceId,
    required this.exceptCancelled,
    required this.fromDate,
    required this.isArrivalDate,
    required this.reservationTypeId,
    required this.roomId,
    required this.roomTypeId,
    required this.searchByName,
    required this.searchType,
    required this.status,
    required this.toDate,
    required this.businessCategoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'BusinessSourceId': businessSourceId,
      'ExceptCancelled': exceptCancelled,
      'FromDate': fromDate,
      'IsArrivalDate': isArrivalDate,
      'ReservationTypeId': reservationTypeId,
      'RoomId': roomId,
      'RoomTypeId': roomTypeId,
      'SearchByName': searchByName,
      'SearchType': searchType,
      'Status': status,
      'ToDate': toDate,
      'businessCategoryId': businessCategoryId,
    };
  }

  factory ReservationSearchRequest.fromJson(Map<String, dynamic> json) {
    return ReservationSearchRequest(
      businessSourceId: json['BusinessSourceId'] ?? 0,
      exceptCancelled: json['ExceptCancelled'] ?? false,
      fromDate: json['FromDate'] ?? '',
      isArrivalDate: json['IsArrivalDate'] ?? false,
      reservationTypeId: json['ReservationTypeId'] ?? 0,
      roomId: json['RoomId'] ?? 0,
      roomTypeId: json['RoomTypeId'] ?? 0,
      searchByName: json['SearchByName'] ?? '',
      searchType: json['SearchType'] ?? 0,
      status: json['Status'] ?? 0,
      toDate: json['ToDate'] ?? '',
      businessCategoryId: json['businessCategoryId'] ?? 0,
    );
  }
}
