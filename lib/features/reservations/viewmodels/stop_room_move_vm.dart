import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';

class StopRoomMoveVm extends GetxController {
  final ReservationListService _reservationListService;

  final reasons = [].obs;

  StopRoomMoveVm(this._reservationListService);

  Future<void> loadInitialData() async {
    try {
      final response = await _reservationListService.getStopRoomMoveReasons();
      if (response["isSuccessful"] == true) {
        final result = List<Map<String, dynamic>>.from(
          response["result"] as List,
        );
        reasons.value = result
            .map((item) => {"id": item["reasonId"], "name": item["name"]})
            .toList();
      } else {
        MessageHelper.error(response["errors"][0] ?? 'Error getting reasons!');
      }
    } catch (e) {
      throw Exception('Error while loading stop moving room reasons: $e');
    }
  }

  Future<void> addNewReason(String name) async {
    try {
      final requestBody = {
        "createdBy": 0,
        "description": "description",
        "deviceId": "",
        "indexId": 0,
        "ipAddress": "112.134.193.58",
        "isBlackListReason": false,
        "lastModifiedBy": 0,
        "name": name,
        "reasonCategoryId": 18,
        "reasonId": 0,
        "shortCode": "",
      };
      final response = await _reservationListService.saveReason(requestBody);
      if (response["isSuccessful"] == true) {
        Get.back();
        String msg = response["message"] ?? 'Stop room move successfully!';
        MessageHelper.success(msg);
      } else {
        String msg = response["errors"][0] ?? 'Error stop room move!';
        MessageHelper.error(msg);
      }
    } catch (e) {
      MessageHelper.success('Error saving reason:$e');
      throw Exception('Error saving reason:$e');
    }
  }

  Future<Map<String, dynamic>> stopMovingRoom(
    String reason,
    String bookingRoomId,
  ) async {
    try {
      final requestBody = {
        "BookingRoomList": [
          {"BookingRoomId": bookingRoomId, "Reason": reason},
        ],
        "IsStopRoomMove": true,
      };
      final response = await _reservationListService.updateBooking(requestBody);
      return response;
    } catch (e) {
      throw Exception("Error while stop moving room: $e");
    }
  }
}
