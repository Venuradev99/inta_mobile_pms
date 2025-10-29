import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/reservations/models/amend_stay_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/amend_stay_save_data.dart';
import 'package:inta_mobile_pms/features/reservations/models/folio_payment_details_response.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class AmendStayVm extends GetxController {
  final ReservationListService _reservationListService;

  final Rxn<AmendStayResponse> amendStayData = Rxn<AmendStayResponse>();
  final Rxn<FolioPaymentDetailsResponse> folioDetails =
      Rxn<FolioPaymentDetailsResponse>();

  AmendStayVm(this._reservationListService);

  Future<void> loadAmendStayData(
    int folioId,
    int roomId,
    int bookingRoomId,
    String amendCheckinDate,
  ) async {
    try {
      final response = await Future.wait([
        _reservationListService.getAmendStayData(
          roomId,
          bookingRoomId,
          amendCheckinDate,
        ),
        _reservationListService.getFolioPayments(folioId),
      ]);
      final amendStayResponse = response[0];
      final folioDetailsResponse = response[1];

      if (amendStayResponse["isSuccessful"] == true) {
        final result = amendStayResponse["result"];
        amendStayData.value = AmendStayResponse(
          bookingRoomId: result["bookingRoomId"],
          bookingId: result["bookingId"],
          reservationNo: result["reservationNo"],
          roomId: result["roomId"],
          roomTypeId: result["roomTypeId"],
          rateTypeId: result["rateTypeId"],
          roomName: result["roomName"],
          bookingRoomOwnerId: result["bookingRoomOwnerId"],
          bookingGuest: result["bookingGuest"],
          bookingGuestWithTitle: result["bookingGuestWithTitle"],
          pax: result["pax"],
          arrivalDate: result["arrivalDate"],
          noOfAdults: result["noOfAdults"],
          noOfChildren: result["noOfChildren"],
          arrivalTime: result["arrivalTime"],
          departureDate: result["departureDate"],
          departureTime: result["departureTime"],
          rateOffered: result["rateOffered"],
          recordLockedBy: result["recordLockedBy"],
          status: result["status"],
          hotelId: result["hotelId"],
        );
      }else{
          MessageService().error(amendStayResponse["errors"][0] ?? 'Error getting work orders!');
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
      }else{
         MessageService().error(folioDetailsResponse["errors"][0] ?? 'Error getting folio details!');
      }
    } catch (e) {
       MessageService().error('Error while loading Amend Stay data: $e');
      throw Exception('Error while loading Amend Stay data: $e');
    }
  }

  Future<void> saveAmendStay(
   AmendStaySaveData saveData,
  ) async {
    try {
      final userId = await LocalStorageManager.getUserId();
      Map<String, Object> payload = {
        "IsAssignRoom": true,
        "bookingRoomList": [
          {
            "applyToWholeStay": saveData.applyToWholeStay,
            "arrivalDate": saveData.arrivalDate,
            "bookingRoomId": saveData.bookingRoomId,
            "currencyId": saveData.currencyId,
            "departureDate": saveData.departureDate,
            "isManualRate": saveData.isManualRate,
            "isOverrideRate": saveData.isOverrideRate,
            "isTaxInclusive": saveData.isTaxInclusive,
            "manualRate": saveData.manualRate,
          },
        ],
        "currentUserId": int.tryParse(userId)!,
        "isAmendStay": true,
      };
      final response = await _reservationListService.updateBooking(payload);
     if (response["isSuccessful"] == true) {
       MessageService().success(response["message"] ?? 'Amend stayed Successfully!');
    } else {
      String msg = response["errors"][0] ?? 'Error while amend Staying!';
      MessageService().error(msg);
    }
    } catch (e) {
       MessageService().error('Error while Assigning room: $e');
      throw Exception('Error while Assigning room: $e');
    }
  }
}
