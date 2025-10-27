import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/reservations/models/audit_trail_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class AuditTrailVm extends GetxController {
  final ReservationListService _reservationListService;

  var auditTrailList = <AuditTrailResponse>[].obs;
  var isLoading = true.obs;

  AuditTrailVm(this._reservationListService);

  Future<List<AuditTrailResponse>> loadAuditTrails(GuestItem guestItem) async {
    try {
      isLoading.value = true;
      final response = await _reservationListService.getAuditTrial(
        guestItem.bookingId!,
        int.tryParse(guestItem.bookingRoomId.toString())!,
        guestItem.masterFolioBookingTransId!,
        guestItem.roomId!,
      );

      if (response["isSuccessful"] == true) {
        final result = response["result"] as List;
        auditTrailList.value = result
            .map(
              (item) => AuditTrailResponse(
                bookingId: item["bookingId"] ?? 0,
                description: item["description"] ?? '',
                folioId: item["folioId"] ?? 0,
                roomId: item["roomId"] ?? 0,
                sysDateCreated: item["sys_DateCreated"] ?? '',
                transactionLog: item["transactionLog"] ?? '',
                transactionType: item["transactionType"] ?? 0,
                userId: item["userId"] ?? 0,
                userName: item["userName"] ?? '',
                transactionTypeName: item["transactionTypeName"] ?? '',
                hotelId: item["hotelId"] ?? 0,
              ),
            )
            .toList();
        return auditTrailList;
      } else {
        final msg = response["errors"][0] ?? 'Error Loading Audit Trails!';
        MessageService().error(msg);
        return [];
      }
    } catch (e) {
      throw Exception('Error loading Audit Trails: $e');
    }finally{
            isLoading.value = false;
    }
  }
}
