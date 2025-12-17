class PickDropInfo {
  DateTime? pickUpDateTime;
  String pickUpDescription;
  int pickUpModeId;
  String pickUpVehicleNo;

  DateTime? dropOffDateTime;
  String dropOffDescription;
  int dropOffModeId;
  String dropOffVehicleNo;

  PickDropInfo({
    this.pickUpDateTime,
    this.pickUpDescription = "",
    this.pickUpModeId = 0,
    this.pickUpVehicleNo = "",
    this.dropOffDateTime,
    this.dropOffDescription = "",
    this.dropOffModeId = 0,
    this.dropOffVehicleNo = "",
  });

  factory PickDropInfo.fromJson(Map<String, dynamic> json) {
    return PickDropInfo(
      pickUpDateTime: json['pickUpDateTime'] != null
          ? DateTime.parse(json['pickUpDateTime'])
          : null,
      pickUpDescription: json['pickUpDescription'] ?? "",
      pickUpModeId: json['pickUpModeId'] ?? 0,
      pickUpVehicleNo: json['pickUpVehiceleNo'] ?? "",
      dropOffDateTime: json['dropOffDateTime'] != null
          ? DateTime.parse(json['dropOffDateTime'])
          : null,
      dropOffDescription: json['dropOffDescription'] ?? "",
      dropOffModeId: json['dropOffModeId'] ?? 0,
      dropOffVehicleNo: json['dropOffVehiceleNo'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickUpDateTime': pickUpDateTime?.toIso8601String(),
      'pickUpDescription': pickUpDescription,
      'pickUpModeId': pickUpModeId,
      'pickUpVehiceleNo': pickUpVehicleNo,
      'dropOffDateTime': dropOffDateTime?.toIso8601String(),
      'dropOffDescription': dropOffDescription,
      'dropOffModeId': dropOffModeId,
      'dropOffVehiceleNo': dropOffVehicleNo,
    };
  }
}
