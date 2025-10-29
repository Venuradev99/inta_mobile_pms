import 'package:get/get.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class NoShowReservationVm extends GetxController {
  final ReservationListService _reservationListService;

  NoShowReservationVm(this._reservationListService);

  Future<void> noShowReservation(Map<String, dynamic> item) async {
    try {
      final request = {
        "BookingRoomList": [
          {
            "bookingRoomId": int.tryParse(item["bookingRoomId"]),
            "comment": item["comment"] ?? '',
            "isTaxInclusive": item["isTaxInclusive"],
            "rate": double.tryParse(item["rate"]?.toString() ?? '0.0') ?? 0.0,
            "reason": item["reason"],
          },
        ],
        "NewBookingOwnerBookingRoomId": 0,
        "transactionType": 7,
      };
      final response = await _reservationListService.updateBooking(request);
      if (response["isSuccessful"] == true) {
        final msg = response["message"].isNotEmpty
            ? response["message"]
            : 'Reservation Cancelled successfully!';
        MessageService().success(msg);
      } else {
        final msg = response["errors"][0];
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error No Showing request: $e');
    }
  }
}
