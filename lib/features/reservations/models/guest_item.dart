import 'dart:ui';

import 'package:inta_mobile_pms/features/reservations/models/room_charges.dart';
import 'package:inta_mobile_pms/features/reservations/models/sharer_info.dart';

class GuestItem {
  final String? reservationNumber;
  final int? bookingId;
  final String? statusName;
  final String? bookingRoomId;
  final String? guestName;
  final String? fullNameWithTitle;
  final String? nationalityName;
  final int? guestId;
  final int? titleId;
  final String? fullAddress;
  final String? cityName;
  final String? imagePath;
  final String? zipCode;
  final String? state;
  final int? identityType;
  final bool? isAdult;
  final bool? isMainGuest;
  final bool? isBlackListed;
  final String? gender;
  final int? nationalityId;
  final int? vipStatusId;
  final int? identityIssuingCountryId;
  final int? identityIssuingCityId;
  final String? dateofBirth;
  final String? spouseDateofBirth;
  final String? anniversaryDate;
  final int? birthCityId;
  final int? swipeCardId;
  final String? resId;
  final String? folioId;
  final String? folioNumber;
  final String? startDate;
  final String? endDate;
  final int? nights;
  final String? roomType;
  final int? adults;
  final double? totalAmount;
  final double? balanceAmount;
  final int? remainingNights;
  final String? roomNumber;
  final String? reservedDate;
  final String? reservationType;
  final String? baseCurrencySymbol;
  final String? status;
  final String? workPlace;
  final String? civilStatus;
  final String? businessSource;
  final String? cancellationNumber;
  final String? voucherNumber;
  final String? room;
  final int? roomId;
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
  final String? arrival;
  final String? departure;
  final String? cancellationDate;
  final int? children;
  final String? marketCode;
  final String? company;
  final String? travelAgent;
  final String? remarks;
  final int? billingRateTypeId;
  final int? travelAgentCommisionPlanId;
  final double? travelAgentCommisionPlanValue;
  final String? grCardNumber;
  final String? visibleCurrencyCode;
  final Color? colorCode;
  final int? masterFolioBookingTransId;
  final List<FolioCharge>? folioCharges;
  final List<RoomCharge>? roomChargesList;
  final List<SharerInfo>? sharerInfo;

  int? billingInstructionId;
  bool? isTaxInclusiveRate;
  String? taxRegistrationDate;
  String? billNumber;
  int? isCash;
  bool? isComplementory;
  double? manualRate;
  int? paymentMode;
  int? paymentModeCategory;
  int? rateSourceId;
  double? releaseChargeAmountPercentage;
  String? releaseDate;
  int? businessCategoryId;
  int? businessSourceId;
  String? businessSourceName;
  String? businessCategoryName;
  int? marketId;
  bool? isToBeReleased;
  String? maxDep;
  int? maxNights;
  String? minArr;
  int? pax;
  String? vehiclePlate;
  String? voucherNo;
  String? resDate;

  GuestItem({
    this.reservationNumber,
    this.bookingId,
    this.bookingRoomId,
    this.guestName,
    this.fullNameWithTitle,
    this.statusName,
    this.nationalityName,
    this.visibleCurrencyCode,
    this.guestId,
    this.titleId,
    this.zipCode,
    this.state,
    this.fullAddress,
    this.cityName,
    this.workPlace,
    this.imagePath,
    this.identityType,
    this.nationalityId,
    this.vipStatusId,
    this.swipeCardId,
    this.baseCurrencySymbol,
    this.identityIssuingCountryId,
    this.identityIssuingCityId,
    this.dateofBirth,
    this.anniversaryDate,
    this.spouseDateofBirth,
    this.birthCityId,
    this.gender,
    this.isAdult,
    this.isMainGuest,
    this.isBlackListed,
    this.folioNumber,
    this.resId,
    this.folioId,
    this.startDate,
    this.endDate,
    this.nights,
    this.roomType,
    this.adults,
    this.totalAmount,
    this.balanceAmount,
    this.remainingNights,
    this.roomNumber,
    this.reservedDate,
    this.reservationType,
    this.status,
    this.civilStatus,
    this.businessSource,
    this.cancellationNumber,
    this.voucherNumber,
    this.room,
    this.roomId,
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
    this.billingRateTypeId,
    this.billingInstructionId,
    this.travelAgentCommisionPlanId,
    this.travelAgentCommisionPlanValue,
    this.isTaxInclusiveRate,
    this.taxRegistrationDate,
    this.billNumber,
    this.isCash,
    this.isComplementory,
    this.manualRate,
    this.paymentMode,
    this.paymentModeCategory,
    this.rateSourceId,
    this.releaseChargeAmountPercentage,
    this.releaseDate,
    this.businessCategoryId,
    this.businessSourceId,
    this.businessSourceName,
    this.businessCategoryName,
    this.marketId,
    this.isToBeReleased,
    this.maxDep,
    this.maxNights,
    this.minArr,
    this.pax,
    this.vehiclePlate,
    this.voucherNo,
    this.resDate,
    this.grCardNumber,
    this.colorCode,
    this.masterFolioBookingTransId,
    this.roomChargesList,
    this.sharerInfo,
  });

  factory GuestItem.fromJson(Map<String, dynamic> json) {
    return GuestItem(
      bookingId: json['bookingId'] ?? 0,
      statusName: json['statusName'] ?? '',
      visibleCurrencyCode: json['visibleCurrencyCode'] ?? '',
      reservationNumber: json['reservationNumber'] ?? '',
      baseCurrencySymbol: json['baseCurrencySymbol'] ?? '',
      bookingRoomId: json['bookingRoomId'] ?? '',
      guestName: json['guestName'] ?? '',
      fullNameWithTitle: json['fullNameWithTitle'] ?? '',
      nationalityName: json['nationalityName'] ?? '',
      guestId: json['guestId'] ?? 0,
      titleId: json['titleId'] ?? 0,
      fullAddress: json['fullAddress'] ?? '',
      zipCode: json['zipCode'] ?? '',
      colorCode: json['colorCode'] ?? '',
      state: json['state'] ?? '',
      gender: json['gender'] ?? '',
      isAdult: json['isAdult'] ?? true,
      isMainGuest: json['isMainGuest'] ?? true,
      isBlackListed: json['isBlackListed'] ?? false,
      identityType: json['identityType'] ?? 0,
      nationalityId: json['nationalityId'] ?? 0,
      vipStatusId: json['vipStatusId'] ?? 0,
      swipeCardId: json['swipeCardId'] ?? 0,
      cityName: json['cityName'] ?? '',
      workPlace: json['workPlace'] ?? '',
      imagePath: json['imagePath'] ?? '',
      identityIssuingCityId: json['identityIssuingCityId'] ?? 0,
      identityIssuingCountryId: json['identityIssuingCountryId'] ?? 0,
      dateofBirth: json['dateofBirth'] ?? '',
      anniversaryDate: json['anniversaryDate'] ?? '',
      spouseDateofBirth: json['spouseDateofBirth'] ?? '',
      birthCityId: json['birthCityId'] ?? 0,
      resId: json['resId'] ?? '',
      folioId: json['folioId'] ?? '',
      folioNumber: json['folioNumber'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      nights: json['nights'] ?? 0,
      roomType: json['roomType'],
      adults: json['adults'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      balanceAmount: (json['balanceAmount'] ?? 0.0).toDouble(),
      remainingNights: json['remainingNights'],
      roomNumber: json['roomNumber'],
      reservedDate: json['reservedDate'],
      reservationType: json['reservationType'],
      status: json['status'],
      businessSource: json['businessSource'],
      cancellationNumber: json['cancellationNumber'],
      voucherNumber: json['voucherNumber'],
      room: json['room'],
      roomId: json['roomId'],
      country: json['country'],
      rateType: json['rateType'],
      avgDailyRate: (json['avgDailyRate'] ?? 0.0).toDouble(),
      totalCredits: (json['totalCredits'] ?? 0.0).toDouble(),
      roomCharges: (json['roomCharges'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      extraCharge: (json['extraCharge'] ?? 0.0).toDouble(),
      unpostedInclusionRate: (json['unpostedInclusionRate'] ?? 0.0).toDouble(),
      balanceTransfer: (json['balanceTransfer'] ?? 0.0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0.0).toDouble(),
      roundOff: (json['roundOff'] ?? 0.0).toDouble(),
      childAge: json['childAge'],
      adjustment: (json['adjustment'] ?? 0.0).toDouble(),
      netAmount: (json['netAmount'] ?? 0.0).toDouble(),
      phone: json['phone'],
      mobile: json['mobile'],
      email: json['email'],
      fax: json['fax'],
      idNumber: json['idNumber'],
      idType: json['idType'],
      expiryDate: json['expiryDate'],
      dob: json['dob'],
      nationality: json['nationality'],
      arrivalBy: json['arrivalBy'],
      arrivalVehicle: json['arrivalVehicle'],
      arrivalDate: json['arrivalDate'],
      arrivalTime: json['arrivalTime'],
      departureBy: json['departureBy'],
      departureVehicle: json['departureVehicle'],
      departureDate: json['departureDate'],
      departureTime: json['departureTime'],
      arrival: json['arrival'],
      departure: json['departure'],
      cancellationDate: json['cancellationDate'],
      children: json['children'],
      marketCode: json['marketCode'],
      company: json['company'],
      travelAgent: json['travelAgent'],
      remarks: json['remarks'],
      folioCharges: json['folioCharges'] != null
          ? List<FolioCharge>.from(
              json['folioCharges'].map((x) => FolioCharge.fromJson(x)),
            )
          : null,
      roomChargesList: json['roomChargesList'] != null
          ? List<RoomCharge>.from(
              json['roomChargesList'].map((x) => RoomCharge.fromJson(x)),
            )
          : null,
      sharerInfo: json['sharerInfo'] != null
          ? List<SharerInfo>.from(
              json['sharerInfo'].map((x) => SharerInfo.fromJson(x)),
            )
          : null,
      travelAgentCommisionPlanId: json['travelAgentCommisionPlanId'],
      travelAgentCommisionPlanValue: json['travelAgentCommisionPlanValue'],
      billingRateTypeId: json['billingRateTypeId'],
      billingInstructionId: json['billingInstructionId'],
      isTaxInclusiveRate: (json['isTaxInclusiveRate']),
      taxRegistrationDate: json['taxRegistrationDate'],
      billNumber: json['billNumber'],
      isCash: json['isCash'],
      isComplementory: json['isComplementory'],
      manualRate: (json['manualRate'] ?? 0.0).toDouble(),
      paymentMode: json['paymentMode'],
      paymentModeCategory: json['paymentModeCategory'],
      rateSourceId: json['rateSourceId'],
      releaseChargeAmountPercentage:
          (json['releaseChargeAmountPercentage'] ?? 0.0).toDouble(),
      releaseDate: json['releaseDate'],
      businessCategoryId: json['businessCategoryId'],
      businessSourceId: json['businessSourceId'],
      businessSourceName: json['businessSourceName'],
      businessCategoryName: json['businessCategoryName'],
      marketId: json['marketId'],
      isToBeReleased: json['isToBeReleased'],
      maxDep: json['maxDep'],
      maxNights: json['maxNights'],
      minArr: json['minArr'],
      pax: json['pax'],
      vehiclePlate: json['vehiclePlate'],
      voucherNo: json['voucherNo'],
      resDate: json['resDate'],
      grCardNumber: json['grCardNumber'],
      masterFolioBookingTransId: json['masterFolioBookingTransId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservationNumber': reservationNumber,
      'bookingId': bookingId,
      'statusName': statusName,
      'bookingRoomId': bookingRoomId,
      'baseCurrencySymbol': baseCurrencySymbol,
      'guestName': guestName,
      'fullNameWithTitle': fullNameWithTitle,
      'nationalityName': nationalityName,
      'guestId': guestId,
      'titleId': titleId,
      'zipCode': zipCode,
      'colorCode': colorCode,
      'state': state,
      'identityType': identityType,
      'nationalityId': nationalityId,
      'vipStatusId': vipStatusId,
      'swipeCardId': swipeCardId,
      'fullAddress': fullAddress,
      'cityName': cityName,
      'workPlace': workPlace,
      'imagePath': imagePath,
      'isAdult': isAdult,
      'isMainGuest': isMainGuest,
      'isBlackListed': isBlackListed,
      'gender': gender,
      'identityIssuingCountryId': identityIssuingCountryId,
      'identityIssuingCityId': identityIssuingCityId,
      'birthCityId': birthCityId,
      'spouseDateofBirth': spouseDateofBirth,
      'dateofBirth': dateofBirth,
      'anniversaryDate': anniversaryDate,
      'resId': resId,
      'folioId': folioId,
      'folioNumber': folioNumber,
      'startDate': startDate,
      'endDate': endDate,
      'nights': nights,
      'roomType': roomType,
      'adults': adults,
      'totalAmount': totalAmount,
      'balanceAmount': balanceAmount,
      'remainingNights': remainingNights,
      'roomNumber': roomNumber,
      'reservedDate': reservedDate,
      'reservationType': reservationType,
      'status': status,
      'businessSource': businessSource,
      'cancellationNumber': cancellationNumber,
      'voucherNumber': voucherNumber,
      'room': room,
      'roomId': roomId,
      'country': country,
      'rateType': rateType,
      'avgDailyRate': avgDailyRate,
      'totalCredits': totalCredits,
      'roomCharges': roomCharges,
      'discount': discount,
      'tax': tax,
      'extraCharge': extraCharge,
      'unpostedInclusionRate': unpostedInclusionRate,
      'balanceTransfer': balanceTransfer,
      'amountPaid': amountPaid,
      'roundOff': roundOff,
      'childAge': childAge,
      'adjustment': adjustment,
      'netAmount': netAmount,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'fax': fax,
      'idNumber': idNumber,
      'idType': idType,
      'expiryDate': expiryDate,
      'dob': dob,
      'nationality': nationality,
      'arrivalBy': arrivalBy,
      'arrivalVehicle': arrivalVehicle,
      'arrivalDate': arrivalDate,
      'arrivalTime': arrivalTime,
      'departureBy': departureBy,
      'departureVehicle': departureVehicle,
      'departureDate': departureDate,
      'departureTime': departureTime,
      'arrival': arrival,
      'departure': departure,
      'cancellationDate': cancellationDate,
      'children': children,
      'marketCode': marketCode,
      'company': company,
      'travelAgent': travelAgent,
      'remarks': remarks,
      'folioCharges': folioCharges?.map((f) => f.toJson()).toList(),
      'roomChargesList': roomChargesList?.map((f) => f.toJson()).toList(),
      'sharerInfo': sharerInfo?.map((f) => f.toJson()).toList(),
      'billingRateTypeId': billingRateTypeId,
      'billingInstructionId': billingInstructionId,
      'travelAgentCommisionPlanValue': travelAgentCommisionPlanValue,
      'travelAgentCommisionPlanId': travelAgentCommisionPlanId,
      'isTaxInclusiveRate': isTaxInclusiveRate,
      'taxRegistrationDate': taxRegistrationDate,
      'billNumber': billNumber,
      'isCash': isCash,
      'isComplementory': isComplementory,
      'manualRate': manualRate,
      'paymentMode': paymentMode,
      'paymentModeCategory': paymentModeCategory,
      'rateSourceId': rateSourceId,
      'releaseChargeAmountPercentage': releaseChargeAmountPercentage,
      'releaseDate': releaseDate,
      'businessCategoryId': businessCategoryId,
      'businessSourceId': businessSourceId,
      'businessSourceName': businessSourceName,
      'businessCategoryName': businessCategoryName,
      'marketId': marketId,
      'isToBeReleased': isToBeReleased,
      'maxDep': maxDep,
      'maxNights': maxNights,
      'minArr': minArr,
      'pax': pax,
      'vehiclePlate': vehiclePlate,
      'voucherNo': voucherNo,
      'resDate': resDate,
      'grCardNumber': grCardNumber,
      'visibleCurrencyCode': visibleCurrencyCode,
      'masterFolioBookingTransId': masterFolioBookingTransId,
    };
  }

  @override
  String toString() {
    return 'GuestItem('
        'baseCurrencySymbol: $baseCurrencySymbol, '
        'reservationNumber: $reservationNumber, '
        'bookingId: $bookingId, '
        'statusName: $statusName, '
        'bookingRoomId: $bookingRoomId, '
        'guestName: $guestName, '
        'fullNameWithTitle: $fullNameWithTitle, '
        'naitonalityName: $nationalityName, '
        'workPlace: $workPlace, '
        'guestId: $guestId, '
        'titleId: $titleId,'
        'fullAddress: $fullAddress, '
        'cityName: $cityName, '
        'imagePath: $imagePath, '
        'zipCode: $zipCode, '
        'colorCode: $colorCode'
        'state: $state, '
        'gender: $gender'
        'isAdult: $isAdult, '
        'isMainGuest: $isMainGuest, '
        'identityType: $identityType, '
        'nationalityId: $nationalityId, '
        'vipStatusId: $vipStatusId, '
        'swipeCardId: $swipeCardId, '
        'identityIssuingCityId: $identityIssuingCityId, '
        'identityIssuingCountryId: $identityIssuingCountryId, '
        'birthCityId: $birthCityId, '
        'spouseDateofBirth: $spouseDateofBirth, '
        'dateofBirth: $dateofBirth, '
        'resId: $resId, '
        'folioId: $folioId, '
        'folioNumber: $folioNumber, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'nights: $nights, '
        'roomType: $roomType, '
        'adults: $adults, '
        'totalAmount: $totalAmount, '
        'balanceAmount: $balanceAmount, '
        'remainingNights: $remainingNights, '
        'roomNumber: $roomNumber, '
        'reservedDate: $reservedDate, '
        'reservationType: $reservationType, '
        'status: $status, '
        'businessSource: $businessSource, '
        'cancellationNumber: $cancellationNumber, '
        'voucherNumber: $voucherNumber, '
        'room: $room, '
        'roomId: $roomId, '
        'country: $country, '
        'rateType: $rateType, '
        'avgDailyRate: $avgDailyRate, '
        'totalCredits: $totalCredits, '
        'roomCharges: $roomCharges, '
        'discount: $discount, '
        'tax: $tax, '
        'extraCharge: $extraCharge, '
        'unpostedInclusionRate: $unpostedInclusionRate, '
        'balanceTransfer: $balanceTransfer, '
        'amountPaid: $amountPaid, '
        'roundOff: $roundOff, '
        'childAge: $childAge, '
        'adjustment: $adjustment, '
        'netAmount: $netAmount, '
        'phone: $phone, '
        'mobile: $mobile, '
        'email: $email, '
        'fax: $fax, '
        'idNumber: $idNumber, '
        'idType: $idType, '
        'expiryDate: $expiryDate, '
        'dob: $dob, '
        'nationality: $nationality, '
        'arrivalBy: $arrivalBy, '
        'arrivalVehicle: $arrivalVehicle, '
        'arrivalDate: $arrivalDate, '
        'arrivalTime: $arrivalTime, '
        'departureBy: $departureBy, '
        'departureVehicle: $departureVehicle, '
        'departureDate: $departureDate, '
        'departureTime: $departureTime, '
        'arrival: $arrival, '
        'departure: $departure, '
        'cancellationDate: $cancellationDate, '
        'children: $children, '
        'marketCode: $marketCode, '
        'company: $company, '
        'travelAgent: $travelAgent, '
        'remarks: $remarks, '
        'billingRateTypeId: $billingRateTypeId, '
        'billingInstructionId: $billingInstructionId, '
        'travelAgentCommisionPlanId: $travelAgentCommisionPlanId, '
        'travelAgentCommisionPlanValue: $travelAgentCommisionPlanValue, '
        'isTaxInclusiveRate: $isTaxInclusiveRate, '
        'taxRegistrationDate: $taxRegistrationDate, '
        'billNumber: $billNumber, '
        'isCash: $isCash, '
        'isComplementory: $isComplementory, '
        'manualRate: $manualRate, '
        'paymentMode: $paymentMode, '
        'paymentModeCategory: $paymentModeCategory, '
        'rateSourceId: $rateSourceId, '
        'releaseChargeAmountPercentage: $releaseChargeAmountPercentage, '
        'releaseDate: $releaseDate, '
        'businessCategoryId: $businessCategoryId, '
        'businessSourceId: $businessSourceId, '
        'businessSourceName: $businessSourceName, '
        'businessCategoryName: $businessCategoryName, '
        'marketId: $marketId, '
        'isToBeReleased: $isToBeReleased, '
        'maxDep: $maxDep, '
        'maxNights: $maxNights, '
        'minArr: $minArr, '
        'pax: $pax, '
        'vehiclePlate: $vehiclePlate, '
        'voucherNo: $voucherNo, '
        'resDate: $resDate, '
        'grCardNumber: $grCardNumber,'
        'visibleCurrencyCode:$visibleCurrencyCode, '
        'masterFolioBookingTransId:$masterFolioBookingTransId'
        ')';
  }
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

  factory FolioCharge.fromJson(Map<String, dynamic> json) {
    return FolioCharge(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      room: json['room'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      isPosted: json['isPosted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'room': room,
      'amount': amount,
      'isPosted': isPosted,
    };
  }
}
