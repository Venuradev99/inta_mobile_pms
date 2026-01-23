class DropdownOption {
  final int id;
  final String name;

  DropdownOption({
    required this.id,
    required this.name,
  });

  factory DropdownOption.fromJson(Map<String, dynamic> json) {
    return DropdownOption(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
