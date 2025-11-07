import 'package:get/Get.dart';
import 'package:inta_mobile_pms/features/reports/models/night_audit_item.dart';
import 'package:inta_mobile_pms/services/apiServices/reports_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class NightAuditReportVm extends GetxController {
  final ReportsService _reportsService;
  var isLoading = true.obs;
  final nightAuditList = <NightAuditItem>[].obs;

  NightAuditReportVm(this._reportsService);

  Future<void> loadAuditTrails() async {
    try {
      isLoading.value = true;
      final response = await _reportsService.getNightAudits();
      if (response["isSuccessful"] == true) {
        final result = response["result"] as List;

        nightAuditList.clear();

        for (final item in result) {
          nightAuditList.add(
            NightAuditItem(
              description: item["description"] ?? "",
              sysDateCreated: item["sys_DateCreated"] ?? "",
              transactionType: item["transactionType"] ?? "",
              userId: item["userId"] ?? 0,
              userName: item["userName"] ?? "",
              transactionTypeName: item["transactionTypeName"] ?? "",
              hotelId: item["hotelId"] ?? 0,
            ),
          );
        }
      }else{
        MessageService().error(response["error"][0] ?? 'Error gettings Audit Trails');
      }
    } catch (e) {
      MessageService().error('Error getting Night Audits: $e');
      throw Exception('Error getting Night Audits');
    } finally {
      isLoading.value = false;
    }
  }
}
