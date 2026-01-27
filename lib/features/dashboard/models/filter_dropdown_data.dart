class FilterDropdownData {
  final int id;
  final String name;
  final int? filterId;

  FilterDropdownData({required this.id, required this.name, this.filterId});

  factory FilterDropdownData.fromJson(Map<String, dynamic> json) {
    return FilterDropdownData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      filterId: json['filterId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'filterId': filterId};
  }
}
