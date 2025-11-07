import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/dashboard/models/filter_dropdown_data.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_search_request_model.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class ReservationListVm extends GetxController {
  final ReservationListService _reservationListService;

  final reservationList = Rx<Map<String, List<GuestItem>>?>(null);
  final reservationFilteredList = Rx<Map<String, List<GuestItem>>?>(null);
  final receivedFilters = Rx<Map<String, dynamic>?>(null);
  final statusList = [].obs;
  final allGuestDetails = Rx<GuestItem?>(null);

  var roomTypes = <FilterDropdownData>[].obs;
  var reservationTypes = <FilterDropdownData>[].obs;
  var statuses = <FilterDropdownData>[].obs;
  var businessSources = <FilterDropdownData>[].obs;

  final isLoading = true.obs;
  final isBottomSheetDataLoading = false.obs;

  ReservationListVm(this._reservationListService);

  String getToDateForWeek(String fromDate) {
    DateTime startDate = DateTime.parse(fromDate);
    DateTime endDate = startDate.add(Duration(days: 6));
    return endDate.toIso8601String().substring(0, 10);
  }

  String getTomorrow(String fromDate) {
    DateTime startDate = DateTime.parse(fromDate);
    DateTime endDate = startDate.add(Duration(days: 1));
    return endDate.toIso8601String().substring(0, 10);
  }

  Future<void> getReservationsMap() async {
    try {
      isLoading.value = true;
      final today = await LocalStorageManager.getSystemDate();
      final body = ReservationSearchRequest(
        businessSourceId: 0,
        exceptCancelled: false,
        fromDate: today.toString(),
        isArrivalDate: true,
        reservationTypeId: 0,
        roomId: 0,
        roomTypeId: 0,
        searchByName: "",
        searchType: 1,
        status: 0,
        toDate: getToDateForWeek(today.toString()),
        businessCategoryId: 0,
      ).toJson();

      final response = await Future.wait([
        _reservationListService.getAllReservationList(body),
        _reservationListService.getAllroomstatus(),
        _reservationListService.getAllRoomTypes(),
        _reservationListService.getAllroomstatus(),
        _reservationListService.getAllreservationTypes(),
        _reservationListService.getAllbusinessSources(),
      ]);

      final reservationResponse = response[0];
      final statusResponse = response[1];
      final roomTypeResponse = response[2];
      final roomStatusResponse = response[3];
      final reservationTypeResponse = response[4];
      final businessSourcesResponse = response[5];

      if (reservationResponse["isSuccessful"] == true) {
        final result = reservationResponse["result"];
        reservationList.value = {'today': [], 'tomorrow': [], 'thisweek': []};

        for (final item in result) {
          final data = GuestItem(
            bookingRoomId: item['bookingRoomId'].toString(),
            guestName: item['bookingGuestWithTitle'] ?? '',
            resId: item['reservationNo'] ?? '',
            folioId: item['bookingId'].toString(),
            startDate: item['arrivalDate'] ?? '',
            endDate: item['departureDate'] ?? '',
            nights: item['nights'] ?? 0,
            roomType: item['roomName'] ?? '',
            adults: item['noOfAdults'] ?? 0,
            totalAmount: (item['totalAmount'] ?? 0).toDouble(),
            balanceAmount: (item['balanceAmount'] ?? 0).toDouble(),
            reservedDate: item['reservedDate'] ?? '',
            reservationType: item['reservationType'] ?? '',
            status: item['status'].toString(),
            businessSource: item['businessSourceName'] ?? '',
            roomNumber: item['roomId'].toString(),
            // dateFilterType: item['IsArrivalDate'] ? 'arrival' : 'reserved',
          );

          if (item['arrivalDate'] == today.toString()) {
            reservationList.value!["today"]!.add(data);
          }
          if (item['arrivalDate'] == getTomorrow(today.toString())) {
            reservationList.value!["tomorrow"]!.add(data);
          }
          reservationList.value!["thisweek"]!.add(data);
        }
        reservationFilteredList.value = reservationList.value;
        reservationList.refresh();
        reservationFilteredList.refresh();
      } else {
        MessageService().error(
          reservationResponse["errors"][0] ?? 'Error getting reservation data!',
        );
      }

      if (statusResponse["isSuccessful"] == true) {
        statusList.value = [];
        final result = statusResponse["result"]["recordSet"];
        for (final item in result) {
          final data = {
            "id": item["roomStatusId"],
            "name": item["name"] ?? '',
            "description": item["description"] ?? '',
            "colorCode": hexToColor(item["colorCode"]),
          };
          statusList.add(data);
        }
      } else {
        MessageService().error(
          statusResponse["errors"][0] ?? 'Error getting status data!',
        );
      }

      if (roomTypeResponse["isSuccessful"]) {
        final result = roomTypeResponse["result"]["recordSet"];
        roomTypes.value = [];
        roomTypes.add(FilterDropdownData(id: -1, name: "All"));
        for (final item in result) {
          final data = FilterDropdownData.fromJson({
            "id": item["roomTypeId"],
            "name": item["name"],
          });
          roomTypes.add(data);
        }
         roomTypes.refresh();
      } else {
        MessageService().error(
          roomTypeResponse["errors"][0] ?? 'Error getting room details!',
        );
      }

      if (reservationTypeResponse["isSuccessful"]) {
        final result = reservationTypeResponse["result"]["recordSet"];
        reservationTypes.value = [];
        reservationTypes.add(FilterDropdownData(id: -1, name: "All"));
        for (final item in result) {
          final data = FilterDropdownData.fromJson({
            "id": item["reservationTypeId"],
            "name": item["name"],
          });
          reservationTypes.add(data);
        }
         reservationTypes.refresh();
      } else {
        MessageService().error(
          reservationTypeResponse["errors"][0] ??
              'Error getting reservation types!',
        );
      }

      if (roomStatusResponse["isSuccessful"]) {
        statuses.value = [];
        final result = roomStatusResponse["result"]["recordSet"];
         statuses.add(FilterDropdownData(id: -1, name: "All"));
        for (final item in result) {
          final data = FilterDropdownData.fromJson({
            "id": item["roomStatusId"],
            "name": item["name"],
          });
          statuses.add(data);
        }
       
         statuses.refresh();
      } else {
        MessageService().error(
          roomStatusResponse["errors"][0] ?? 'Error getting room Status!',
        );
      }

      if (businessSourcesResponse["isSuccessful"]) {
        final result = businessSourcesResponse["result"]["recordSet"];
        businessSources.value = [];
          businessSources.add(FilterDropdownData(id: -1, name: "All"));
        for (final item in result) {
          final data = FilterDropdownData.fromJson({
            "id": item["businessSourceId"],
            "name": item["name"],
          });
          businessSources.add(data);
        }
         businessSources.refresh();
      } else {
        MessageService().error(
          businessSourcesResponse["errors"][0] ??
              'Error getting business sources!',
        );
      }
    } catch (e) {
      MessageService().error('Error getting reservation list: $e');
      throw Exception('Error getting reservation list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool isUnAssign(GuestItem guestItem) {
    int status = int.tryParse(guestItem.status.toString()) ?? 0;
    bool isAssign = guestItem.roomId == 0;
    bool isUnAssignRoom = !isAssign && status != 2 && status != 3;
    return isUnAssignRoom;
  }

  void applyReservationFilters(Map<String, dynamic> filters) {
    var fullData = reservationList.value ?? {};
    receivedFilters.value = filters;

    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];
    String? roomType = filters['roomType'];
    String? reservationType = filters['reservationType'];
    String dateFilterType = filters['dateFilterType'] ?? 'reserved';
    String? status = filters['status'];
    String? businessSource = filters['businessSource'];
    bool showUnassignedRooms = filters['showUnassignedRooms'] ?? false;
    bool showFailedBookings = filters['showFailedBookings'] ?? false;
    String guestName = (filters['guestName'] ?? '').toLowerCase();
    String reservationNumber = filters['reservationNumber'] ?? '';
    String cancellationNumber = filters['cancellationNumber'] ?? '';
    String voucherNumber = filters['voucherNumber'] ?? '';

    Map<String, List<GuestItem>> filteredMap = {};
    fullData.forEach((tab, items) {
      filteredMap[tab] = items.where((item) {
        bool match = true;
        bool isUnassign = isUnAssign(item);

        if (startDate != null && endDate != null) {
          final itemStart = _parseDate(item.startDate);
          final itemEnd = _parseDate(item.endDate);
          if (itemStart.isBefore(startDate) || itemEnd.isAfter(endDate)) {
            match = false;
          }
        } else if (startDate != null) {
          final itemStart = _parseDate(item.startDate);
          if (itemStart != startDate) match = false;
        } else if (endDate != null) {
          final itemEnd = _parseDate(item.endDate);
          if (itemEnd != endDate) match = false;
        }

        // if (roomType != null && roomType.isNotEmpty) {
        //   if (item.roomType != roomType) match = false;
        // }

        // if (reservationType != null && reservationType.isNotEmpty) {
        //   if (item.reservationType != reservationType) match = false;
        // }

        if (status != null && status.isNotEmpty) {
          if (item.status != status) match = false;
        }

        // if (businessSource != null && businessSource.isNotEmpty) {
        //   if (item.businessSource != businessSource) match = false;
        // }

        if (guestName.isNotEmpty) {
          if (!item.guestName.toLowerCase().contains(guestName.toLowerCase())) {
            match = false;
          }
        }

        if (reservationNumber.isNotEmpty) {
          if (item.resId != reservationNumber) match = false;
        }

        // if (cancellationNumber.isNotEmpty) {
        //   if ((item.cancellationNumber ?? '') != cancellationNumber)
        //     match = false;
        // }

        // if (voucherNumber.isNotEmpty) {
        //   if ((item.voucherNumber ?? '') != voucherNumber) match = false;
        // }

        if (showUnassignedRooms) {
          if (isUnassign) {
            match = false;
          }
        }

        // if (showFailedBookings) {
        //   if (!(item.status == 'Failed' || item.status == 'Incomplete')) {
        //     match = false;
        //   }
        // }

        return match;
      }).toList();
    });

    reservationFilteredList.value = filteredMap;
    reservationFilteredList.refresh();
  }

  DateTime _parseDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
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

  Future<void> getAllGuestData(GuestItem item) async {
    try {
      isBottomSheetDataLoading.value = true;

      final bookingRoomId = int.parse(item.bookingRoomId);
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
          remainingNights:
              result["bookingRoom"]["noOfNights"] ??
              0, ////change remaining nights logic
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
          response["errors"][0] ?? 'Error getting guest data!',
        );
      }
    } catch (e) {
      MessageService().error('Error getting all Guest data: $e');
      throw Exception('Error getting all Guest data: $e');
    } finally {
      isBottomSheetDataLoading.value = false;
    }
  }

  String getFirstTenCharacters(String? str) {
    if (str == null || str.isEmpty) {
      return '';
    }
    return str.length > 10 ? str.substring(0, 10) : str;
  }

  Future<Map<String, dynamic>> getCancelReservationData(GuestItem item) async {
    try {
      Map<String, dynamic> guestData = {};
      final response = await _reservationListService.getCancellationReasons();
      if (response["isSuccessful"] == true) {
        final reasonList = [];
        final result = response["result"];
        for (final item in result) {
          reasonList.add({"id": item["reasonId"], "name": item["name"]});
        }
        guestData["reasons"] = reasonList;
      }
      return guestData;
    } catch (e) {
      throw Exception('Error getting all Guest data: $e');
    }
  }

  Future<Map<String, dynamic>> getNoShowReservationData(GuestItem item) async {
    try {
      Map<String, dynamic> data = {};
      final response = await _reservationListService.getNoShowReasons();

      if (response["isSuccessful"] == true) {
        List<Map<String, dynamic>> reasonList = [];
        final result = response["result"];
        for (final item in result) {
          reasonList.add({"id": item["reasonId"], "name": item["name"]});
        }
        data["reasons"] = reasonList;
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error getting noshow data!',
        );
      }
      return data;
    } catch (e) {
      MessageService().error('Error getting all Guest data: $e');
      throw Exception('Error getting all Guest data: $e');
    }
  }

  Future<void> unassignRoom(GuestItem item) async {
    try {
      final userId = await LocalStorageManager.getUserId();
      final request = {
        "BookingRoomList": [
          {"BookingRoomId": int.tryParse(item.bookingRoomId)},
        ],
        "IsUnAssignRoom": true,
        "currentUserId": int.tryParse(userId),
      };
      final response = await _reservationListService.updateBooking(request);
      if (response["isSuccessful"] == true) {
        final msg = response["message"].isNotEmpty
            ? response["message"]
            : 'Room unassigned successfully!';
        MessageService().success(msg);
      } else {
        final msg = response["errors"][0] ?? 'Room unassign failed!';
        MessageService().error(msg);
      }
    } catch (e) {
      MessageService().error('Error unassign request: $e');
      throw Exception('Error unassign request: $e');
    }
  }
}
