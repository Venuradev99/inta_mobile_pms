class FolioChargesResponse{
  final int folioChargeId;
  final DateTime date;
  final String roomName;
  final String referenceNo;
  final String particulars;
  final String description;
  final String user;

  final double grossAmount;
  final double amount;

  final int chargeTypeId;
  final String chargeName;

  final double discount;
  final double totalDiscount;
  final int discountId;
  final double lineDiscount;
  final int lineDiscountId;
  final double lineDiscountRate;

  final double serviceCharge;
  final int batchId;

  final bool isInclusion;
  final bool isRoomCharge;

  final int transferedToFolioId;
  final String? transferedToFolioName;
  final String? transferedToRoomNo;
  final String? transferedToReservationNo;

  final int transferedFromFolioId;
  final String? transferedFromFolioName;
  final String? transferedFromRoomNo;
  final String? transferedFromReservationNo;

  final int hotelId;
  final double roundOffAmount;

  final DateTime sysDateCreated;
  final DateTime sysDateLastModified;
  final int sysVersion;
  final int createdBy;
  final int lastModifiedBy;

  final String? rowVersion;
  final String? status;

  FolioChargesResponse({
    required this.folioChargeId,
    required this.date,
    required this.roomName,
    required this.referenceNo,
    required this.particulars,
    required this.description,
    required this.user,
    required this.grossAmount,
    required this.amount,
    required this.chargeTypeId,
    required this.chargeName,
    required this.discount,
    required this.totalDiscount,
    required this.discountId,
    required this.lineDiscount,
    required this.lineDiscountId,
    required this.lineDiscountRate,
    required this.serviceCharge,
    required this.batchId,
    required this.isInclusion,
    required this.isRoomCharge,
    required this.transferedToFolioId,
    required this.transferedToFolioName,
    required this.transferedToRoomNo,
    required this.transferedToReservationNo,
    required this.transferedFromFolioId,
    required this.transferedFromFolioName,
    required this.transferedFromRoomNo,
    required this.transferedFromReservationNo,
    required this.hotelId,
    required this.roundOffAmount,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.rowVersion,
    required this.status,
  });

  factory FolioChargesResponse.fromJson(Map<String, dynamic> json) {
    return FolioChargesResponse(
      folioChargeId: json['folioChargeId'] ?? 0,
      date: DateTime.parse(json['date']),
      roomName: json['roomName'] ?? '',
      referenceNo: json['referenceNo'] ?? '',
      particulars: json['particulars'] ?? '',
      description: json['description'] ?? '',
      user: json['user'] ?? '',
      grossAmount: (json['grossAmount'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      chargeTypeId: json['chargeTypeId'] ?? 0,
      chargeName: json['chargeName'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      totalDiscount: (json['totalDiscount'] ?? 0).toDouble(),
      discountId: json['discountId'] ?? 0,
      lineDiscount: (json['lineDiscount'] ?? 0).toDouble(),
      lineDiscountId: json['lineDiscountId'] ?? 0,
      lineDiscountRate: (json['lineDiscountRate'] ?? 0).toDouble(),
      serviceCharge: (json['serviceCharge'] ?? 0).toDouble(),
      batchId: json['batchId'] ?? 0,
      isInclusion: json['isInclusion'] ?? false,
      isRoomCharge: json['isRoomCharge'] ?? false,
      transferedToFolioId: json['transferedToFolioId'] ?? 0,
      transferedToFolioName: json['transferedToFolioName'],
      transferedToRoomNo: json['transferedToRoomNo'],
      transferedToReservationNo: json['transferedToReservationNo'],
      transferedFromFolioId: json['transferedFromFolioId'] ?? 0,
      transferedFromFolioName: json['transferedFromFolioName'],
      transferedFromRoomNo: json['transferedFromRoomNo'],
      transferedFromReservationNo: json['transferedFromReservationNo'],
      hotelId: json['hotelId'] ?? 0,
      roundOffAmount: (json['roundOffAmount'] ?? 0).toDouble(),
      sysDateCreated: DateTime.parse(json['sysDateCreated']),
      sysDateLastModified: DateTime.parse(json['sysDateLastModified']),
      sysVersion: json['sysVersion'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      rowVersion: json['rowVersion'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folioChargeId': folioChargeId,
      'date': date.toIso8601String(),
      'roomName': roomName,
      'referenceNo': referenceNo,
      'particulars': particulars,
      'description': description,
      'user': user,
      'grossAmount': grossAmount,
      'amount': amount,
      'chargeTypeId': chargeTypeId,
      'chargeName': chargeName,
      'discount': discount,
      'totalDiscount': totalDiscount,
      'discountId': discountId,
      'lineDiscount': lineDiscount,
      'lineDiscountId': lineDiscountId,
      'lineDiscountRate': lineDiscountRate,
      'serviceCharge': serviceCharge,
      'batchId': batchId,
      'isInclusion': isInclusion,
      'isRoomCharge': isRoomCharge,
      'transferedToFolioId': transferedToFolioId,
      'transferedToFolioName': transferedToFolioName,
      'transferedToRoomNo': transferedToRoomNo,
      'transferedToReservationNo': transferedToReservationNo,
      'transferedFromFolioId': transferedFromFolioId,
      'transferedFromFolioName': transferedFromFolioName,
      'transferedFromRoomNo': transferedFromRoomNo,
      'transferedFromReservationNo': transferedFromReservationNo,
      'hotelId': hotelId,
      'roundOffAmount': roundOffAmount,
      'sysDateCreated': sysDateCreated.toIso8601String(),
      'sysDateLastModified': sysDateLastModified.toIso8601String(),
      'sysVersion': sysVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'rowVersion': rowVersion,
      'status': status,
    };
  }
}
