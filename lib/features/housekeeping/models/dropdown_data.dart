class DropdownData {
  final int id;
  final String description;

  DropdownData({
    required this.id,
    required this.description,
  });

  factory DropdownData.fromJson(Map<String, dynamic> json) {
    return DropdownData(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }

  @override
  String toString() => 'DropdownData(id: $id, description: $description)';
}
