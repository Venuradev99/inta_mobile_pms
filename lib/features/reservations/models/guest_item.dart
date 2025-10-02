class GuestItem {
  final String guestName;
  final String resId;
  final String folioId;
  final String startDate;
  final String endDate;
  final int nights;
  final String? roomType;
  final int adults;
  final double totalAmount;
  final double balanceAmount;
  final int? remainingNights;
  final String? roomNumber;
  final String? reservedDate;
  final String? reservationType;
  final String? status;
  final String? businessSource;
  final String? cancellationNumber;
  final String? voucherNumber; 
  final String? room;

  GuestItem({
    required this.guestName,
    required this.resId,
    required this.folioId,
    required this.startDate,
    required this.endDate,
    required this.nights,
    this.roomType,
    required this.adults,
    required this.totalAmount,
    required this.balanceAmount,
    this.remainingNights,
    this.roomNumber,
    this.reservedDate,
    this.reservationType,
    this.status,
    this.businessSource,
    this.cancellationNumber,
    this.voucherNumber,
    this.room,
  });
}