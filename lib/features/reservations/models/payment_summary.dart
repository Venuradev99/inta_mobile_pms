class PaymentSummary {
  final double totalPrice;
  final double totalServiceCharge;
  final double totalTax;
  final double totalGrossAmount;
  final double totalPaid;
  final double balance;

  PaymentSummary({
    required this.totalPrice,
    required this.totalServiceCharge,
    required this.totalTax,
    required this.totalGrossAmount,
    required this.totalPaid,
    required this.balance,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalServiceCharge: (json['totalServiceCharge'] ?? 0).toDouble(),
      totalTax: (json['totalTax'] ?? 0).toDouble(),
      totalGrossAmount: (json['totalGrossAmount'] ?? 0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'totalServiceCharge': totalServiceCharge,
      'totalTax': totalTax,
      'totalGrossAmount': totalGrossAmount,
      'totalPaid': totalPaid,
      'balance': balance,
    };
  }
}
