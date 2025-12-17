class RoomCharge {
  final double amountWithTax;
  final int batchId;
  final int bookingRoomId;
  final int chargeId;
  final String? chargeName;
  final String? chargePostRuleName;
  final int chargeType;
  final String chargeTypeName;
  final int chargingRuleId;
  final String createdUserName;
  final String customDate;
  final String dateOfStay;
  final String? description;
  final double discount;
  final int folioChargeId;
  final int folioId;
  final double grossAmount;
  final bool isFullBoard;
  final bool isRoomCharge;
  final bool isTaxInclusive;
  final String modifiedUserName;
  final int noOfAdults;
  final int noOfBookings;
  final int noOfChildren;
  final int noOfInfant;
  final int postingRuleId;
  final double qty;
  final double quantity;
  final double ratePerUnit;
  final int rateTypeId;
  final String rateTypeName;
  final String? referenceNo;
  final String roomName;
  final int roomTypeId;
  final double roundOffAmount;
  final double serviceChargeAmount;
  final double tax1Amount;
  final double tax2Amount;
  final double tax3Amount;
  final double tax4Amount;
  final double tax5Amount;
  final double tax6Amount;
  final double tax7Amount;
  final double tax8Amount;
  final double tax9Amount;
  final double tax10Amount;
  final double taxAmount;
  final double totalAmount;

  RoomCharge({
    required this.amountWithTax,
    required this.batchId,
    required this.bookingRoomId,
    required this.chargeId,
    required this.chargeName,
    required this.chargePostRuleName,
    required this.chargeType,
    required this.chargeTypeName,
    required this.chargingRuleId,
    required this.createdUserName,
    required this.customDate,
    required this.dateOfStay,
    required this.description,
    required this.discount,
    required this.folioChargeId,
    required this.folioId,
    required this.grossAmount,
    required this.isFullBoard,
    required this.isRoomCharge,
    required this.isTaxInclusive,
    required this.modifiedUserName,
    required this.noOfAdults,
    required this.noOfBookings,
    required this.noOfChildren,
    required this.noOfInfant,
    required this.postingRuleId,
    required this.qty,
    required this.quantity,
    required this.ratePerUnit,
    required this.rateTypeId,
    required this.rateTypeName,
    required this.referenceNo,
    required this.roomName,
    required this.roomTypeId,
    required this.roundOffAmount,
    required this.serviceChargeAmount,
    required this.tax1Amount,
    required this.tax2Amount,
    required this.tax3Amount,
    required this.tax4Amount,
    required this.tax5Amount,
    required this.tax6Amount,
    required this.tax7Amount,
    required this.tax8Amount,
    required this.tax9Amount,
    required this.tax10Amount,
    required this.taxAmount,
    required this.totalAmount,
  });

  factory RoomCharge.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic val) => val == null ? 0 : (val as num).toDouble();

    return RoomCharge(
      amountWithTax: _toDouble(json['amountWithTax']),
      batchId: json['batchId'] ?? 0,
      bookingRoomId: json['bookingRoomId'] ?? 0,
      chargeId: json['chargeId'] ?? 0,
      chargeName: json['chargeName'],
      chargePostRuleName: json['chargePostRuleName'],
      chargeType: json['chargeType'] ?? 0,
      chargeTypeName: json['chargeTypeName'] ?? '',
      chargingRuleId: json['chargingRuleId'] ?? 0,
      createdUserName: json['createdUserName'] ?? '',
      customDate: json['customDate'] ?? '',
      dateOfStay: json['dateOfStay'] ?? '',
      description: json['description'],
      discount: _toDouble(json['discount']),
      folioChargeId: json['folioChargeId'] ?? 0,
      folioId: json['folioId'] ?? 0,
      grossAmount: _toDouble(json['grossAmount']),
      isFullBoard: json['isFullBoard'] ?? false,
      isRoomCharge: json['isRoomCharge'] ?? false,
      isTaxInclusive: json['isTaxInclusive'] ?? false,
      modifiedUserName: json['modifiedUserName'] ?? '',
      noOfAdults: json['noOfAdults'] ?? 0,
      noOfBookings: json['noOfBookings'] ?? 0,
      noOfChildren: json['noOfChildren'] ?? 0,
      noOfInfant: json['noOfInfant'] ?? 0,
      postingRuleId: json['postingRuleId'] ?? 0,
      qty: _toDouble(json['qty']),
      quantity: _toDouble(json['quantity']),
      ratePerUnit: _toDouble(json['ratePerUnit']),
      rateTypeId: json['rateTypeId'] ?? 0,
      rateTypeName: json['rateTypeName'] ?? '',
      referenceNo: json['referenceNo'],
      roomName: json['roomName'] ?? '',
      roomTypeId: json['roomTypeId'] ?? 0,
      roundOffAmount: _toDouble(json['roundOffAmount']),
      serviceChargeAmount: _toDouble(json['serviceChargeAmount']),
      tax1Amount: _toDouble(json['tax1Amount']),
      tax2Amount: _toDouble(json['tax2Amount']),
      tax3Amount: _toDouble(json['tax3Amount']),
      tax4Amount: _toDouble(json['tax4Amount']),
      tax5Amount: _toDouble(json['tax5Amount']),
      tax6Amount: _toDouble(json['tax6Amount']),
      tax7Amount: _toDouble(json['tax7Amount']),
      tax8Amount: _toDouble(json['tax8Amount']),
      tax9Amount: _toDouble(json['tax9Amount']),
      tax10Amount: _toDouble(json['tax10Amount']),
      taxAmount: _toDouble(json['taxAmount']),
      totalAmount: _toDouble(json['totalAmount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amountWithTax': amountWithTax,
      'batchId': batchId,
      'bookingRoomId': bookingRoomId,
      'chargeId': chargeId,
      'chargeName': chargeName,
      'chargePostRuleName': chargePostRuleName,
      'chargeType': chargeType,
      'chargeTypeName': chargeTypeName,
      'chargingRuleId': chargingRuleId,
      'createdUserName': createdUserName,
      'customDate': customDate,
      'dateOfStay': dateOfStay,
      'description': description,
      'discount': discount,
      'folioChargeId': folioChargeId,
      'folioId': folioId,
      'grossAmount': grossAmount,
      'isFullBoard': isFullBoard,
      'isRoomCharge': isRoomCharge,
      'isTaxInclusive': isTaxInclusive,
      'modifiedUserName': modifiedUserName,
      'noOfAdults': noOfAdults,
      'noOfBookings': noOfBookings,
      'noOfChildren': noOfChildren,
      'noOfInfant': noOfInfant,
      'postingRuleId': postingRuleId,
      'qty': qty,
      'quantity': quantity,
      'ratePerUnit': ratePerUnit,
      'rateTypeId': rateTypeId,
      'rateTypeName': rateTypeName,
      'referenceNo': referenceNo,
      'roomName': roomName,
      'roomTypeId': roomTypeId,
      'roundOffAmount': roundOffAmount,
      'serviceChargeAmount': serviceChargeAmount,
      'tax1Amount': tax1Amount,
      'tax2Amount': tax2Amount,
      'tax3Amount': tax3Amount,
      'tax4Amount': tax4Amount,
      'tax5Amount': tax5Amount,
      'tax6Amount': tax6Amount,
      'tax7Amount': tax7Amount,
      'tax8Amount': tax8Amount,
      'tax9Amount': tax9Amount,
      'tax10Amount': tax10Amount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
    };
  }
}
