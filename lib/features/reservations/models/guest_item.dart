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
final String? country;
final String? rateType;
final double? avgDailyRate;
final double? totalCredits;
final double? roomCharges;
final double? discount;
final double? tax;
final double? extraCharge;
final double? unpostedInclusionRate;
final double? balanceTransfer;
final double? amountPaid;
final double? roundOff;
final String? childAge;
final double? adjustment;
final double? netAmount;
final String? phone;
final String? mobile;
final String? email;
final String? fax;
final String? idNumber;
final String? idType;
final String? expiryDate;
final String? dob;
final String? nationality;
final String? arrivalBy;
final String? arrivalVehicle;
final String? arrivalDate;
final String? arrivalTime;
final String? departureBy;
final String? departureVehicle;
final String? departureDate;
final String? departureTime;
final String? arrival; // Full arrival datetime
final String? departure; // Full departure datetime
final String? cancellationDate;
final int? children;
final String? marketCode;
final String? company;
final String? travelAgent;
final String? remarks;
final List<FolioCharge>? folioCharges; // Optional list for folio details
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
this.country,
this.rateType,
this.avgDailyRate,
this.totalCredits,
this.roomCharges,
this.discount,
this.tax,
this.extraCharge,
this.unpostedInclusionRate,
this.balanceTransfer,
this.amountPaid,
this.roundOff,
this.childAge,
this.adjustment,
this.netAmount,
this.phone,
this.mobile,
this.email,
this.fax,
this.idNumber,
this.idType,
this.expiryDate,
this.dob,
this.nationality,
this.arrivalBy,
this.arrivalVehicle,
this.arrivalDate,
this.arrivalTime,
this.departureBy,
this.departureVehicle,
this.departureDate,
this.departureTime,
this.arrival,
this.departure,
this.cancellationDate,
this.children,
this.marketCode,
this.company,
this.travelAgent,
this.remarks,
this.folioCharges,
});
}

class FolioCharge {
final String title; 
final String date; 
final String room; 
final double amount;
final bool isPosted; 
FolioCharge({
required this.title,
required this.date,
required this.room,
required this.amount,
required this.isPosted,
});
}