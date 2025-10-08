class OccupancyData {
  final double today;
  final double yesterday;

  OccupancyData({required this.today, required this.yesterday});

  factory OccupancyData.fromJson(Map<String, dynamic> json) {
    return OccupancyData(
      today: (json['today'] ?? 0.0).toDouble(),
      yesterday: (json['yesterday'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'today': today, 'yesterday': yesterday};
  }
}
