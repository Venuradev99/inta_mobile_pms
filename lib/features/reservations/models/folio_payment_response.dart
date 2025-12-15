class FolioPaymentResponse {
  final int batchId;
  final int chargeId;
  final int chargeTypeId;
  final DateTime dateOfStay;
  final String description;
  final String paymentMode;
  final String referenceNo;
  final int roomId;
  final String roomName;
  final double totalAmount;
  final String user;

  FolioPaymentResponse({
    required this.batchId,
    required this.chargeId,
    required this.chargeTypeId,
    required this.dateOfStay,
    required this.description,
    required this.paymentMode,
    required this.referenceNo,
    required this.roomId,
    required this.roomName,
    required this.totalAmount,
    required this.user,
  });

  factory FolioPaymentResponse.fromJson(Map<String, dynamic> json) {
    return FolioPaymentResponse(
      batchId: json['batchId'] ?? 0,
      chargeId: json['chargeId'] ?? 0,
      chargeTypeId: json['chargeTypeId'] ?? 0,
      dateOfStay: DateTime.parse(json['dateOfStay']),
      description: json['discription'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      referenceNo: json['referenceNo'] ?? '',
      roomId: json['roomId'] ?? 0,
      roomName: json['roomName'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      user: json['user'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'chargeId': chargeId,
      'chargeTypeId': chargeTypeId,
      'dateOfStay': dateOfStay.toIso8601String(),
      'discription': description,
      'paymentMode': paymentMode,
      'referenceNo': referenceNo,
      'roomId': roomId,
      'roomName': roomName,
      'totalAmount': totalAmount,
      'user': user,
    };
  }
}
