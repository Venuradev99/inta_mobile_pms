class WorkOrdersSearchRequest {
  final int assignerId;
  final int categoryId;
  final bool isCompleted;
  final int priorityId;
  final int roomId;
  final int status;
  final int unitId;
  final String workOrderNumber;
  final int pageSize;
  final int pageIndex;
  final int startIndex;

  WorkOrdersSearchRequest({
    required this.assignerId,
    required this.categoryId,
    required this.isCompleted,
    required this.priorityId,
    required this.roomId,
    required this.status,
    required this.unitId,
    required this.workOrderNumber,
    required this.pageSize,
    required this.pageIndex,
    required this.startIndex,
  });

  factory WorkOrdersSearchRequest.fromJson(Map<String, dynamic> json) {
    return WorkOrdersSearchRequest(
      assignerId: json['AssignerId'] ?? 0,
      categoryId: json['CategoryId'] ?? 0,
      isCompleted: json['IsCompleted'] ?? false,
      priorityId: json['PriorityId'] ?? 0,
      roomId: json['RoomId'] ?? 0,
      status: json['Status'] ?? 0,
      unitId: json['UnitId'] ?? 0,
      workOrderNumber: json['WorkOrderNumber'] ?? '',
      pageSize: json['pageSize'] ?? 50,
      pageIndex: json['pageindex'] ?? 0,
      startIndex: json['startIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AssignerId': assignerId,
      'CategoryId': categoryId,
      'IsCompleted': isCompleted,
      'PriorityId': priorityId,
      'RoomId': roomId,
      'Status': status,
      'UnitId': unitId,
      'WorkOrderNumber': workOrderNumber,
      'pageSize': pageSize,
      'pageindex': pageIndex,
      'startIndex': startIndex,
    };
  }
}
