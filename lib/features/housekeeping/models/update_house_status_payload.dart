class UpdateHouseStatusPayload {
  final int id;
  final int houseKeeper;
  final String houseKeepingRemark;
  final int houseKeepingStatus;
  final bool isRoom;
  final int operationType;

  UpdateHouseStatusPayload({
    required this.id,
    required this.houseKeeper,
    required this.houseKeepingRemark,
    required this.houseKeepingStatus,
    required this.isRoom,
    required this.operationType,
  });

  factory UpdateHouseStatusPayload.fromJson(Map<String, dynamic> json) {
    return UpdateHouseStatusPayload(
      id: json['Id'] ?? 0,
      houseKeeper: json['HouseKeeper'] ?? 0,
      houseKeepingRemark: json['HouseKeepingRemark'] ?? '',
      houseKeepingStatus: json['HouseKeepingStatus'] ?? 0,
      isRoom: json['IsRoom'] ?? false,
      operationType: json['OperationType'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'HouseKeeper': houseKeeper,
      'HouseKeepingRemark': houseKeepingRemark,
      'HouseKeepingStatus': houseKeepingStatus,
      'IsRoom': isRoom,
      'OperationType': operationType,
    };
  }

  @override
  String toString() {
    return 'UpdateHouseStatusPayload(id: $id, houseKeeper: $houseKeeper, houseKeepingRemark: "$houseKeepingRemark", houseKeepingStatus: $houseKeepingStatus, isRoom: $isRoom, operationType: $operationType)';
  }
}
