class ReservationItem {
  final String guestName;
  final String propertyName;
  final String checkInDate;
  final String checkOutDate;
  final int nights;
  final int guests;
  final String bookingId;
  final String status;
  final double totalAmount;
  final double balanceAmount;

  const ReservationItem({
    required this.guestName,
    required this.propertyName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.guests,
    required this.bookingId,
    required this.status,
    required this.totalAmount,
    required this.balanceAmount,
  });
}