class BookingStaticData {
  final int type;
  final String name;
  final int param1;
  final String param1Name;
  final int param2;
  final String param2Name;
  final int param3;
  final String param3Name;
  final int total;

  BookingStaticData({
    required this.type,
    required this.name,
    required this.param1,
    required this.param1Name,
    required this.param2,
    required this.param2Name,
    required this.param3,
    required this.param3Name,
    required this.total,
  });

  factory BookingStaticData.fromJson(Map<String, dynamic> json) {
    return BookingStaticData(
      type: json['type'] ?? 0,
      name: json['name'] ?? '',
      param1: json['param1'] ?? 0,
      param1Name: json['param1Name'] ?? '',
      param2: json['param2'] ?? 0,
      param2Name: json['param2Name'] ?? '',
      param3: json['param3'] ?? 0,
      param3Name: json['param3Name'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}
