class PostNotePayload {
  final int workOrderId;
  final int unitId;
  final int roomId;
  final bool isRoom;
  final int assingTo;
  final int status;
  final int priority;
  final String description;
  final String note;

  PostNotePayload({
    required this.workOrderId,
    required this.unitId,
    required this.roomId,
    required this.isRoom,
    required this.assingTo,
    required this.status,
    required this.priority,
    required this.description,
    required this.note,
  });

  factory PostNotePayload.fromJson(Map<String, dynamic> json) {
    return PostNotePayload(
      workOrderId: json['workOrderId'] ?? 0,
      unitId: json['unitId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      isRoom: json['isRoom'] ?? false,
      assingTo: json['assingTo'] ?? 0,
      status: json['status'] ?? 0,
      priority: json['priority'] ?? 0,
      description: json['description'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'unitId': unitId,
      'roomId': roomId,
      'isRoom': isRoom,
      'assingTo': assingTo,
      'status': status,
      'priority': priority,
      'description': description,
      'note': note,
    };
  }

  @override
  String toString() {
    return 'PostNotePayload(workOrderId: $workOrderId, unitId: $unitId, roomId: $roomId, isRoom: $isRoom, assingTo: $assingTo, status: $status, priority: $priority, description: $description, note: $note)';
  }
}
