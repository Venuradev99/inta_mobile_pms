// lib/models/guest_item.dart
class GuestItem {
  final String guestName;
  final String resId;
  final String folioId;
  final String startDate;
  final String endDate;
  final int nights;
  final String roomType;
  final int adults;
  final double totalAmount;
  final double balanceAmount;

  GuestItem({
    required this.guestName,
    required this.resId,
    required this.folioId,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.roomType,
    required this.adults,
    required this.totalAmount,
    required this.balanceAmount,
  });
}

class InHouseItem extends GuestItem {
  final int remainingNights;
  final String roomNumber;

  InHouseItem({
    required super.guestName,
    required super.resId,
    required super.folioId,
    required super.startDate,
    required super.endDate,
    required super.nights,
    required super.roomType,
    required super.adults,
    required super.totalAmount,
    required super.balanceAmount,
    required this.remainingNights,
    required this.roomNumber,
  });
}