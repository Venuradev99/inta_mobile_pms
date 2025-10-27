import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class CancelReservationVm extends GetxController {
  final ReservationListService _reservationListService;

  CancelReservationVm(this._reservationListService);

  Future<void> cancelReservation(Map<String, dynamic> item) async {
    try {
      final currencyId = 1;
      final request = {
        "BookingRoomList": [
          {
            "BookingRoomId": int.tryParse(item["bookingRoomId"]),
            "CurrencyId": currencyId,
            "Rate": double.tryParse(item["rate"]?.toString() ?? '0.0') ?? 0.0,
            "Reason": item["reason"],
            "comment": item["comment"] ?? '',
            "isTaxInclusive": item["isTaxInclusive"],
          },
        ],
        "NewBookingOwnerBookingRoomId": 0,
        "TransactionType": 5,
      };
      final response = await _reservationListService.updateBooking(request);
      if (response["isSuccessful"] == true) {
        final msg = response["message"].isNotEmpty
            ? response["message"]
            : 'Reservation Cancelled successfully!';
        MessageService().success(msg);
         NavigationService().back();
      } else {
        final msg = response["errors"][0];
        MessageService().error(msg);
      }
    } catch (e) {
        MessageService().error('Error Cancelling request: $e');
      throw Exception('Error Cancelling request: $e');
    }
  }
}
