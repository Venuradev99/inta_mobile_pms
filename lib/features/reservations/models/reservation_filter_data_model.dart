
class ReservationFilterDataModel {
  final bool? arrivalCheck;
  final bool? createdCheck;
  final String? fromDate;
  final String? toDate;
  final String? customerName;
  final int? businessCategory;
  final int? businessSource;
  final int? roomType;
  final int? room;
  final int? status;
  final int? resType;

  ReservationFilterDataModel({
    this.arrivalCheck,
    this.createdCheck,
    this.fromDate,
    this.toDate,
    this.customerName,
    this.businessCategory,
    this.businessSource,
    this.roomType,
    this.room,
    this.status,
    this.resType,
  });

  /// Convert to API payload
  Map<String, dynamic> toJson() {

    return {
      "arrivalCheck": arrivalCheck,
      "createdCheck": createdCheck,
      "fromDate": fromDate,
      "toDate": toDate,
      "customerName": customerName ?? '',
      "businessCategory": businessCategory,
      "businessSource": businessSource,
      "roomType": roomType,
      "room": room,
      "status": status,
      "resType": resType,
    };
  }

  bool get hasFilters {
    return fromDate != null ||
        toDate != null ||
        (customerName?.isNotEmpty ?? false) ||
        businessCategory != null ||
        businessSource != null ||
        roomType != null ||
        room != null ||
        status != null ||
        resType != null;
  }
}
