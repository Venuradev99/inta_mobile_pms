// Work Order Model
class WorkOrder {
  final String orderNo;
  final String category;
  final String unitRoom;
  final String blockFrom;
  final String blockTo;
  final String priority;
  final String assignedTo;
  final String status;
  final DateTime dueDate;
  final String description;

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
  });
}