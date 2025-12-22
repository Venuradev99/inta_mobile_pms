class ChangeReservationPayload {
  final bool applyToAll;
  final BillingInformation billingInformation;
  final int bookingId;
  final int bookingRoomId;
  final CompanyOther companyOther;
  final String maxDep;
  final int maxNights;
  final String minArr;
  final int? pax;
  final String? vehiclePlate;
  final String voucherNo;
  final String? resDate;
  final bool isToBeReleased;

  ChangeReservationPayload({
    required this.applyToAll,
    required this.billingInformation,
    required this.bookingId,
    required this.bookingRoomId,
    required this.companyOther,
    required this.maxDep,
    required this.maxNights,
    required this.minArr,
    this.pax,
    this.vehiclePlate,
    required this.voucherNo,
    this.resDate,
    required this.isToBeReleased,
  });

  factory ChangeReservationPayload.fromJson(Map<String, dynamic> json) =>
      ChangeReservationPayload(
        applyToAll: json['applyToAll'],
        billingInformation: BillingInformation.fromJson(json['billingInformation']),
        bookingId: json['bookingId'],
        bookingRoomId: json['bookingRoomId'],
        companyOther: CompanyOther.fromJson(json['companyOther']),
        maxDep: json['maxDep'],
        maxNights: json['maxNights'],
        minArr: json['minArr'],
        pax: json['pax'],
        vehiclePlate: json['vehiclePlate'],
        voucherNo: json['voucherNo'],
        resDate: json['resDate'],
        isToBeReleased: json['isToBeReleased'],
      );

  Map<String, dynamic> toJson() => {
        'applyToAll': applyToAll,
        'billingInformation': billingInformation.toJson(),
        'bookingId': bookingId,
        'bookingRoomId': bookingRoomId,
        'companyOther': companyOther.toJson(),
        'maxDep': maxDep,
        'maxNights': maxNights,
        'minArr': minArr,
        'pax': pax,
        'vehiclePlate': vehiclePlate,
        'voucherNo': voucherNo,
        'resDate': resDate,
        'isToBeReleased': isToBeReleased,
      };
}

class BillingInformation {
  final int billingRateTypeId;
  final int billingInstructionId;
  final bool isTaxInclusiveRate;
  final String? taxRegistrationDate;
  final String billNumber;
  final bool isCash;
  final bool isComplementory;
  final double manualRate;
  final int paymentMode;
  final int paymentModeCategory;
  final int rateSourceId;
  final double releaseChargeAmountPercentage;
  final String releaseDate;

  BillingInformation({
    required this.billingRateTypeId,
    required this.billingInstructionId,
    required this.isTaxInclusiveRate,
    this.taxRegistrationDate,
    required this.billNumber,
    required this.isCash,
    required this.isComplementory,
    required this.manualRate,
    required this.paymentMode,
    required this.paymentModeCategory,
    required this.rateSourceId,
    required this.releaseChargeAmountPercentage,
    required this.releaseDate,
  });

  factory BillingInformation.fromJson(Map<String, dynamic> json) => BillingInformation(
        billingRateTypeId: json['billingRateTypeId'],
        billingInstructionId: json['billingInstructionId'],
        isTaxInclusiveRate: json['isTaxInclusiveRate'],
        taxRegistrationDate: json['taxRegistrationDate'],
        billNumber: json['billNumber'],
        isCash: json['isCash'],
        isComplementory: json['isComplementory'],
        manualRate: (json['manualRate'] ?? 0).toDouble(),
        paymentMode: json['paymentMode'],
        paymentModeCategory: json['paymentModeCategory'],
        rateSourceId: json['rateSourceId'],
        releaseChargeAmountPercentage:
            (json['releaseChargeAmountPercentage'] ?? 0).toDouble(),
        releaseDate: json['releaseDate'],
      );

  Map<String, dynamic> toJson() => {
        'billingRateTypeId': billingRateTypeId,
        'billingInstructionId': billingInstructionId,
        'isTaxInclusiveRate': isTaxInclusiveRate,
        'taxRegistrationDate': taxRegistrationDate,
        'billNumber': billNumber,
        'isCash': isCash,
        'isComplementory': isComplementory,
        'manualRate': manualRate,
        'paymentMode': paymentMode,
        'paymentModeCategory': paymentModeCategory,
        'rateSourceId': rateSourceId,
        'releaseChargeAmountPercentage': releaseChargeAmountPercentage,
        'releaseDate': releaseDate,
      };
}

class CompanyOther {
  final int businessCategoryId;
  final int businessSourceId;
  final int marketId;
  final int planId;
  final int planValue;
  final int reservationType;

  CompanyOther({
    required this.businessCategoryId,
    required this.businessSourceId,
    required this.marketId,
    required this.planId,
    required this.planValue,
    required this.reservationType,
  });

  factory CompanyOther.fromJson(Map<String, dynamic> json) => CompanyOther(
        businessCategoryId: json['businessCategoryId'],
        businessSourceId: json['businessSourceId'],
        marketId: json['marketId'],
        planId: json['planId'],
        planValue: json['planValue'],
        reservationType: json['reservationType'],
      );

  Map<String, dynamic> toJson() => {
        'businessCategoryId': businessCategoryId,
        'businessSourceId': businessSourceId,
        'marketId': marketId,
        'planId': planId,
        'planValue': planValue,
        'reservationType': reservationType,
      };
}
