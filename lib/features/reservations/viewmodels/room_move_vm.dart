import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/reservations/models/folio_payment_details_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/room_move_save_data.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class RoomMoveVm extends GetxController {
  final ReservationListService _reservationListService;
  var roomTypes = <Map<String, dynamic>>[].obs;
  var availableRooms = <Map<String, dynamic>>[].obs;
  final Rxn<FolioPaymentDetailsResponse> folioDetails =
      Rxn<FolioPaymentDetailsResponse>();
  RxString selectedRoomType = ''.obs;

  RoomMoveVm(this._reservationListService);

  Future<void> loadInitialData(int folioId) async {
    try {
      final response = await Future.wait([
        _reservationListService.getAllRoomTypes(),
        _reservationListService.getFolioPayments(folioId),
      ]);

      final roomTypeResponse = response[0];
      final folioDetailsResponse = response[1];

      if (roomTypeResponse["isSuccessful"] == true) {
        final result = List<Map<String, dynamic>>.from(
          roomTypeResponse["result"]["recordSet"] as List,
        );
        roomTypes.value = result
            .map((item) => {"id": item["roomTypeId"], "name": item["name"]})
            .toList();
      } else {
        MessageService().error(
          roomTypeResponse["errors"][0] ?? 'Error getting room type data!',
        );
      }

      if (folioDetailsResponse["isSuccessful"] == true) {
        final result = folioDetailsResponse["result"];
        folioDetails.value = FolioPaymentDetailsResponse(
          chargeList: result["chargeList"],
          grossAmount: result["grossAmount"],
          discountId: result["discountId"],
          serviceChargeAmount: result["serviceChargeAmount"],
          discountAmount: result["discountAmount"],
          discountRate: result["discountRate"],
          lineDiscountAmount: result["lineDiscountAmount"],
          taxAmount: result["taxAmount"],
          totalAmount: result["totalAmount"],
          paidAmount: result["paidAmount"],
          balanceAmount: result["balanceAmount"],
          transferAmount: result["transferAmount"],
          adjustmentAmount: result["adjustmentAmount"],
          folioLateCheckOutAmount: result["folioLateCheckOutAmount"],
          roomCharges: result["roomCharges"],
          extraCharges: result["extraCharges"],
          isServiceChargeExempted: result["isServiceChargeExempted"],
          isTaxExempted: result["isTaxExempted"],
          visibleCurrencyId: result["visibleCurrencyId"],
          visibleCurrencyCode: result["visibleCurrencyCode"],
          conversionRate: result["conversionRate"],
        );
      } else {
        MessageService().error(
          folioDetailsResponse["errors"][0] ?? 'Error getting folio data!',
        );
      }
    } catch (e) {
      throw Exception('Error while loading room types:$e');
    }
  }

  Future<void> loadAvailableRooms(String roomTypeId) async {
    try {
      Map<String, dynamic> request = {
        "RoomList": [4],
        "adult": 0,
        "arrivalDate": "2025-10-22T13:00:00",
        "child": 0,
        "departureDate": "2025-10-24T17:00:00",
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
        MessageService().error(
          response["errors"][0] ?? 'Error getting available rooms!',
        );
      }
    } catch (e) {
      MessageService().error('Error while loading available rooms: $e');
      throw Exception('Error while loading available rooms: $e');
    } finally {}
  }

  Future<void> saveRoomMove(RoomMoveSaveData saveData) async {
    try {
      final userId = await LocalStorageManager.getUserId();
      final saveRoomMoveRequest = {
        "IsRoomMove": true,
        "bookingRoomList": [
          {
            "bookingRoomId": saveData.bookingRoomId,
            "currencyId": saveData.currencyId,
            "isManualRate": saveData.isManualRate,
            "isOverrideRate": saveData.isOverrideRate,
            "isTaxInclusive": saveData.isTaxInclusive,
            "manualRate": saveData.manualRate,
            "roomId": saveData.roomId,
            "roomTypeId": saveData.roomTypeId,
          },
        ],
        "currentUserId": int.tryParse(userId),
      };
      final response = await _reservationListService.updateBooking(
        saveRoomMoveRequest,
      );
      if (response["isSuccessful"] == true) {
        final selectedRoomType = getType(saveData.roomTypeId);
        final selectedRoom = getRoom(saveData.roomId);
        String msg =
            'Room moved successfully to $selectedRoomType - $selectedRoom';
        MessageService().success(msg);
         NavigationService().back();
      } else {
        String msg = response["errors"][0] ?? "Error while Saving!";
        MessageService().success(msg);
      }
    } catch (e) {
       MessageService().success('Error saving Room Move: $e');
      throw Exception('Error saving Room Move: $e');
    }
  }

  String getType(int typeId) {
    final item = roomTypes.firstWhere((item) => item["id"] == typeId);
    return item["name"];
  }

  String getRoom(int roomId) {
    final item = availableRooms.firstWhere((item) => item["id"] == roomId);
    return item["name"];
  }
}
