class TransportationMode {
  final int transportationModeId;
  final String name;
  final String description;
  final String alias;
  final int hotelId;
  final int createdBy;
  final String createdByUserName;
  final int lastModifiedBy;
  final String lastModifiedByUserName;
  final int status;
  final String statusName;

  TransportationMode({
    required this.transportationModeId,
    required this.name,
    required this.description,
    required this.alias,
    required this.hotelId,
    required this.createdBy,
    required this.createdByUserName,
    required this.lastModifiedBy,
    required this.lastModifiedByUserName,
    required this.status,
    required this.statusName,
  });

  factory TransportationMode.fromJson(Map<String, dynamic> json) {
    return TransportationMode(
      transportationModeId: json['transportationModeId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      alias: json['alias'] ?? '',
      hotelId: json['hotelId'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      createdByUserName: json['createdByUserName'] ?? '',
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      lastModifiedByUserName: json['lastModifiedByUserName'] ?? '',
      status: json['status'] ?? 0,
      statusName: json['statusName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transportationModeId': transportationModeId,
      'name': name,
      'description': description,
      'alias': alias,
      'hotelId': hotelId,
      'createdBy': createdBy,
      'createdByUserName': createdByUserName,
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedByUserName': lastModifiedByUserName,
      'status': status,
      'statusName': statusName,
    };
  }
}
