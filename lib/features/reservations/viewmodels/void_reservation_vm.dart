import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';

class VoidReservationVm extends GetxController {
  final ReservationListService _reservationListService;

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
      final response = await _reservationListService.updateBooking(request);
      if (response["isSuccessful"] == true) {
        final msg = response["message"].isNotEmpty
            ? response["message"]
            : 'Reservation void successfully!';
        MessageHelper.success(msg);
      } else {
        final msg = response["errors"][0];
        MessageHelper.error(msg);
      }
      Get.back();
    } catch (e) {
      MessageHelper.success('Error void room request: $e');
      throw Exception('Error void room request: $e');
    }
  }
}
