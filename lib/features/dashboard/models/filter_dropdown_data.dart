class FilterDropdownData {
  final int id;
  final String name;

  FilterDropdownData({
    required this.id,
    required this.name,
  });

  factory FilterDropdownData.fromJson(Map<String, dynamic> json) {
    return FilterDropdownData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

}
