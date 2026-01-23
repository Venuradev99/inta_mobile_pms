class BusinessSourcesResponse {
  final int businessSourceId;
  final String name;
  final String description;
  final int businessCategoryId;
  final int? rateSourceId;
  final int currencyId;
  final int? indexId;
  final String shortCode;
  final String phone;
  final String fax;
  final String email;
  final String webSite;
  final String iataNumber;
  final int? planId;
  final double? planValue;
  final bool? isRatedFine;
  final String userName;
  final String password;
  final int? term;
  final String customNumber;
  final int? discountPlanId;
  final double? discountPlanValue;
  final String registrationNo;
  final String colorCode;
  final String address;
  final int currency;
  final double withHoldingTaxPercentage;
  final int? posRateNo;
  final int commisionPlanId;
  final double commissionPlanValue;
  final int marketingSourceId;
  final String ipAddress;
  final String deviceId;
  final int sourceType;
  final int cityLedgerAccountId;
  final int hotelId;
  final DateTime sysDateCreated;
  final DateTime sysDateLastModified;
  final int sysVersion;
  final String rowVersion;
  final int createdBy;
  final int lastModifiedBy;
  final int status;

  BusinessSourcesResponse({
    required this.businessSourceId,
    required this.name,
    required this.description,
    required this.businessCategoryId,
    this.rateSourceId,
    required this.currencyId,
    this.indexId,
    required this.shortCode,
    required this.phone,
    required this.fax,
    required this.email,
    required this.webSite,
    required this.iataNumber,
    this.planId,
    this.planValue,
    this.isRatedFine,
    required this.userName,
    required this.password,
    this.term,
    required this.customNumber,
    this.discountPlanId,
    this.discountPlanValue,
    required this.registrationNo,
    required this.colorCode,
    required this.address,
    required this.currency,
    required this.withHoldingTaxPercentage,
    this.posRateNo,
    required this.commisionPlanId,
    required this.commissionPlanValue,
    required this.marketingSourceId,
    required this.ipAddress,
    required this.deviceId,
    required this.sourceType,
    required this.cityLedgerAccountId,
    required this.hotelId,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.rowVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
  });

  factory BusinessSourcesResponse.fromJson(Map<String, dynamic> json) {
    return BusinessSourcesResponse(
      businessSourceId: json['businessSourceId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      businessCategoryId: json['businessCategoryId'] ?? 0,
      rateSourceId: json['rateSourceId'],
      currencyId: json['currencyId'] ?? 0,
      indexId: json['indexId'],
      shortCode: json['shortCode'] ?? '',
      phone: json['phone'] ?? '',
      fax: json['fax'] ?? '',
      email: json['email'] ?? '',
      webSite: json['webSite'] ?? '',
      iataNumber: json['iataNumber'] ?? '',
      planId: json['planId'],
      planValue: (json['planValue'] as num?)?.toDouble(),
      isRatedFine: json['isRatedFine'],
      userName: json['userName'] ?? '',
      password: json['password'] ?? '',
      term: json['term'],
      customNumber: json['customNumber'] ?? '',
      discountPlanId: json['discountPlanId'],
      discountPlanValue:
          (json['discountPlanValue'] as num?)?.toDouble(),
      registrationNo: json['registrationNo'] ?? '',
      colorCode: json['colorCode'] ?? '',
      address: json['address'] ?? '',
      currency: json['currency'] ?? 0,
      withHoldingTaxPercentage:
          (json['withHoldingTaxPercentage'] as num?)?.toDouble() ?? 0.0,
      posRateNo: json['posRateNo'],
      commisionPlanId: json['commisionPlanId'] ?? 0,
      commissionPlanValue:
          (json['commissionPlanValue'] as num?)?.toDouble() ?? 0.0,
      marketingSourceId: json['marketingSourceId'] ?? 0,
      ipAddress: json['ipAddress'] ?? '',
      deviceId: json['deviceId'] ?? '',
      sourceType: json['sourceType'] ?? 0,
      cityLedgerAccountId: json['cityLedgerAccountId'] ?? 0,
      hotelId: json['hotelId'] ?? 0,
      sysDateCreated:
          DateTime.tryParse(json['sys_DateCreated'] ?? '') ?? DateTime.now(),
      sysDateLastModified:
          DateTime.tryParse(json['sys_DateLastModified'] ?? '') ??
              DateTime.now(),
      sysVersion: json['sys_Version'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessSourceId': businessSourceId,
      'name': name,
      'description': description,
      'businessCategoryId': businessCategoryId,
      'rateSourceId': rateSourceId,
      'currencyId': currencyId,
      'indexId': indexId,
      'shortCode': shortCode,
      'phone': phone,
      'fax': fax,
      'email': email,
      'webSite': webSite,
      'iataNumber': iataNumber,
      'planId': planId,
      'planValue': planValue,
      'isRatedFine': isRatedFine,
      'userName': userName,
      'password': password,
      'term': term,
      'customNumber': customNumber,
      'discountPlanId': discountPlanId,
      'discountPlanValue': discountPlanValue,
      'registrationNo': registrationNo,
      'colorCode': colorCode,
      'address': address,
      'currency': currency,
      'withHoldingTaxPercentage': withHoldingTaxPercentage,
      'posRateNo': posRateNo,
      'commisionPlanId': commisionPlanId,
      'commissionPlanValue': commissionPlanValue,
      'marketingSourceId': marketingSourceId,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'sourceType': sourceType,
      'cityLedgerAccountId': cityLedgerAccountId,
      'hotelId': hotelId,
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
