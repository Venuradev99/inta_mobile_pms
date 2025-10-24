class MaintenanceBlockPayload {
  final String from;
  final String to;
  final bool isBlock;
  final int pageSize;
  final int roomId;
  final int roomTypeId;
  final int startIndex;

  MaintenanceBlockPayload({
    required this.from,
    required this.to,
    required this.isBlock,
    required this.pageSize,
    required this.roomId,
    required this.roomTypeId,
    required this.startIndex,
  });

  factory MaintenanceBlockPayload.fromJson(Map<String, dynamic> json) {
    return MaintenanceBlockPayload(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      isBlock: json['isBlock'] ?? false,
      pageSize: json['pageSize'] ?? 0,
      roomId: json['roomId'] ?? 0,
      roomTypeId: json['roomTypeId'] ?? 0,
      startIndex: json['startIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'isBlock': isBlock,
      'pageSize': pageSize,
      'roomId': roomId,
      'roomTypeId': roomTypeId,
      'startIndex': startIndex,
    };
  }

  @override
  String toString() {
    return 'MaintenanceBlockPayload(from: $from, to: $to, isBlock: $isBlock, pageSize: $pageSize, roomId: $roomId, roomTypeId: $roomTypeId, startIndex: $startIndex)';
  }
}
