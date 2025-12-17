class FolioTaxItem {
  final int folioChargeId;
  final String taxName;
  final double amount;

  FolioTaxItem({
    required this.folioChargeId,
    required this.taxName,
    required this.amount,
  });

  factory FolioTaxItem.fromJson(Map<String, dynamic> json) {
    return FolioTaxItem(
      folioChargeId: json['folioChargeId'] ?? 0,
      taxName: json['taxName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'folioChargeId': folioChargeId,
      'taxName': taxName,
      'amount': amount,
    };
  }
}
