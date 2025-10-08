class HotelInventoryData {
  final String name;
  final double value;

  HotelInventoryData({
    required this.name,
    required this.value,
  });

  factory HotelInventoryData.fromJson(Map<String, dynamic> json) {
    return HotelInventoryData(
      name: json['name'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}
