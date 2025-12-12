class BusinessSourceCategory {
  final int categoryId;
  final String description;

  BusinessSourceCategory({
    required this.categoryId,
    required this.description,
  });

  factory BusinessSourceCategory.fromJson(Map<String, dynamic> json) {
    return BusinessSourceCategory(
      categoryId: json['categoryId'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'description': description,
    };
  }
}
