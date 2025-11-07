class ManagerReportInfo {
  final String baseCurrencyCode;
  final String baseCurrencySymbol;
  final String generatedBy;
  final String propertyName;
  final int recordsCount;
  final String reportGeneratedCurrencySymbol;
  final String reportName;

  ManagerReportInfo({
    required this.baseCurrencyCode,
    required this.baseCurrencySymbol,
    required this.generatedBy,
    required this.propertyName,
    required this.recordsCount,
    required this.reportGeneratedCurrencySymbol,
    required this.reportName,
  });

  // Factory constructor to create an instance from JSON
  factory ManagerReportInfo.fromJson(Map<String, dynamic> json) {
    return ManagerReportInfo(
      baseCurrencyCode: json['baseCurrencyCode'] ?? '',
      baseCurrencySymbol: json['baseCurrencySymbol'] ?? '',
      generatedBy: json['generatedBy'] ?? '',
      propertyName: json['propertyName'] ?? '',
      recordsCount: json['recordsCount'] ?? 0,
      reportGeneratedCurrencySymbol: json['reportGeneratedCurrencySymbol'] ?? '',
      reportName: json['reportName'] ?? '',
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'baseCurrencyCode': baseCurrencyCode,
      'baseCurrencySymbol': baseCurrencySymbol,
      'generatedBy': generatedBy,
      'propertyName': propertyName,
      'recordsCount': recordsCount,
      'reportGeneratedCurrencySymbol': reportGeneratedCurrencySymbol,
      'reportName': reportName,
    };
  }

  @override
  String toString() {
    return 'ManagerReportInfo(baseCurrencyCode: $baseCurrencyCode, baseCurrencySymbol: $baseCurrencySymbol, generatedBy: $generatedBy, propertyName: $propertyName, recordsCount: $recordsCount, reportGeneratedCurrencySymbol: $reportGeneratedCurrencySymbol, reportName: $reportName)';
  }
}


class CityLedgerData {
  final int id;
  final String category;
  final String description;
  final double today;
  final double ptd;
  final double ytd;

  CityLedgerData({
    required this.id,
    required this.category,
    required this.description,
    required this.today,
    required this.ptd,
    required this.ytd,
  });

  // Factory constructor to create an instance from JSON
  factory CityLedgerData.fromJson(Map<String, dynamic> json) {
    return CityLedgerData(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      today: (json['today'] ?? 0).toDouble(),
      ptd: (json['ptd'] ?? 0).toDouble(),
      ytd: (json['ytd'] ?? 0).toDouble(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'today': today,
      'ptd': ptd,
      'ytd': ytd,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'CityLedgerData(id: $id, category: $category, description: $description, today: $today, ptd: $ptd, ytd: $ytd)';
  }
}

class PaymentRecordData {
  final int id;
  final String category;
  final String code;
  final String description;
  final double today;
  final double ptd;
  final double ytd;

  PaymentRecordData({
    required this.id,
    required this.category,
    required this.code,
    required this.description,
    required this.today,
    required this.ptd,
    required this.ytd,
  });

  // Factory constructor to create an instance from JSON
  factory PaymentRecordData.fromJson(Map<String, dynamic> json) {
    return PaymentRecordData(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      today: (json['today'] ?? 0).toDouble(),
      ptd: (json['ptd'] ?? 0).toDouble(),
      ytd: (json['ytd'] ?? 0).toDouble(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'code': code,
      'description': description,
      'today': today,
      'ptd': ptd,
      'ytd': ytd,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'PaymentRecordData(id: $id, category: $category, code: $code, description: $description, today: $today, ptd: $ptd, ytd: $ytd)';
  }
}


class PosPaymentData {
  final int id;
  final String category;
  final String code;
  final String description;
  final double today;
  final double ptd;
  final double ytd;

  PosPaymentData({
    required this.id,
    required this.category,
    required this.code,
    required this.description,
    required this.today,
    required this.ptd,
    required this.ytd,
  });

  // Factory constructor to create an instance from JSON
  factory PosPaymentData.fromJson(Map<String, dynamic> json) {
    return PosPaymentData(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      today: (json['today'] ?? 0).toDouble(),
      ptd: (json['ptd'] ?? 0).toDouble(),
      ytd: (json['ytd'] ?? 0).toDouble(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'code': code,
      'description': description,
      'today': today,
      'ptd': ptd,
      'ytd': ytd,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'PosPaymentData(id: $id, category: $category, code: $code, description: $description, today: $today, ptd: $ptd, ytd: $ytd)';
  }
}


class RevenueRecordData {
  final int id;
  final String category;
  final String description;
  final double today;
  final double ptd;
  final double ytd;

  RevenueRecordData({
    required this.id,
    required this.category,
    required this.description,
    required this.today,
    required this.ptd,
    required this.ytd,
  });

  // Factory constructor to create an instance from JSON
  factory RevenueRecordData.fromJson(Map<String, dynamic> json) {
    return RevenueRecordData(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      today: (json['today'] ?? 0).toDouble(),
      ptd: (json['ptd'] ?? 0).toDouble(),
      ytd: (json['ytd'] ?? 0).toDouble(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'today': today,
      'ptd': ptd,
      'ytd': ytd,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'RevenueRecordData(id: $id, category: $category, description: $description, today: $today, ptd: $ptd, ytd: $ytd)';
  }
}


class RoomSummaryData {
  final int id;
  final String category;
  final String description;
  final double today;
  final double ptd;
  final double ytd;

  RoomSummaryData({
    required this.id,
    required this.category,
    required this.description,
    required this.today,
    required this.ptd,
    required this.ytd,
  });

  // Factory constructor to create an instance from JSON
  factory RoomSummaryData.fromJson(Map<String, dynamic> json) {
    return RoomSummaryData(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      today: json['today'] ?? 0,
      ptd: json['ptd'] ?? 0,
      ytd: json['ytd'] ?? 0,
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'today': today,
      'ptd': ptd,
      'ytd': ytd,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'RoomSummaryData(id: $id, category: $category, description: $description, today: $today, ptd: $ptd, ytd: $ytd)';
  }
}

