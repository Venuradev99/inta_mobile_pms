class PropertyStaticsData {
  final String name;
  final double today;
  final double yesterday;
  final double percentage;

  PropertyStaticsData({
    required this.name,
    required this.today,
    required this.yesterday,
    required this.percentage,
  });

  /// Create object from JSON
  factory PropertyStaticsData.fromJson(Map<String, dynamic> json) {
    return PropertyStaticsData(
      name: json['name'] ?? '',
      today: (json['today'] ?? 0.0).toDouble(),
      yesterday: (json['yesterday'] ?? 0.0).toDouble(),
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'today': today,
      'yesterday': yesterday,
      'percentage': percentage,
    };
  }
}
