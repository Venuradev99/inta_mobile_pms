// Enums and Data Models
enum HousekeepingStatus {
  clean,
  dirty,
  inspected,
  outOfOrder,
}

enum RoomType {
  standard,
  luxury,
  villa,
  cabana,
  beachHouse,
  garden,
  common,
}

class RoomItem {
  final String section;
  final String roomName;
  final String availability;
  final String housekeepingStatus;
  final String roomType;
  final bool hasIssue;
  final String? remark;

  RoomItem({
    required this.section,
    required this.roomName,
    required this.availability,
    required this.housekeepingStatus,
    required this.roomType,
    this.hasIssue = false,
    this.remark,
  });
}