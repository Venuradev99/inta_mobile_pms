import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_search_request_model.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/loading_controller.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class ReservationListVm extends GetxController {
  final ReservationListService _reservationListService =
      ReservationListService();
  final loadingController = Get.find<LoadingController>();

  final reservationList = Rx<Map<String, List<GuestItem>>?>(null);
  final reservationFilteredList = Rx<Map<String, List<GuestItem>>?>(null);
  final receivedFilters = Rx<Map<String, dynamic>?>(null);

  ReservationListVm();

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
      loadingController.show();
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

      final response = await _reservationListService.getAllReservationList(
        body,
      );

      if (response["isSuccessful"] == true) {
        final List<dynamic> result = response["result"];

        reservationList.value = {'today': [], 'tomorrow': [], 'thisweek': []};

        for (final item in result) {
          final data = GuestItem(
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

          // reservationList.value!["today"]!.add(
          //   GuestItem(
          //     guestName: 'Mr. Ethan Harris',
          //     resId: 'BH3500',
          //     folioId: '3501',
          //     startDate: 'Sep 23',
          //     endDate: 'Sep 25',
          //     nights: 2,
          //     roomType: 'Double Room',
          //     adults: 2,
          //     totalAmount: 220.00,
          //     balanceAmount: 220.00,
          //     reservedDate: 'Sep 23',
          //     reservationType: 'Standard',
          //     status: 'Pending',
          //     businessSource: 'Direct',
          //     roomNumber: '101',
          //   ),
          // );
        }
        reservationFilteredList.value = reservationList.value;
        reservationList.refresh();
        reservationFilteredList.refresh();
      }
    } catch (e) {
      throw Exception('Error getting reservation list: $e');
    } finally{
      loadingController.hide();
    }
  }

  void applyReservationFilters(Map<String, dynamic> filters) {
    var fullData = reservationList.value ?? {};

    receivedFilters.value = filters;
    print('receivedFilters$receivedFilters');

    // Extract filters
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

        // if (showFailedBookings) {
        //   if (!(item.status == 'Failed' || item.status == 'Incomplete')) {
        //     match = false;
        //   }
        // }

        return match;
      }).toList();
    });

    print('filteredMap$filteredMap');
    reservationFilteredList.value = filteredMap;
    reservationFilteredList.refresh();
  }

  DateTime _parseDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
