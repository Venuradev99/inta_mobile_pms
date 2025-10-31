import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/stay_view/models/stay_view_status_color.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/apiServices/stay_view_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class StayViewVm extends GetxController {
  final StayViewService _stayViewService;
  final ReservationListService _reservationListService;

  final statusList = <StayViewStatusColor>[].obs;
  final isLoading = Rx<bool>(true);
  final isRecordsEmpty = Rx<bool>(false);
  final today = Rxn<DateTime>();
  var roomTypes = <Map<String, dynamic>>[].obs;
  final allGuestDetails = Rx<GuestItem?>(null);

  StayViewVm(this._stayViewService, this._reservationListService);

  String yesterday(String today) {
    try {
      DateTime todayDateTime = DateTime.parse(today);
      return todayDateTime
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10);
    } catch (e) {
      throw Exception('Error calculating yesterday date: $e');
    }
  }

  void loadToday() async {
    try {
      final todaySystemDate = await LocalStorageManager.getSystemDate();
      today.value = DateTime.parse(todaySystemDate);
    } catch (e) {
      throw Exception('Error getting today system date: $e');
    }
  }

  Future<void> loadInitialData(DateTime date) async {
    try {
      isLoading.value = true;

      final payload = {
        "numberOfDates": 3,
        "roomTypeId": 0,
        "startDate": yesterday(date.toString()),
      };
      final response = await Future.wait([
        _stayViewService.getBookingStatics(payload),
        _stayViewService.getStatusColorForStayview(),
      ]);

      final bookingStatsResponse = response[0];
      final statusColorResponse = response[1];

      if (bookingStatsResponse["isSuccessful"] == true) {
        final roomTypeList = bookingStatsResponse["result"]["roomType"] ?? [];

        // Deep conversion with proper typing
        roomTypes.value = roomTypeList.map<Map<String, dynamic>>((roomType) {
          return {
            "roomTypeName": roomType["roomTypeName"],
            "roomTypeId": roomType["roomTypeId"],
            "datas":
                (roomType["datas"] as List?)
                    ?.map((d) => Map<String, dynamic>.from(d as Map))
                    .toList() ??
                [],
            "rooms":
                (roomType["rooms"] as List?)
                    ?.map(
                      (r) => {
                        ...Map<String, dynamic>.from(r as Map),
                        "roomData":
                            (r["roomData"] as List?)
                                ?.map(
                                  (rd) => Map<String, dynamic>.from(rd as Map),
                                )
                                .toList() ??
                            [],
                        "checkInExist": (r["checkInExist"] as List?) ?? [],
                      },
                    )
                    .toList() ??
                [],
          };
        }).toList();
      } else {
        final msg =
            bookingStatsResponse["errors"][0] ??
            'Error Loading Booking Statistics!';
        MessageService().error(msg);
      }

      if (statusColorResponse["isSuccessful"] == true) {
        final result = statusColorResponse["result"] as List;
        statusList.value = result
            .map(
              (item) => StayViewStatusColor(
                id: item["roomStatusId"] ?? 0,
                label: item["name"] ?? '',
                color: hexToColor(item["colorCode"]),
              ),
            )
            .toList();
      } else {
        final msg =
            statusColorResponse["errors"][0] ?? 'Error Loading Status Colors!';
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error loading initial data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Color hexToColor(String hexCode) {
    if (hexCode == '' || hexCode.isEmpty) {
      return Colors.grey;
    }

    try {
      String hex = hexCode.replaceAll('#', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      if (hex.length != 8) {
        throw FormatException("Hex color must be 6 or 8 characters long.");
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Future<void> getAllGuestData( int bookingRoomId) async {
    try {
      final response = await _reservationListService.getByBookingRoomId(
        bookingRoomId,
      );
      if (response["isSuccessful"] == true) {
        final result = response["result"];
        final folioChargesList = result["bookingRoom"]["folioCharges"];
        final roomCharge = result["bookingRoom"]["roomCharges"];

        List<FolioCharge> folioCharges = [];
        double totalRoomCharges = 0;

        for (final item in folioChargesList) {
          final folioChargesItem = FolioCharge(
            title: item["description"] ?? '',
            date: _parseDate(item["dateOfStay"]).toString(),
            room: item["roomName"] ?? '',
            amount: item["totalAmount"] ?? 0,
            isPosted: true,
          );
          folioCharges.add(folioChargesItem);
        }

        for (final item in roomCharge) {
          totalRoomCharges += item["totalAmount"];
        }

        final guestItem = GuestItem(
          bookingId: result["bookingId"] ?? 0,
          bookingRoomId: result["bookingRoom"]["bookingRoomId"].toString(),
          guestId: result["guest"]["guestId"] ?? 0,
          guestName: result["guest"]["firstName"] ?? '',
          fullAddress: result["guest"]["fullAddress"] ?? '',
          cityName: result["guest"]["cityName"] ?? '',
          zipCode: result["guest"]["zipCode"] ?? '',
          state: result["guest"]["state"] ?? '',
          civilStatus: result["guest"]["civilStatus"] ?? '',
          workPlace: result["guest"]["workPlace"] ?? '',
          swipeCardId: result["guest"]["swipeCardId"] ?? 0,
          imagePath: result["guest"]["imagePath"] ?? '',
          gender: result["guest"]["gender"] ?? 'Other',
          identityType: result["guest"]["identityType"] ?? 0,
          dateofBirth: result["guest"]["dateofBirth"] ?? '',
          nationalityId: result["guest"]["nationalityId"] ?? 0,
          anniversaryDate: result["guest"]["anniversaryDate"] ?? '',
          spouseDateofBirth: result["guest"]["spouseDateofBirth"] ?? '',
          birthCityId: result["guest"]["birthCityId"] ?? 0,
          vipStatusId: result["guest"]["vipStatusId"] ?? 0,
          isAdult: result["guest"]["isAdult"] ?? true,
          isMainGuest: result["guest"]["isMainGuest"] ?? true,
          isBlackListed: result["guest"]["isBlackListed"] ?? false,
          identityIssuingCityId: result["guest"]["identityIssuingCityId"] ?? 0,
          identityIssuingCountryId:
              result["guest"]["identityIssuingCountryId"] ?? 0,
          titleId: result["guest"]["titleId"] ?? 0,
          resId: result["bookingRoom"]["reservatioNumber"].toString(),
          folioId: result["bookingRoom"]["folioId"].toString(),
          startDate: getFirstTenCharacters(
            result["bookingRoom"]["arrivalDate"],
          ),
          endDate: getFirstTenCharacters(
            result["bookingRoom"]["departureDate"],
          ),
          nights: result["bookingRoom"]["noOfNights"] ?? 0,
          roomType: result["bookingRoom"]["roomTypeName"] ?? '',
          adults: result["bookingRoom"]["noOfAdults"] ?? 0,
          totalAmount: result["bookingRoom"]["totalAmount"] ?? 0,
          balanceAmount: result["bookingRoom"]["balanceAmount"] ?? 0,
          remainingNights: result["bookingRoom"]["noOfNights"] ?? 0,
          roomNumber: result["bookingRoom"]["roomName"] ?? '',
          reservedDate: getFirstTenCharacters(
            result["bookingRoom"]["bookingDate"],
          ),
          reservationType: result["bookingRoom"]["reservationTypeName"] ?? '',
          status: result["bookingRoom"]["status"].toString(),
          businessSource: result["bookingRoom"]["businessSourceName"] ?? '',
          cancellationNumber:
              result["cancellationData"]["cancellationNo"] ?? '',
          voucherNumber: result["advancePaymentData"]["voucherNumber"] ?? '',
          room: result["bookingRoom"]["roomName"] ?? '',
          roomId: result["bookingRoom"]["roomId"],
          country: result["guest"]["countryName"] ?? '',
          rateType: result["bookingRoom"]["rateTypeName"] ?? '',
          avgDailyRate: 0.0,
          totalCredits: 0.0,
          roomCharges: totalRoomCharges,
          discount: result["bookingRoom"]["discountAmount"] ?? 0.0,
          tax: result["bookingRoom"]["taxAmount"] ?? 0.0,
          extraCharge: 50.0,
          unpostedInclusionRate: 0.0,
          balanceTransfer: 0.0,
          amountPaid: 1000.0,
          roundOff: 0.0,
          childAge: "",
          adjustment: 0.0,
          netAmount: result["bookingRoom"]["grossAmount"] ?? 0.0,
          phone: result["guest"]["homeTel"] ?? '',
          mobile: result["guest"]["mobile"] ?? '',
          email: result["guest"]["email"] ?? '',
          fax: result["guest"]["fax"] ?? '',
          idNumber: result["guest"]["identityNumber"] ?? '',
          idType: result["guest"]["identityType"].toString(),
          expiryDate: getFirstTenCharacters(result["guest"]["expiryDate"]),
          dob: getFirstTenCharacters(result["guest"]["dateofBirth"]),
          nationality: result["guest"]["nationalityId"].toString(),
          arrivalBy: result["pickUpData"]["pickupMode"].toString(),
          arrivalVehicle: result["pickUpData"]["vehicle"] ?? '',
          arrivalDate: getFirstTenCharacters(
            result["bookingRoom"]["arrivalDate"],
          ),
          arrivalTime: getFirstTenCharacters(
            result["bookingRoom"]["arrivalTime"],
          ),
          departureBy: result["pickUpData"]["pickupMode"].toString(),
          departureVehicle: result["pickUpData"]["vehicle"] ?? '',
          departureDate: getFirstTenCharacters(
            result["bookingRoom"]["departureDate"],
          ),
          departureTime: getFirstTenCharacters(
            result["bookingRoom"]["departureTime"],
          ),
          arrival: getFirstTenCharacters(result["bookingRoom"]["arrivalDate"]),
          departure: getFirstTenCharacters(
            result["bookingRoom"]["departureDate"],
          ),
          cancellationDate: result["cancellationData"]["cancellDate"],
          children: result["bookingRoom"]["noOfChildren"],
          marketCode: result["bookingRoom"]["marketName"] ?? '',
          company: result["companyOther"]["companyName"].toString(),
          travelAgent: result["travelAgentInformation"]["agentId"].toString(),
          remarks: result["guest"]["remark"] ?? '',
          billingRateTypeId:
              result["billingInformation"]["billingRateTypeId"] ?? 0,
          billingInstructionId:
              result["billingInformation"]["billingInstructionId"] ?? 0,
          isTaxInclusiveRate:
              result["billingInformation"]["isTaxInclusiveRate"] ?? false,
          taxRegistrationDate:
              result["billingInformation"]["taxRegistrationDate"] ?? "",
          billNumber: result["billingInformation"]["billNumber"] ?? "",
          isCash: result["billingInformation"]["billingInstructionId"] ?? 0,
          isComplementory:
              result["billingInformation"]["isComplementory"] ?? false,
          manualRate: result["billingInformation"]["manualRate"] ?? 0.0,
          paymentMode: result["billingInformation"]["paymentMode"] ?? 0,
          paymentModeCategory:
              result["billingInformation"]["paymentModeCategory"] ?? 0,
          rateSourceId: result["billingInformation"]["rateSourceId"] ?? 0,
          releaseChargeAmountPercentage:
              result["billingInformation"]["releaseChargeAmountPercentage"] ??
              0.0,
          releaseDate: result["billingInformation"]["releaseDate"] ?? "",
          businessCategoryId: result["companyOther"]["businessCategoryId"] ?? 0,
          businessSourceId: result["companyOther"]["businessSourceId"] ?? 0,
          marketId: result["companyOther"]["marketId"] ?? 0,
          isToBeReleased:
              result["billingInformation"]["isToBeReleased"] ?? false,
          maxDep: result["billingInformation"]["maxDep"] ?? "",
          maxNights: result["billingInformation"]["maxNights"] ?? 0,
          minArr: result["billingInformation"]["minArr"] ?? "",
          pax: result["billingInformation"]["pax"] ?? 0,
          vehiclePlate: result["billingInformation"]["vehiclePlate"] ?? "",
          voucherNo: result["billingInformation"]["voucherNo"] ?? "",
          resDate: result["billingInformation"]["resDate"] ?? "",
          travelAgentCommisionPlanId:
              result["bookingRoom"]["travelAgentCommisionPlanId"] ?? 0,
          travelAgentCommisionPlanValue:
              result["bookingRoom"]["travelAgentCommisionPlanValue"] ?? 0.00,
          grCardNumber: result["billingInformation"]["grCardNumber"] ?? "",
          masterFolioBookingTransId: result["masterFolioBookingTransId"] ?? 0,
          folioCharges: folioCharges,
        );
        allGuestDetails.value = guestItem;
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error loading guest data!',
        );
      }
    } catch (e) {
      MessageService().error('Error getting all Guest data: $e');
      throw Exception('Error getting all Guest data: $e');
    }
  }

  DateTime _parseDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String getFirstTenCharacters(String? str) {
    if (str == null || str.isEmpty) {
      return '';
    }
    return str.length > 10 ? str.substring(0, 10) : str;
  }
}
