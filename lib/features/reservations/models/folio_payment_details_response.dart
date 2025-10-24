class FolioPaymentDetailsResponse {
  final List<dynamic> chargeList;
  final double grossAmount;
  final int discountId;
  final double serviceChargeAmount;
  final double discountAmount;
  final double discountRate;
  final double lineDiscountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double balanceAmount;
  final double transferAmount;
  final double adjustmentAmount;
  final double folioLateCheckOutAmount;
  final double roomCharges;
  final double extraCharges;
  final bool isServiceChargeExempted;
  final bool isTaxExempted;
  final int visibleCurrencyId;
  final String visibleCurrencyCode;
  final double conversionRate;

  FolioPaymentDetailsResponse({
    required this.chargeList,
    required this.grossAmount,
    required this.discountId,
    required this.serviceChargeAmount,
    required this.discountAmount,
    required this.discountRate,
    required this.lineDiscountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.balanceAmount,
    required this.transferAmount,
    required this.adjustmentAmount,
    required this.folioLateCheckOutAmount,
    required this.roomCharges,
    required this.extraCharges,
    required this.isServiceChargeExempted,
    required this.isTaxExempted,
    required this.visibleCurrencyId,
    required this.visibleCurrencyCode,
    required this.conversionRate,
  });

  factory FolioPaymentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return FolioPaymentDetailsResponse(
      chargeList: json['chargeList'] ?? [],
      grossAmount: (json['grossAmount'] ?? 0).toDouble(),
      discountId: json['discountId'] ?? 0,
      serviceChargeAmount: (json['serviceChargeAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      discountRate: (json['discountRate'] ?? 0).toDouble(),
      lineDiscountAmount: (json['lineDiscountAmount'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      balanceAmount: (json['balanceAmount'] ?? 0).toDouble(),
      transferAmount: (json['transferAmount'] ?? 0).toDouble(),
      adjustmentAmount: (json['adjustmentAmount'] ?? 0).toDouble(),
      folioLateCheckOutAmount: (json['folioLateCheckOutAmount'] ?? 0).toDouble(),
      roomCharges: (json['roomCharges'] ?? 0).toDouble(),
      extraCharges: (json['extraCharges'] ?? 0).toDouble(),
      isServiceChargeExempted: json['isServiceChargeExempted'] ?? false,
      isTaxExempted: json['isTaxExempted'] ?? false,
      visibleCurrencyId: json['visibleCurrencyId'] ?? 0,
      visibleCurrencyCode: json['visibleCurrencyCode'] ?? '',
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chargeList': chargeList,
      'grossAmount': grossAmount,
      'discountId': discountId,
      'serviceChargeAmount': serviceChargeAmount,
      'discountAmount': discountAmount,
      'discountRate': discountRate,
      'lineDiscountAmount': lineDiscountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'transferAmount': transferAmount,
      'adjustmentAmount': adjustmentAmount,
      'folioLateCheckOutAmount': folioLateCheckOutAmount,
      'roomCharges': roomCharges,
      'extraCharges': extraCharges,
      'isServiceChargeExempted': isServiceChargeExempted,
      'isTaxExempted': isTaxExempted,
      'visibleCurrencyId': visibleCurrencyId,
      'visibleCurrencyCode': visibleCurrencyCode,
      'conversionRate': conversionRate,
    };
  }

  @override
  String toString() {
    return '''
ChargeSummary(
  grossAmount: $grossAmount,
  discountId: $discountId,
  serviceChargeAmount: $serviceChargeAmount,
  discountAmount: $discountAmount,
  discountRate: $discountRate,
  lineDiscountAmount: $lineDiscountAmount,
  taxAmount: $taxAmount,
  totalAmount: $totalAmount,
  paidAmount: $paidAmount,
  balanceAmount: $balanceAmount,
  transferAmount: $transferAmount,
  adjustmentAmount: $adjustmentAmount,
  folioLateCheckOutAmount: $folioLateCheckOutAmount,
  roomCharges: $roomCharges,
  extraCharges: $extraCharges,
  isServiceChargeExempted: $isServiceChargeExempted,
  isTaxExempted: $isTaxExempted,
  visibleCurrencyId: $visibleCurrencyId,
  visibleCurrencyCode: $visibleCurrencyCode,
  conversionRate: $conversionRate,
  chargeList length: ${chargeList.length}
)''';
  }
}
