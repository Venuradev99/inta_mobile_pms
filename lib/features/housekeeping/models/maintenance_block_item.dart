
class MaintenanceBlockItem {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime createdDate;
  final DateTime? scheduledDate;
  final String assignedTo;
  final String category;
  final double? estimatedCost;
  final List<String> tags;

  MaintenanceBlockItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdDate,
    this.scheduledDate,
    required this.assignedTo,
    required this.category,
    this.estimatedCost,
    this.tags = const [],
  });
}