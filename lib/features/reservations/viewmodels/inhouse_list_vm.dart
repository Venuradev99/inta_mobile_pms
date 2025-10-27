import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_search_request_model.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class InhouseListVm extends GetxController {
  final ReservationListService _reservationListService;

  final inhouseList = Rx<List<GuestItem>?>(null);
  final inhouseFilteredList = Rx<List<GuestItem>?>(null);
  final receivedFilters = Rx<Map<String, dynamic>?>(null);
  final isLoading = true.obs;

  InhouseListVm(this._reservationListService);

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

  Future<void> getInhouseMap() async {
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
        searchType: 3,
        status: 0,
        toDate: getToDateForWeek(today.toString()),
        businessCategoryId: 0,
      ).toJson();

      final response = await _reservationListService.getInhousedata(body);

      if (response["isSuccessful"] == true) {
        final List<dynamic> result = response["result"];

        inhouseList.value = [];

        for (final item in result) {
          final data = GuestItem(
            bookingRoomId: item['bookingRoomId'].toString(),
            guestName: item['guestName'] ?? '',
            resId: item['resId'] ?? '',
            folioId: item['folioId'].toString(),
            startDate: item['startDate'] ?? '',
            endDate: item['endDate'] ?? '',
            nights: item['nights'] ?? 0,
            roomType: item['roomType'] ?? '',
            adults: item['adults'] ?? 0,
            totalAmount: (item['totalAmount'] ?? 0).toDouble(),
            balanceAmount: (item['balanceAmount'] ?? 0).toDouble(),
            remainingNights: item['remainingNights'] ?? 0,
            roomNumber: item['roomNumber'] ?? '',
          );

          inhouseList.value!.add(data);
        }
        inhouseFilteredList.value = inhouseList.value;
        inhouseList.refresh();
        inhouseFilteredList.refresh();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error getting inhouse data!',
        );
      }
    } catch (e) {
      MessageService().error('Error getting reservation list: $e');
      throw Exception('Error getting reservation list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyArrivalFilters(Map<String, dynamic> filters) {
    var fullData = inhouseList.value ?? [];

    receivedFilters.value = filters;

    // Extract filters
    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];
    String? roomType = filters['roomType'];
    String? reservationType = filters['reservationType'];
    String dateFilterType = filters['dateFilterType'] ?? 'reserved';
    String? status = filters['status'];
    String? businessSource = filters['businessSource'];
    bool showUnassignedRooms = filters['showUnassignedRooms'] ?? false;
    bool guestCheckedInToday = filters['guestCheckedInToday'] ?? false;
    bool showFailedBookings = filters['showFailedBookings'] ?? false;
    String guestName = (filters['guestName'] ?? '').toLowerCase();
    String reservationNumber = filters['reservationNumber'] ?? '';
    String cancellationNumber = filters['cancellationNumber'] ?? '';
    String voucherNumber = filters['voucherNumber'] ?? '';

    List<GuestItem> filteredMap = [];
    filteredMap = fullData.where((item) {
      bool match = true;

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

      // if (status != null && status.isNotEmpty) {
      //   if (item.status != status) match = false;
      // }

      // if (businessSource != null && businessSource.isNotEmpty) {
      //   if (item.businessSource != businessSource) match = false;
      // }

      if (guestName.isNotEmpty) {
        if (!item.guestName.toLowerCase().contains(guestName.toLowerCase())) {
          match = false;
        }
      }

      // if (reservationNumber.isNotEmpty) {
      //   if (item.resId != reservationNumber) match = false;
      // }

      // if (cancellationNumber.isNotEmpty) {
      //   if ((item.cancellationNumber ?? '') != cancellationNumber)
      //     match = false;
      // }

      // if (voucherNumber.isNotEmpty) {
      //   if ((item.voucherNumber ?? '') != voucherNumber) match = false;
      // }

      // if (showUnassignedRooms) {
      //   if (item.roomNumber != null && item.roomNumber!.isNotEmpty) {
      //     match = false;
      //   }
      // }

      // if (guestCheckedInToday) {
      //   if (item.roomNumber != null && item.roomNumber!.isNotEmpty) {
      //     match = false;
      //   }
      // }

      // if (showFailedBookings) {
      //   if (!(item.status == 'Failed' || item.status == 'Incomplete')) {
      //     match = false;
      //   }
      // }

      return match;
    }).toList();

    inhouseFilteredList.value = filteredMap;
    inhouseFilteredList.refresh();
  }

  DateTime _parseDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
