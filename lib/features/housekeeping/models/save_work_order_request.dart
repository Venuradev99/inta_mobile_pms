class SaveWorkOrderRequest {
  int assigningTo;
  String blockFrom;
  String blockTo;
  int categoryId;
  String deadLineDate;
  String deadLineTime;
  String description;
  String from;
  bool isRoom;
  int itemId;
  int priority;
  int reasonId;
  int roomId;
  int status;
  String to;
  int unitId;
  int workOrderId;
  String workOrderIdNew;

  SaveWorkOrderRequest({
    required this.assigningTo,
    required this.blockFrom,
    required this.blockTo,
    required this.categoryId,
    required this.deadLineDate,
    required this.deadLineTime,
    required this.description,
    required this.from,
    required this.isRoom,
    required this.itemId,
    required this.priority,
    required this.reasonId,
    required this.roomId,
    required this.status,
    required this.to,
    required this.unitId,
    required this.workOrderId,
    required this.workOrderIdNew,
  });

  factory SaveWorkOrderRequest.fromJson(Map<String, dynamic> json) {
    return SaveWorkOrderRequest(
      assigningTo: json['assingTo'] ?? 0,
      blockFrom: json['blockFrom'] ?? '',
      blockTo: json['blockTo'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      deadLineDate: json['deadLineDate'] ?? '',
      deadLineTime: json['deadLineTime'] ?? '',
      description: json['description'] ?? '',
      from: json['from'] ?? '',
      isRoom: json['isRoom'] ?? false,
      itemId: json['itemId'] ?? 0,
      priority: json['priority'] ?? 0,
      reasonId: json['reasonId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      status: json['status'] ?? 0,
      to: json['to'] ?? '',
      unitId: json['unitId'] ?? 0,
      workOrderId: json['workOrderId'] ?? 0,
      workOrderIdNew: json['workOrderIdNew'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assingTo': assigningTo,
      'blockFrom': blockFrom,
      'blockTo': blockTo,
      'categoryId': categoryId,
      'deadLineDate': deadLineDate,
      'deadLineTime': deadLineTime,
      'description': description,
      'from': from,
      'isRoom': isRoom,
      'itemId': itemId,
      'priority': priority,
      'reasonId': reasonId,
      'roomId': roomId,
      'status': status,
      'to': to,
      'unitId': unitId,
      'workOrderId': workOrderId,
      'workOrderIdNew': workOrderIdNew,
    };
  }
  @override
String toString() {
  return 'SaveWorkOrderRequest('
      'assigningTo: $assigningTo, '
      'blockFrom: $blockFrom, '
      'blockTo: $blockTo, '
      'categoryId: $categoryId, '
      'deadLineDate: $deadLineDate, '
      'deadLineTime: $deadLineTime, '
      'description: $description, '
      'from: $from, '
      'isRoom: $isRoom, '
      'itemId: $itemId, '
      'priority: $priority, '
      'reasonId: $reasonId, '
      'roomId: $roomId, '
      'status: $status, '
      'to: $to, '
      'unitId: $unitId, '
      'workOrderId: $workOrderId, '
      'workOrderIdNew: $workOrderIdNew'
      ')';
}

}
