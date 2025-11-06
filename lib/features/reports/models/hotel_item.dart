class HotelItem {
  final int hotelId;
  final String hotelName;

  HotelItem({
    required this.hotelId,
    required this.hotelName,
  });

  factory HotelItem.fromJson(Map<String, dynamic> json) {
    return HotelItem(
      hotelId: json['hotelId'] ?? 0,
      hotelName: json['hotelName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotelId': hotelId,
      'hotelName': hotelName,
    };
  }

  @override
  String toString() {
    return 'HotelItem(hotelId: $hotelId, hotelName: $hotelName)';
  }
}
