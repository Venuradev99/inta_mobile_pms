class FolioResponse {
  final int folioId;
  final String folioNo;
  final int folioOwnerId;
  final String name;
  final int ownerType;
  final bool isMaster;
  final bool generateInvNoOnCheckOut;
  final bool showTariffPrintFolio;

  final double grossAmount;
  final double taxAmount;
  final double serviceCharge;
  final double discount;
  final double roundOffAmount;
  final double totalAmount;
  final double paidAmount;

  final int? parentFolioId;

  FolioResponse({
    required this.folioId,
    required this.folioNo,
    required this.folioOwnerId,
    required this.name,
    required this.ownerType,
    required this.isMaster,
    required this.generateInvNoOnCheckOut,
    required this.showTariffPrintFolio,
    required this.grossAmount,
    required this.taxAmount,
    required this.serviceCharge,
    required this.discount,
    required this.roundOffAmount,
    required this.totalAmount,
    required this.paidAmount,
    this.parentFolioId,
  });

  factory FolioResponse.fromJson(Map<String, dynamic> json) {
    return FolioResponse(
      folioId: json['folioId'] ?? 0,
      folioNo: json['folioNo'] ?? '',
      folioOwnerId: json['folioOwnerId'] ?? 0,
      name: json['name'] ?? '',
      ownerType: json['ownerType'] ?? 0,
      isMaster: json['isMaster'] ?? false,
      generateInvNoOnCheckOut: json['generateInvNoOnCheckOut'] ?? false,
      showTariffPrintFolio: json['showTariffPrintFolio'] ?? false,
      grossAmount: (json['grossAmount'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      serviceCharge: (json['serviceCharge'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      roundOffAmount: (json['roundOffAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      parentFolioId: json['parentFolioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folioId': folioId,
      'folioNo': folioNo,
      'folioOwnerId': folioOwnerId,
      'name': name,
      'ownerType': ownerType,
      'isMaster': isMaster,
      'generateInvNoOnCheckOut': generateInvNoOnCheckOut,
      'showTariffPrintFolio': showTariffPrintFolio,
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'serviceCharge': serviceCharge,
      'discount': discount,
      'roundOffAmount': roundOffAmount,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'parentFolioId': parentFolioId,
    };
  }
}
