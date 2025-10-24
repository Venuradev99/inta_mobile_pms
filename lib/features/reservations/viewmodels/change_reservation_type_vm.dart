import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/reservations/models/change_reservation_payload.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/change_reservation_type_wgt.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class ChangeReservationTypeVm extends GetxController {
  final ReservationListService _reservationListService;

  final reservationTypes = <ReservationTypeItem>[].obs;

  ChangeReservationTypeVm(this._reservationListService);

  Future<void> loadAllReservationTypes() async {
    try {
      final response = await _reservationListService.getAllreservationTypes();
      if (response["isSuccessful"] == true) {
        final result = List<Map<String, dynamic>>.from(
          response["result"]["recordSet"] as List,
        );
        reservationTypes.value = result
            .map(
              (item) => ReservationTypeItem(
                id: item["reservationTypeId"],
                color: hexToColor(item["colorCode"]),
                description: item["description"],
                icon: Icons.hotel,
                type: item["name"],
              ),
            )
            .toList();
      }
    } catch (e) {
      throw Exception('Error while loading reservation types: $e');
    }
  }

  Color hexToColor(String hexCode) {
    if (hexCode == '' || hexCode.isEmpty) {
      return Colors.grey;
    }

    try {
      String hex = hexCode.replaceAll('#', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      if (hex.length != 8) {
        throw FormatException("Hex color must be 6 or 8 characters long.");
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Future<void> saveChangeReservationType(
    int newReservationTypeId,
    GuestItem guestItem,
  ) async {
    try {
      String todayWorkingDate = await LocalStorageManager.getSystemDate();
      final payload = {
        "applyToAll": false,
        "billingInformation": {
          "billingRateTypeId": guestItem.billingRateTypeId,
          "grCardNumber": guestItem.grCardNumber,
          "billingInstructionId": guestItem.billingInstructionId,
          "isTaxInclusiveRate": guestItem.isTaxInclusiveRate,
          "taxRegistrationDate": guestItem.taxRegistrationDate,
          "billNumber": guestItem.billNumber,
          "isCash": guestItem.isCash,
          "isComplementory": guestItem.isComplementory,
          "manualRate": guestItem.manualRate,
          "paymentMode": guestItem.paymentMode,
          "paymentModeCategory": guestItem.paymentModeCategory,
          "rateSourceId": guestItem.rateSourceId,
          "releaseChargeAmountPercentage":
              guestItem.releaseChargeAmountPercentage, /// release charge percentage
          "releaseDate": todayWorkingDate,  //// release Date
          "maxDep": guestItem.maxDep,
          "maxNights": guestItem.maxNights,
          "minArr": guestItem.minArr,
          "pax": guestItem.pax,
          "vehiclePlate": guestItem.vehiclePlate,
          "voucherNo": guestItem.voucherNo,
          "resDate": guestItem.resDate,
          "isToBeReleased": guestItem.isToBeReleased,
        },
        "bookingId": guestItem.bookingId,
        "bookingRoomId": int.tryParse(guestItem.bookingRoomId),
        "companyOther": {
          "businessCategoryId": guestItem.businessCategoryId,
          "businessSourceId": guestItem.businessSourceId,
          "marketId": guestItem.marketId,
          "planId": guestItem.travelAgentCommisionPlanId,
          "planValue": guestItem.travelAgentCommisionPlanValue,
          "reservationType":newReservationTypeId,
        },
      };

      final response = await _reservationListService.saveOtherInformation(
        payload,
      );
      Get.back();
      if (response["isSuccessful"] == true) {
        String msg =
            response["message"] ?? 'Changed Reservation Type Successfully!';
       MessageHelper.success(msg);
      } else {
        String msg =
            response["errors"][0] ?? 'Error while changing reservation type!';
        MessageHelper.error(msg);
      }
    } catch (e) {
      MessageHelper.error('Error while changing reservation!:$e');
      throw Exception('Error while changing reservation!:$e');
    }
  }
}
