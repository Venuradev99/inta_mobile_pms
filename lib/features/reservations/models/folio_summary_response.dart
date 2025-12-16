class FolioSummaryResponse {
  final double adjustmentAmount;
  final double balanceAmount;
  final double conversionRate;
  final double discountAmount;
  final int discountId;
  final double discountRate;
  final double extraCharges;
  final double folioLateCheckOutAmount;
  final double grossAmount;
  final bool isServiceChargeExempted;
  final bool isTaxExempted;
  final double lineDiscountAmount;
  final double paidAmount;
  final double roomCharges;
  final double roundOffAmount;
  final double serviceChargeAmount;
  final double taxAmount;
  final double totalAmount;
  final double transferAmount;
  final String visibleCurrencyCode;
  final int visibleCurrencyId;

  FolioSummaryResponse({
    required this.adjustmentAmount,
    required this.balanceAmount,
    required this.conversionRate,
    required this.discountAmount,
    required this.discountId,
    required this.discountRate,
    required this.extraCharges,
    required this.folioLateCheckOutAmount,
    required this.grossAmount,
    required this.isServiceChargeExempted,
    required this.isTaxExempted,
    required this.lineDiscountAmount,
    required this.paidAmount,
    required this.roomCharges,
    required this.roundOffAmount,
    required this.serviceChargeAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.transferAmount,
    required this.visibleCurrencyCode,
    required this.visibleCurrencyId,
  });

  factory FolioSummaryResponse.fromJson(Map<String, dynamic> json) {
    return FolioSummaryResponse(
      adjustmentAmount: (json['adjustmentAmount'] ?? 0).toDouble(),
      balanceAmount: (json['balanceAmount'] ?? 0).toDouble(),
      conversionRate: (json['conversionRate'] ?? 1).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      discountId: json['discountId'] ?? 0,
      discountRate: (json['discountRate'] ?? 0).toDouble(),
      extraCharges: (json['extraCharges'] ?? 0).toDouble(),
      folioLateCheckOutAmount:
          (json['folioLateCheckOutAmount'] ?? 0).toDouble(),
      grossAmount: (json['grossAmount'] ?? 0).toDouble(),
      isServiceChargeExempted: json['isServiceChargeExempted'] ?? false,
      isTaxExempted: json['isTaxExempted'] ?? false,
      lineDiscountAmount: (json['lineDiscountAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      roomCharges: (json['roomCharges'] ?? 0).toDouble(),
      roundOffAmount: (json['roundOffAmount'] ?? 0).toDouble(),
      serviceChargeAmount:
          (json['serviceChargeAmount'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      transferAmount: (json['transferAmount'] ?? 0).toDouble(),
      visibleCurrencyCode: json['visibleCurrencyCode'] ?? '',
      visibleCurrencyId: json['visibleCurrencyId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adjustmentAmount': adjustmentAmount,
      'balanceAmount': balanceAmount,
      'conversionRate': conversionRate,
      'discountAmount': discountAmount,
      'discountId': discountId,
      'discountRate': discountRate,
      'extraCharges': extraCharges,
      'folioLateCheckOutAmount': folioLateCheckOutAmount,
      'grossAmount': grossAmount,
      'isServiceChargeExempted': isServiceChargeExempted,
      'isTaxExempted': isTaxExempted,
      'lineDiscountAmount': lineDiscountAmount,
      'paidAmount': paidAmount,
      'roomCharges': roomCharges,
      'roundOffAmount': roundOffAmount,
      'serviceChargeAmount': serviceChargeAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'transferAmount': transferAmount,
      'visibleCurrencyCode': visibleCurrencyCode,
      'visibleCurrencyId': visibleCurrencyId,
    };
  }
}
