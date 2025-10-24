class BaseCurrency {
  final int currencyId;
  final String code;
  final String description;
  final String symbol;
  final int decimalPlaces;
  final String decimalSeparator;
  final String thousandsSeparator;
  final int crCurrencyPositionType;
  final int crNegativeType;
  final double exchangeRate;
  final bool isBalanceCurrency;
  final bool isBaseCurrency;
  final DateTime sysDateCreated;
  final DateTime sysDateLastModified;
  final int sysVersion;
  final String rowVersion;
  final int createdBy;
  final int lastModifiedBy;
  final int status;

  BaseCurrency({
    required this.currencyId,
    required this.code,
    required this.description,
    required this.symbol,
    required this.decimalPlaces,
    required this.decimalSeparator,
    required this.thousandsSeparator,
    required this.crCurrencyPositionType,
    required this.crNegativeType,
    required this.exchangeRate,
    required this.isBalanceCurrency,
    required this.isBaseCurrency,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.rowVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
  });

    factory BaseCurrency.empty() {
    return BaseCurrency(
      currencyId: 0,
      code: '',
      description: '',
      symbol: '',
      decimalPlaces: 0,
      decimalSeparator: '',
      thousandsSeparator: '',
      crCurrencyPositionType: 0,
      crNegativeType: 0,
      exchangeRate: 0.0,
      isBalanceCurrency: false,
      isBaseCurrency: false,
      sysDateCreated: DateTime(1970),
      sysDateLastModified: DateTime(1970),
      sysVersion: 0,
      rowVersion: '',
      createdBy: 0,
      lastModifiedBy: 0,
      status: 0,
    );
  }

  factory BaseCurrency.fromJson(Map<String, dynamic> json) {
    return BaseCurrency(
      currencyId: json['currencyId'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      symbol: json['symbol'] ?? '',
      decimalPlaces: json['decimalPlaces'] ?? 0,
      decimalSeparator: json['decimalSeparator'] ?? '',
      thousandsSeparator: json['thousandsSeparator'] ?? '',
      crCurrencyPositionType: json['crCurrencyPositionType'] ?? 0,
      crNegativeType: json['crNegativeType'] ?? 0,
      exchangeRate: (json['exchangeRate'] ?? 0).toDouble(),
      isBalanceCurrency: json['isBalanceCurrency'] ?? false,
      isBaseCurrency: json['isBaseCurrency'] ?? false,
      sysDateCreated: DateTime.tryParse(json['sys_DateCreated'] ?? '') ?? DateTime(1970),
      sysDateLastModified: DateTime.tryParse(json['sys_DateLastModified'] ?? '') ?? DateTime(1970),
      sysVersion: json['sys_Version'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyId': currencyId,
      'code': code,
      'description': description,
      'symbol': symbol,
      'decimalPlaces': decimalPlaces,
      'decimalSeparator': decimalSeparator,
      'thousandsSeparator': thousandsSeparator,
      'crCurrencyPositionType': crCurrencyPositionType,
      'crNegativeType': crNegativeType,
      'exchangeRate': exchangeRate,
      'isBalanceCurrency': isBalanceCurrency,
      'isBaseCurrency': isBaseCurrency,
      'sys_DateCreated': sysDateCreated.toIso8601String(),
      'sys_DateLastModified': sysDateLastModified.toIso8601String(),
      'sys_Version': sysVersion,
      'rowVersion': rowVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
    };
  }
}
