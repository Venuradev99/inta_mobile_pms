class RoomTypeResponse {
  final int roomTypeId;
  final int roomCategoryId;
  final int parentTypeId;
  final int noOfChildUnits;
  final String name;
  final String description;
  final int baseAdult;
  final int baseChild;
  final int maxAdult;
  final int maxChild;
  final double overBookingRate;
  final double defaultWebInventory;
  final bool shouldPublishToWebSite;
  final String colorCode;
  final bool serviceChargeOn;
  final int indexId;
  final bool isTax1;
  final bool isTax2;
  final bool isTax3;
  final bool isTax4;
  final bool isTax5;
  final bool isTax6;
  final String createdByUserName;
  final String lastModifiedByUserName;
  final int lastModifiedBy;
  final int status;
  final String statusName;
  final String shortCode;
  final int hotelId;
  final List<dynamic> roomTypeTaxes;
  final List<dynamic> roomTypeAmenity;
  final List<dynamic> roomTypeAmenityData;
  final List<dynamic> roomTypeTaxData;

  RoomTypeResponse({
    required this.roomTypeId,
    required this.roomCategoryId,
    required this.parentTypeId,
    required this.noOfChildUnits,
    required this.name,
    required this.description,
    required this.baseAdult,
    required this.baseChild,
    required this.maxAdult,
    required this.maxChild,
    required this.overBookingRate,
    required this.defaultWebInventory,
    required this.shouldPublishToWebSite,
    required this.colorCode,
    required this.serviceChargeOn,
    required this.indexId,
    required this.isTax1,
    required this.isTax2,
    required this.isTax3,
    required this.isTax4,
    required this.isTax5,
    required this.isTax6,
    required this.createdByUserName,
    required this.lastModifiedByUserName,
    required this.lastModifiedBy,
    required this.status,
    required this.statusName,
    required this.shortCode,
    required this.hotelId,
    required this.roomTypeTaxes,
    required this.roomTypeAmenity,
    required this.roomTypeAmenityData,
    required this.roomTypeTaxData,
  });

  factory RoomTypeResponse.fromJson(Map<String, dynamic> json) {
    return RoomTypeResponse(
      roomTypeId: json['roomTypeId'] ?? 0,
      roomCategoryId: json['roomCategoryId'] ?? 0,
      parentTypeId: json['parentTypeId'] ?? 0,
      noOfChildUnits: json['noOfChildUnits'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      baseAdult: json['baseAdult'] ?? 0,
      baseChild: json['baseChild'] ?? 0,
      maxAdult: json['maxAdult'] ?? 0,
      maxChild: json['maxChild'] ?? 0,
      overBookingRate: (json['overBookingRate'] as num?)?.toDouble() ?? 0.0,
      defaultWebInventory:
          (json['defaultWebInventory'] as num?)?.toDouble() ?? 0.0,
      shouldPublishToWebSite: json['shouldPublishToWebSite'] ?? false,
      colorCode: json['colorCode'] ?? '',
      serviceChargeOn: json['serviceChargeOn'] ?? false,
      indexId: json['indexId'] ?? 0,
      isTax1: json['isTax1'] ?? false,
      isTax2: json['isTax2'] ?? false,
      isTax3: json['isTax3'] ?? false,
      isTax4: json['isTax4'] ?? false,
      isTax5: json['isTax5'] ?? false,
      isTax6: json['isTax6'] ?? false,
      createdByUserName: json['createdByUserName'] ?? '',
      lastModifiedByUserName: json['lastModifiedByUserName'] ?? '',
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      status: json['status'] ?? 0,
      statusName: json['statusName'] ?? '',
      shortCode: json['shortCode'] ?? '',
      hotelId: json['hotelId'] ?? 0,
      roomTypeTaxes: json['roomTypeTaxes'] ?? [],
      roomTypeAmenity: json['roomTypeAmenity'] ?? [],
      roomTypeAmenityData: json['roomTypeAmenityData'] ?? [],
      roomTypeTaxData: json['roomTypeTaxData'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomTypeId': roomTypeId,
      'roomCategoryId': roomCategoryId,
      'parentTypeId': parentTypeId,
      'noOfChildUnits': noOfChildUnits,
      'name': name,
      'description': description,
      'baseAdult': baseAdult,
      'baseChild': baseChild,
      'maxAdult': maxAdult,
      'maxChild': maxChild,
      'overBookingRate': overBookingRate,
      'defaultWebInventory': defaultWebInventory,
      'shouldPublishToWebSite': shouldPublishToWebSite,
      'colorCode': colorCode,
      'serviceChargeOn': serviceChargeOn,
      'indexId': indexId,
      'isTax1': isTax1,
      'isTax2': isTax2,
      'isTax3': isTax3,
      'isTax4': isTax4,
      'isTax5': isTax5,
      'isTax6': isTax6,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'lastModifiedBy': lastModifiedBy,
      'status': status,
      'statusName': statusName,
      'shortCode': shortCode,
      'hotelId': hotelId,
      'roomTypeTaxes': roomTypeTaxes,
      'roomTypeAmenity': roomTypeAmenity,
      'roomTypeAmenityData': roomTypeAmenityData,
      'roomTypeTaxData': roomTypeTaxData,
    };
  }
}
