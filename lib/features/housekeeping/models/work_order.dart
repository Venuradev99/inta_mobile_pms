class WorkOrder {
  final String orderNo;
  final String category;
  final String unitRoom;
  final DateTime blockFrom;
  final DateTime blockTo;
  final String priority;
  final String assignedTo;
  final String status;
  final DateTime dueDate;
  final String description;
  final String reason;

  WorkOrder({
    required this.orderNo,
    required this.category,
    required this.unitRoom,
    required this.blockFrom,
    required this.blockTo,
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
      blockFrom: DateTime.tryParse(json['blockFrom'] ?? '') ?? DateTime.now(),
      blockTo: DateTime.tryParse(json['blockTo'] ?? '') ?? DateTime.now(),
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
      'blockFrom': blockFrom.toIso8601String(),
      'blockTo': blockTo.toIso8601String(),
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
