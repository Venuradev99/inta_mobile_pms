import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class AssignRoomsVm extends GetxController {
  final ReservationListService _reservationListService;

  var roomTypes = <Map<String, dynamic>>[].obs;
  var availableRooms = <Map<String, dynamic>>[].obs;

  AssignRoomsVm(this._reservationListService);

  Future<void> loadInitialData(GuestItem guestItem) async {
    try {
      final response = await _reservationListService.getAllRoomTypes();

      if (response["isSuccessful"] == true) {
        final result = List<Map<String, dynamic>>.from(
          response["result"]["recordSet"] as List,
        );
        roomTypes.value = result
            .map((item) => {"id": item["roomTypeId"], "name": item["name"]})
            .toList();

        final selectedItem = roomTypes.firstWhere(
          (item) => item["name"] == guestItem.roomType,
        );
        await loadAvailableRooms(selectedItem["id"].toString(), guestItem);
      } else {
        MessageHelper.error(
          response["errors"][0] ?? 'Error loading room types!',
        );
      }
    } catch (e) {
      MessageHelper.error('Error loading room types!:$e');
      throw Exception('Error while loading room types:$e');
    }
  }

  Future<void> loadAvailableRooms(
    String roomTypeId,
    GuestItem guestItem,
  ) async {
    try {
      Map<String, dynamic> request = {
        "RoomList": [],
        "adult": guestItem.adults,
        "arrivalDate": guestItem.startDate,
        "child": guestItem.children,
        "departureDate": guestItem.endDate,
        "roomType": int.tryParse(roomTypeId),
      };
      final response = await _reservationListService.getAvailableRooms(request);
      if (response["isSuccessful"] == true) {
        final availableRoomsData = List<Map<String, dynamic>>.from(
          response["result"]["availableRooms"] as List,
        );

        availableRooms.value = availableRoomsData
            .map((item) => {"id": item["roomId"], "name": item["name"]})
            .toList();
      } else {
        MessageHelper.error(
          response["errors"][0] ?? 'Error loading available rooms!',
        );
      }
    } catch (e) {
      MessageHelper.error('Error loading available rooms: $e');
      throw Exception('Error while loading available rooms: $e');
    } finally {}
  }

  Future<void> assignRoom(Map<String, dynamic> saveData) async {
    try {
      final userId = await LocalStorageManager.getUserId();
      Map<String, Object> payload = {
        "IsAssignRoom": true,
        "bookingRoomList": [
          {
            "BookingRoomId": int.tryParse(saveData["BookingRoomId"]),
            "RoomId": int.tryParse(saveData["RoomId"]),
            "arrivalDate": saveData["arrivalDate"],
            "departureDate": saveData["departureDate"],
          },
        ],
        "currentUserId": int.tryParse(userId)!,
      };
      final response = await _reservationListService.updateBooking(payload);
      if (response["isSuccessful"] == true) {
        Get.back();
        MessageHelper.success(response["message"] ?? 'Room assigned successfully!');
      } else {
        MessageHelper.error(response["errors"][0] ?? 'Error while assigning room!');
      }
    } catch (e) {
      MessageHelper.error('Error while Assigning room: $e');
      throw Exception('Error while Assigning room: $e');
    }
  }
}
