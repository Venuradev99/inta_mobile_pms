class CurrencyItem {
  final int currencyId;
  final String code;
   final String symbol;

  CurrencyItem({
    required this.currencyId,
    required this.code,
    required this.symbol,
  });

  // Factory method to create an instance from JSON
  factory CurrencyItem.fromJson(Map<String, dynamic> json) {
    return CurrencyItem(
      currencyId: json['currencyId'] ?? 0,
      code: json['code'] ?? '',
       symbol: json['symbol'] ?? '',
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'currencyId': currencyId,
      'code': code,
        'symbol': symbol,
    };
  }

  // Override toString for easy printing
  @override
  String toString() {
    return 'CurrencyItem(currencyId: $currencyId, code: $code, symbol: $symbol)';
  }
}
