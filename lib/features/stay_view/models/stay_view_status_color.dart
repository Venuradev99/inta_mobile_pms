import 'package:flutter/material.dart';

class StayViewStatusColor {
  final int id;
  final String label;
  final Color color;

  StayViewStatusColor({
    required this.id,
    required this.label,
    required this.color,
  });

  factory StayViewStatusColor.fromJson(Map<String, dynamic> json) {
    return StayViewStatusColor(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      color: Color(json['color'] ?? 0xFFFFFFFF),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'color': color.value,
    };
  }

  @override
  String toString() =>
      'StayViewStatusColor(label: $label, color: ${color.value.toRadixString(16)})';
}
