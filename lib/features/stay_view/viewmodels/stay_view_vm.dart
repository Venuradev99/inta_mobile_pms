import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/stay_view/models/available_rooms.dart';
import 'package:inta_mobile_pms/features/stay_view/models/dayuse_response.dart';
import 'package:inta_mobile_pms/features/stay_view/models/stay_view_status_color.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/apiServices/stay_view_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class StayViewVm extends GetxController {
  final StayViewService _stayViewService;
  final ReservationService _reservationService;

  final statusList = <StayViewStatusColor>[].obs;

  final isLoading = Rx<bool>(true);
  final isAvailableRoomLoading = Rx<bool>(false);
  final isLoadingDayUseList = Rx<bool>(false);

  final isRecordsEmpty = Rx<bool>(false);
  final today = Rxn<DateTime>();
  var roomTypes = <Map<String, dynamic>>[].obs;
  var availableRooms = <AvailableRooms>[].obs;
  final allGuestDetails = Rx<GuestItem?>(null);
  var datUseList = <DayUseResponse>[].obs;

  StayViewVm(this._stayViewService, this._reservationService);

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

  Future loadToday() async {
    try {
      final todaySystemDate = await LocalStorageManager.getSystemDate();
      today.value = DateTime.parse(todaySystemDate);
    } catch (e) {
      throw Exception('Error getting today system date: $e');
    }
  }

  Future<List<AvailableRooms>> loadAvailableRooms(dynamic booking) async {
    try {
      isAvailableRoomLoading.value = true;
      final payload = {
        "RoomList": [],
        "adults": 0,
        "childs": 0,
        "arrivalDate": booking['checkInDate'],
        "departureDate": booking['checkOutDate'],
        "roomType": booking['roomTypeId'],
      };

      final response = await _stayViewService.getAvailableRooms(payload);

      if (response["isSuccessful"] == true) {
        final result = response["result"] as Map<String, dynamic>;
        availableRooms.value = result['availableRooms']
            .map<AvailableRooms>((item) => AvailableRooms.fromJson(item))
            .toList();
        return availableRooms;
      } else {
        final msg = response["errors"][0] ?? 'Error Loading Available Rooms!';
        MessageService().error(msg);
        return [];
      }
    } catch (e) {
      throw Exception('Error loading available rooms: $e');
    } finally {
      isAvailableRoomLoading.value = false;
    }
  }

  Future<void> loadAllDayUseList(Map<String, dynamic> payload) async {
    try {
      isLoadingDayUseList.value = true;
      datUseList.clear();

      final response = await _stayViewService.getDayUseList(payload);

      if (response['isSuccessful'] == true) {
        final List<DayUseResponse> dayUseListTemp = (response['result'] as List)
            .map((item) => DayUseResponse.fromJson(item))
            .toList();

        datUseList.value = dayUseListTemp;
      } else {
        final msg = response["errors"][0] ?? 'Error Loading Available Rooms!';
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error loading day use list: $e');
    } finally {
      isLoadingDayUseList.value = false;
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

  String getFirstTenCharacters(String? str) {
    if (str == null || str.isEmpty) {
      return '';
    }
    return str.length > 10 ? str.substring(0, 10) : str;
  }
}
