class RoomResponse {
  final int roomId;
  final String name;
  final int? roomTypeId;
  final String? roomTypeName;
  final int? roomCategoryId;
  final String? roomCategoryName;
  final int? roomStatusId;
  final int? indexId;
  final String? shortCode;
  final String? ipAddress;
  final String? deviceId;
  final int? bedTypeId;
  final String? phoneExtension;
  final String? keyCardAlias;
  final bool? isSuite;
  final bool? isSuiteChild;
  final int? parentSuitId;
  final int? houseKeepingStatus;
  final bool? isSmokingRoom;
  final bool? isPayMasterRoom;
  final bool? paymasterRoomForInventoryOn;
  final int? status;
  final String? createdByUserName;
  final String? lastModifiedByUserName;
  final String? statusName;
  final int? hotelId;
  final List<dynamic>? roomImageStores;

  RoomResponse({
    required this.roomId,
    required this.name,
    this.roomTypeId,
    this.roomTypeName,
    this.roomCategoryId,
    this.roomCategoryName,
    this.roomStatusId,
    this.indexId,
    this.shortCode,
    this.ipAddress,
    this.deviceId,
    this.bedTypeId,
    this.phoneExtension,
    this.keyCardAlias,
    this.isSuite,
    this.isSuiteChild,
    this.parentSuitId,
    this.houseKeepingStatus,
    this.isSmokingRoom,
    this.isPayMasterRoom,
    this.paymasterRoomForInventoryOn,
    this.status,
    this.createdByUserName,
    this.lastModifiedByUserName,
    this.statusName,
    this.hotelId,
    this.roomImageStores,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      roomId: json['roomId'] ?? 0,
      name: json['name'] ?? '',
      roomTypeId: json['roomTypeId'],
      roomTypeName: json['roomTypeName'],
      roomCategoryId: json['roomCategoryId'],
      roomCategoryName: json['roomCategoryName'],
      roomStatusId: json['roomStatusId'],
      indexId: json['indexId'],
      shortCode: json['shortCode'],
      ipAddress: json['ipAddress'],
      deviceId: json['deviceId'],
      bedTypeId: json['bedTypeId'],
      phoneExtension: json['phoneExtension'],
      keyCardAlias: json['keyCardAlias'],
      isSuite: json['isSuite'],
      isSuiteChild: json['isSuiteChild'],
      parentSuitId: json['parentSuitId'],
      houseKeepingStatus: json['houseKeepingStatus'],
      isSmokingRoom: json['isSmokingRoom'],
      isPayMasterRoom: json['isPayMasterRoom'],
      paymasterRoomForInventoryOn: json['paymasterRoomForInventoryOn'],
      status: json['status'],
      createdByUserName: json['createdByUserName'],
      lastModifiedByUserName: json['lastModifiedByUserName'],
      statusName: json['statusName'],
      hotelId: json['hotelId'],
      roomImageStores: json['roomImageStores'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'name': name,
      'roomTypeId': roomTypeId,
      'roomTypeName': roomTypeName,
      'roomCategoryId': roomCategoryId,
      'roomCategoryName': roomCategoryName,
      'roomStatusId': roomStatusId,
      'indexId': indexId,
      'shortCode': shortCode,
      'ipAddress': ipAddress,
      'deviceId': deviceId,
      'bedTypeId': bedTypeId,
      'phoneExtension': phoneExtension,
      'keyCardAlias': keyCardAlias,
      'isSuite': isSuite,
      'isSuiteChild': isSuiteChild,
      'parentSuitId': parentSuitId,
      'houseKeepingStatus': houseKeepingStatus,
      'isSmokingRoom': isSmokingRoom,
      'isPayMasterRoom': isPayMasterRoom,
      'paymasterRoomForInventoryOn': paymasterRoomForInventoryOn,
      'status': status,
      'createdByUserName': createdByUserName,
      'lastModifiedByUserName': lastModifiedByUserName,
      'statusName': statusName,
      'hotelId': hotelId,
      'roomImageStores': roomImageStores,
    };
  }

  @override
  String toString() {
    return 'RoomResponse(roomId: $roomId, name: $name, roomTypeName: $roomTypeName, statusName: $statusName)';
  }
}
