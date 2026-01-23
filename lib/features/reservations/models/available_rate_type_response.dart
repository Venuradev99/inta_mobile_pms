class AvailableRateTypeResponse {
  final int rateTypeId;
  final String name;
  final String description;
  final int days;
  final bool isWeekDays;
  final bool isWeekEnd;
  final bool isWeb;
  final String name1;
  final String name2;
  final bool isHourly;
  final int hour;
  final DateTime inActiveDatetime;
  final int indexId;
  final String shortCode;
  final String ipAddress;
  final String deviceId;
  final int createdBy;
  final int lastModifiedBy;
  final int status;
  final String? createdByUserName;
  final String? lastModifiedByUserName;
  final bool isBreakfastAvailable;
  final bool isLunchAvailable;
  final bool isDinnerAvailable;
  final int defaultStartingMealType;
  final bool allowChangeAtBooking;
  final String? statusName;
  final bool isSystemDefined;
  final int hotelId;

  AvailableRateTypeResponse({
    required this.rateTypeId,
    required this.name,
    required this.description,
    required this.days,
    required this.isWeekDays,
    required this.isWeekEnd,
    required this.isWeb,
    required this.name1,
    required this.name2,
    required this.isHourly,
    required this.hour,
    required this.inActiveDatetime,
    required this.indexId,
    required this.shortCode,
    required this.ipAddress,
    required this.deviceId,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.status,
    this.createdByUserName,
    this.lastModifiedByUserName,
    required this.isBreakfastAvailable,
    required this.isLunchAvailable,
    required this.isDinnerAvailable,
    required this.defaultStartingMealType,
    required this.allowChangeAtBooking,
    this.statusName,
    required this.isSystemDefined,
    required this.hotelId,
  });

  factory AvailableRateTypeResponse.fromJson(Map<String, dynamic> json) {
    return AvailableRateTypeResponse(
      rateTypeId: json['rateTypeId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      days: json['days'] ?? 0,
      isWeekDays: json['isWeekDays'] ?? false,
      isWeekEnd: json['isWeekEnd'] ?? false,
      isWeb: json['isWeb'] ?? false,
      name1: json['name1'] ?? '',
      name2: json['name2'] ?? '',
      isHourly: json['isHourly'] ?? false,
      hour: json['hour'] ?? 0,
      inActiveDatetime: DateTime.parse(
        json['inActiveDatetime'] ?? '1990-01-01T00:00:00',
      ),
      indexId: json['indexId'] ?? 0,
      shortCode: json['shortCode'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      deviceId: json['deviceId'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
      createdByUserName: json['createdByUserName'],
      lastModifiedByUserName: json['lastModifiedByUserName'],
      isBreakfastAvailable: json['isBreakfastAvailable'] ?? false,
      isLunchAvailable: json['isLunchAvailable'] ?? false,
      isDinnerAvailable: json['isDinnerAvailable'] ?? false,
      defaultStartingMealType: json['defaultStartingMealType'] ?? 0,
      allowChangeAtBooking: json['allowChangeAtBooking'] ?? false,
      statusName: json['statusName'],
      isSystemDefined: json['isSystemDefined'] ?? false,
      hotelId: json['hotelId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rateTypeId': rateTypeId,
      'name': name,
      'description': description,
      'days': days,
      'isWeekDays': isWeekDays,
      'isWeekEnd': isWeekEnd,
      'isWeb': isWeb,
      'name1': name1,
      'name2': name2,
      'isHourly': isHourly,
      'hour': hour,
      'inActiveDatetime': inActiveDatetime.toIso8601String(),
      'indexId': indexId,
      'shortCode': shortCode,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'isBreakfastAvailable': isBreakfastAvailable,
      'isLunchAvailable': isLunchAvailable,
      'isDinnerAvailable': isDinnerAvailable,
      'defaultStartingMealType': defaultStartingMealType,
      'allowChangeAtBooking': allowChangeAtBooking,
      'statusName': statusName,
      'isSystemDefined': isSystemDefined,
      'hotelId': hotelId,
    };
  }
}
