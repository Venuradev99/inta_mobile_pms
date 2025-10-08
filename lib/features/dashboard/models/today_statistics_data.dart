class TodaystatisticsData {
  final String name;
  final double value;

  TodaystatisticsData({
    required this.name,
    required this.value,
  });

  factory TodaystatisticsData.fromJson(Map<String, dynamic> json) {
    return TodaystatisticsData(
      name: json['name'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}
