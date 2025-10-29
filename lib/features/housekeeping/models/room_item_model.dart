class RoomItem {
  final int? id;
  final int? houseKeeper;
  final int? houseKeepingStatusId;
  final String? houseKeeperName;
  final String section;
  final String roomName;
  final String availability;
  final String housekeepingStatus;
  final String roomType;
  final bool hasIssue;
  final bool? isRoom;
  final String? remark;

  RoomItem({
    this.id,
    this.houseKeeper,
    this.houseKeeperName,
    this.houseKeepingStatusId,
    required this.section,
    required this.roomName,
    required this.availability,
    required this.housekeepingStatus,
    required this.roomType,
    this.hasIssue = false,
    this.remark,
    this.isRoom,
  });
}