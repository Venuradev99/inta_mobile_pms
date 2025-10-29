import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/net_lock_scrn.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class NetLockVm extends GetxController {
  final DashboardService _dashboardService;
  final netlockData = <ReservationData>[].obs;
  final netlockDataFiltered = <ReservationData>[].obs;
  final isLoading = true.obs;

  NetLockVm(this._dashboardService);

  void displayErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      final response = await _dashboardService.getAllLockReservations();
      if (response["isSuccessful"] == true) {
        displayErrorMessage('Error loading netlocks!');
        final result = response["result"] as List;
        netlockData.value = result
            .map(
              (item) => ReservationData(
                bookingRoomId: item["bookingRoomId"] ?? 0,
                guestName: item["bookingGuest"] ?? "",
                roomType: item["roomTypeName"] ?? "",
                roomName: item["roomName"] ?? "",
                user: item["recordLockedUserName"] ?? "",
                reservationNo: item["reservationNo"] ?? "",
              ),
            )
            .toList();
        netlockDataFiltered.value = netlockData;
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error getting lock data!',
        );
      }
    } catch (e) {
      MessageService().error('Error while loading net locks: $e');
      throw Exception('Error while loading net locks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterReservations(String query) {
    if (query.isEmpty) {
      netlockDataFiltered.value = netlockData;
    } else {
      netlockDataFiltered.value = netlockData
          .where(
            (reservation) =>
                reservation.guestName.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                reservation.roomType.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                reservation.reservationNo.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
    // _selectedRows.clear();
    // _selectAll = false;
  }

  Future<void> unlockBooking(Set<int> selectedIndexes) async {
    try {
      List<int> selectedBookingRoomIds = selectedIndexes
          .map((item) => netlockDataFiltered[item].bookingRoomId!)
          .toList();
      final payload = {
        "BookingRoomIds": selectedBookingRoomIds,
        "IsUserConsider": false,
        "Lock": false,
      };
      final response = await _dashboardService.lockBooking(payload);
      if (response["isSuccessful"] == true) {
        MessageService().error(
          response["errors"][0] ??
              '${selectedIndexes.length} reservation${selectedIndexes.length > 1 ? 's' : ''} unlocked and removed',
        );
        await loadInitialData();
      } else {
        MessageService().error(response["errors"][0] ?? 'Error while unlocking!');
      }
    } catch (e) {
      MessageService().error('Error while unlocking: $e');
      throw Exception('Error while unlocking: $e');
    }
  }
}
