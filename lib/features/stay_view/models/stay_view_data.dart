import 'package:flutter/material.dart';

class StayViewRoomData {
  final String type;
  final String name;
  final List<int?>? statuses;
  final Color? color;

  StayViewRoomData({
    required this.type,
    required this.name,
    this.statuses,
    this.color,
  });

  factory StayViewRoomData.fromJson(Map<String, dynamic> json) {
    return StayViewRoomData(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      statuses: json['statuses'] != null
          ? List<int?>.from(json['statuses'].map((e) => e as int?))
          : null,
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'statuses': statuses,
      'color': color?.value,
    };
  }

  @override
  String toString() =>
      'StayViewRoomData(type: $type, name: $name, statuses: $statuses, color: $color)';
}

class StayViewData {
  final String name;
  final List<StayViewRoomData> items;

  StayViewData({
    required this.name,
    required this.items,
  });

  factory StayViewData.fromJson(Map<String, dynamic> json) {
    return StayViewData(
      name: json['name'] ?? '',
      items: (json['items'] as List<dynamic>)
          .map((e) => StayViewRoomData.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => 'StayViewData(name: $name, items: $items)';
}
