class WorkOrder {
  final int? workOrderId;
  final String orderNo;
  final String category;
  final String unitRoom;
  final String roomName;
  final DateTime blockFrom;
  final DateTime blockTo;
  final String priority;
  final String assignedTo;
  final String status;
  final DateTime dueDate;
  final DateTime? enteredOn;
  final DateTime? updatedOn;
  final String description;
  final String? postNote;
  final String reason;
  final bool? isRoom;
  final int? roomId;
  final int? unitId;
  final int? priorityId;
  final int? assingToId;
  final int? statusId;

  WorkOrder({
    this.workOrderId,
    required this.orderNo,
    required this.category,
    required this.unitRoom,
    required this.roomName,
    required this.blockFrom,
    required this.blockTo,
    this.enteredOn,
    this.updatedOn,
    required this.priority,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.description,
    this.postNote,
    required this.reason,
    this.isRoom,
    this.unitId,
    this.roomId,
    this.assingToId,
    this.priorityId,
    this.statusId,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      workOrderId: json['workOrderId'] ?? 0,
      orderNo: json['orderNo'] ?? '',
      category: json['category'] ?? '',
      unitRoom: json['unitRoom'] ?? '',
      roomName: json['roomName'] ?? '',
      blockFrom: DateTime.tryParse(json['blockFrom'] ?? '') ?? DateTime.now(),
      blockTo: DateTime.tryParse(json['blockTo'] ?? '') ?? DateTime.now(),
      enteredOn: DateTime.tryParse(json['enteredOn'] ?? '') ?? DateTime.now(),
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? '') ?? DateTime.now(),
      priority: json['priority'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      status: json['status'] ?? '',
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      description: json['description'] ?? '',
      postNote: json['postNote'] ?? '',
      reason: json['reason'] ?? '',
      isRoom: json['isRoom'] ?? true,
      unitId: json['unitId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      assingToId: json['assingToId'] ?? 0,
      priorityId: json['priorityId'] ?? 0,
      statusId: json['statusId'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'orderNo': orderNo,
      'category': category,
      'unitRoom': unitRoom,
      'roomName': roomName,
      'blockFrom': blockFrom.toIso8601String(),
      'blockTo': blockTo.toIso8601String(),
      'enteredOn': enteredOn?.toIso8601String(),
      'updatedOn': updatedOn?.toIso8601String(),
      'priority': priority,
      'assignedTo': assignedTo,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'description': description,
      'postNote': postNote,
      'reason': reason,
      'isRoom': isRoom,
      'unitId': unitId,
      'roomId': roomId,
      'assingToId': assingToId,
      'priorityId': priorityId,
      'statusId': statusId,
    };
  }
}
