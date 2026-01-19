class WorkOrder {
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
  final String reason;

  WorkOrder({
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
    required this.reason,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
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
      reason: json['reason'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
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
      'reason': reason,
    };
  }

  @override
  String toString() {
    return 'WorkOrder(orderNo: $orderNo, category: $category, unitRoom: $unitRoom,'
        'blockFrom: $blockFrom, blockTo: $blockTo, priority: $priority, '
        'assignedTo: $assignedTo, status: $status, dueDate: $dueDate,'
        'description: $description) ,reason: $reason)';
  }
}
