class AppSettings {
  String serviceUrl;
  String resourceUrl;
  String restaurantId;
  String restaurantName;
  String hotelId;
  String deviceId;
  String systemType;
  String currencyType;

  AppSettings({
    required this.serviceUrl,
    required this.resourceUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.hotelId,
    required this.deviceId,
    required this.systemType,
    required this.currencyType,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      serviceUrl: json['serviceUrl'] ?? '',
      resourceUrl: json['resourceUrl'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      hotelId: json['hotelId'] ?? '',
      deviceId: json['deviceId'] ?? '',
      systemType: json['systemType'] ?? '',
      currencyType: json['currencyType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceUrl': serviceUrl,
      'resourceUrl': resourceUrl,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'hotelId': hotelId,
      'deviceId': deviceId,
      'systemType': systemType,
      'currencyType': currencyType,
    };
  }
}