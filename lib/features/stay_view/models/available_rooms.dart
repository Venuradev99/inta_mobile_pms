class AvailableRooms {
  final int roomId;
  final int roomStatusId;
  final String name;

  AvailableRooms({
    required this.roomId,
    required this.roomStatusId,
    required this.name,
  });

  factory AvailableRooms.fromJson(Map<String, dynamic> json) {
    return AvailableRooms(
      roomId: json['roomId'] as int,
      roomStatusId: json['roomStatusId'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomStatusId': roomStatusId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'AvailableRooms(roomId: $roomId, roomStatusId: $roomStatusId, name: $name)';
  }
}
