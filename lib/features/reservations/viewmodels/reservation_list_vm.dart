import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_search_request_model.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';

class ReservationListVm extends GetxController {
  final ReservationListService _reservationListService =
      ReservationListService();

  final reservationList = Rx<Map<String, List<GuestItem>>?>(null);

  ReservationListVm();

  Future<void> getReservationsMap() async {
    try {
      final body = ReservationSearchRequest(
        businessSourceId: 0,
        exceptCancelled: false,
        fromDate: "2025-10-02",
        isArrivalDate: true,
        reservationTypeId: 0,
        roomId: 0,
        roomTypeId: 0,
        searchByName: "",
        searchType: 1,
        status: 0,
        toDate: "2025-10-08",
        businessCategoryId: 0,
      ).toJson();

      final response = await _reservationListService.getAllReservationList(
        body,
      );

      if (response["isSuccessful"] == true) {
        final List<dynamic> result = response["result"];

        reservationList.value = {'today': [], 'tomorrow': [], 'this week': []};

        for (final item in result) {
          final todayData = GuestItem(
            guestName: item['bookingGuestWithTitle'] ?? '',
            resId: item['reservationNo'] ?? '',
            folioId: item['bookingId'].toString() ,
            startDate: item['arrivalDate'] ?? '',
            endDate: item['departureDate'] ?? '',
            nights: item['nights'] ?? 0,
            roomType: item['roomName'] ?? '',
            adults: item['noOfAdults'] ?? 0,
            totalAmount: (item['totalAmount'] ?? 0).toDouble(),
            balanceAmount: (item['balanceAmount'] ?? 0).toDouble(),
            reservedDate: item['reservedDate'] ?? '',
            reservationType: item['reservationType'] ?? '',
            status: item['status'].toString() ,
            businessSource: item['businessSourceName'] ?? '',
            roomNumber: item['roomId'].toString(),
          );

          reservationList.value!["today"]!.add(todayData);

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

        reservationList.refresh();
      }
    } catch (e) {
      print('get Reservation err: $e');
    }
  }
}
