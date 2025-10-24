class AmendStaySaveData {
  bool applyToWholeStay;
  String arrivalDate;
  int bookingRoomId;
  int currencyId;
  String departureDate;
  bool isManualRate;
  bool isOverrideRate;
  bool isTaxInclusive;
  double manualRate;

  AmendStaySaveData({
    required this.applyToWholeStay,
    required this.arrivalDate,
    required this.bookingRoomId,
    required this.currencyId,
    required this.departureDate,
    required this.isManualRate,
    required this.isOverrideRate,
    required this.isTaxInclusive,
    required this.manualRate,
  });

  factory AmendStaySaveData.fromJson(Map<String, dynamic> json) {
    return AmendStaySaveData(
      applyToWholeStay: json['applyToWholeStay'] ?? false,
      arrivalDate: json['arrivalDate'] ?? '',
      bookingRoomId: json['bookingRoomId'] ?? 0,
      currencyId: json['currencyId'] ?? 0,
      departureDate: json['departureDate'] ?? '',
      isManualRate: json['isManualRate'] ?? false,
      isOverrideRate: json['isOverrideRate'] ?? false,
      isTaxInclusive: json['isTaxInclusive'] ?? false,
      manualRate: (json['manualRate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applyToWholeStay': applyToWholeStay,
      'arrivalDate': arrivalDate,
      'bookingRoomId': bookingRoomId,
      'currencyId': currencyId,
      'departureDate': departureDate,
      'isManualRate': isManualRate,
      'isOverrideRate': isOverrideRate,
      'isTaxInclusive': isTaxInclusive,
      'manualRate': manualRate,
    };
  }

  @override
  String toString() {
    return 'BookingRoom(applyToWholeStay: $applyToWholeStay, arrivalDate: $arrivalDate, bookingRoomId: $bookingRoomId, '
        'currencyId: $currencyId, departureDate: $departureDate, isManualRate: $isManualRate, '
        'isOverrideRate: $isOverrideRate, isTaxInclusive: $isTaxInclusive, manualRate: $manualRate)';
  }
}
