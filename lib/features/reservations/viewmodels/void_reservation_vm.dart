import 'package:get/get.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class VoidReservationVm extends GetxController {
  final ReservationService _reservationListService;

  VoidReservationVm(this._reservationListService);

  Future<void> voidReservation(Map<String, dynamic> item) async {
    try {
      final request = {
        "NewBookingOwnerBookingRoomId": 0,
        "bookingRoomList": [
          {
            "bookingRoomId": int.tryParse(item["bookingRoomId"]),
            "reason": item["reason"],
          },
        ],
        "transactionType": 8,
      };
      final response = await _reservationListService.updateBookingApi(request);
      if (response["isSuccessful"] == true) {
        final msg = response["message"].isNotEmpty
            ? response["message"]
            : 'Reservation void successfully!';
        MessageService().success(msg);
      } else {
        final msg = response["errors"][0];
        MessageService().error(msg);
      }
       NavigationService().back();
    } catch (e) {
      MessageService().success('Error void room request: $e');
      throw Exception('Error void room request: $e');
    }
  }
}
