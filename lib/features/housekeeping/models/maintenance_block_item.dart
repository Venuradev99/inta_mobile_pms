
class MaintenanceBlockItem {
  // final String id;
  // final String title;
  // final String description;
  // final String status;
  // final String priority;
  // final DateTime createdDate;
  // final DateTime? scheduledDate;
  // final String assignedTo;
  // final String category;
  // final double? estimatedCost;
  // final List<String> tags;
  final int maintenanceBlockId;
  final int roomId;
  final int roomTypeId;
  final String roomName;
  final String roomTypeName;
  final String fromDate;
  final String toDate;
  final int reasonId;
  final String reasonName;
  final String blockedBy;
  final String blockedOn;
  final int status;
  final int hotelId;

  MaintenanceBlockItem({
    // required this.id,
    // required this.title,
    // required this.description,
    // required this.status,
    // required this.priority,
    // required this.createdDate,
    // this.scheduledDate,
    // required this.assignedTo,
    // required this.category,
    // this.estimatedCost,
    // this.tags = const [],
      required this.maintenanceBlockId,
    required this.roomId,
    required this.roomTypeId,
    required this.roomName,
    required this.roomTypeName,
    required this.fromDate,
    required this.toDate,
    required this.reasonId,
    required this.reasonName,
    required this.blockedBy,
    required this.blockedOn,
    required this.status,
    required this.hotelId,
  });

   @override
  String toString() {
    return 'MaintenanceBlockItem('
        'maintenanceBlockId: $maintenanceBlockId, '
        'roomId: $roomId, '
        'roomTypeId: $roomTypeId, '
        'roomName: $roomName, '
        'roomTypeName: $roomTypeName, '
        'fromDate: $fromDate, '
        'toDate: $toDate, '
        'reasonId: $reasonId, '
        'reasonName: $reasonName, '
        'blockedBy: $blockedBy, '
        'blockedOn: $blockedOn, '
        'status: $status, '
        'hotelId: $hotelId'
        ')';
  }
}