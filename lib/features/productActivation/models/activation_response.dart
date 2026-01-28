class ActivationResponse {
  final int configId;
  final int companyId;
  final String companyName;
  final int branchId;
  final String branchName;
  final String configKey;
  final String serviceUrl;
  final String resourceUrl;
  final String restaurantId;
  final String hotelId;
  final String restaurantName;
  final String deviceId;
  final int currencyId;
  final int systemTypeId;
  final int status;

  ActivationResponse({
    required this.configId,
    required this.companyId,
    required this.companyName,
    required this.branchId,
    required this.branchName,
    required this.configKey,
    required this.serviceUrl,
    required this.resourceUrl,
    required this.restaurantId,
    required this.hotelId,
    required this.restaurantName,
    required this.deviceId,
    required this.currencyId,
    required this.systemTypeId,
    required this.status,
  });

  factory ActivationResponse.fromJson(Map<String, dynamic> json) {
    return ActivationResponse(
      configId: json['ConfigId'] ?? 0,
      companyId: json['CompanyId'] ?? 0,
      companyName: json['CompanyName'] ?? '',
      branchId: json['BranchId'] ?? 0,
      branchName: json['BranchName'] ?? '',
      configKey: json['ConfigKey'] ?? '',
      serviceUrl: json['ServiceUrl'] ?? '',
      resourceUrl: json['ResourceUrl'] ?? '',
      restaurantId: json['RestaurantId'] ?? '0',
      hotelId: json['HotelId'] ?? '0',
      restaurantName: json['RestaurantName'] ?? '',
      deviceId: json['DeviceId'] ?? '',
      currencyId: json['CurrencyId'] ?? 0,
      systemTypeId: json['SystemTypeId'] ?? 0,
      status: json['Status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ConfigId': configId,
      'CompanyId': companyId,
      'CompanyName': companyName,
      'BranchId': branchId,
      'BranchName': branchName,
      'ConfigKey': configKey,
      'ServiceUrl': serviceUrl,
      'ResourceUrl': resourceUrl,
      'RestaurantId': restaurantId,
      'HotelId': hotelId,
      'RestaurantName': restaurantName,
      'DeviceId': deviceId,
      'CurrencyId': currencyId,
      'SystemTypeId': systemTypeId,
      'Status': status,
    };
  }
}