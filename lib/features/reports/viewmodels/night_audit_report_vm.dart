import 'package:get/Get.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/services/apiServices/reports_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:intl/intl.dart';

class NightAuditReportVm extends GetxController {
  final ReportsService _reportsService;
  var isLoading = true.obs;
  final hotelList = <HotelItem>[].obs;
  final currencyList = <CurrencyItem>[].obs;
  final systemWorkingDate = DateTime.now().obs;

  var checkedOutRecodes = <Map<String, dynamic>>[].obs;
  var complimentaryRecodes = <Map<String, dynamic>>[].obs;
  var roomStatusRecodes = <Map<String, dynamic>>[].obs;
  var dailySalesRecodes = <Map<String, dynamic>>[].obs;
  var miscellaneousRecodes = <Map<String, dynamic>>[].obs;
  var paxAnalysisRecodes = <Map<String, dynamic>>[].obs;
  var paxStatusRecodes = <Map<String, dynamic>>[].obs;
  var receiptDetailsRecodes = <Map<String, dynamic>>[].obs;
  var receiptSummaryPayModeWiseRecodes = <Map<String, dynamic>>[].obs;
  var receiptSummaryUserWiseRecodes = <Map<String, dynamic>>[].obs;
  var roomCharges = <Map<String, dynamic>>[].obs;

  NightAuditReportVm(this._reportsService);

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      final sysDate = await LocalStorageManager.getSystemDate();
      systemWorkingDate.value = DateTime.parse(sysDate);

      final response = await Future.wait([
        _reportsService.getAllHotel(),
        _reportsService.getCurrencies(),
      ]);

      final hotelResponse = response[0];
      final currencyResponse = response[1];

      if (hotelResponse["isSuccessful"] == true) {
        final result = hotelResponse["result"] as List;
        hotelList.value = result
            .map(
              (item) => HotelItem(
                hotelId: item["hotelId"],
                hotelName: item["hotelName"],
              ),
            )
            .toList();
      } else {
        MessageService().error(
          hotelResponse["error"][0] ?? 'Error gettings Hotels',
        );
      }

      if (currencyResponse["isSuccessful"] == true) {
        final result = currencyResponse["result"]["recordSet"] as List;
        currencyList.value = result
            .map(
              (item) => CurrencyItem(
                currencyId: item["currencyId"],
                code: item["code"],
                symbol: item["symbol"]
              ),
            )
            .toList();
      } else {
        MessageService().error(
          currencyResponse["error"][0] ?? 'Error gettings Hotels',
        );
      }
    } catch (e) {
      MessageService().error('Error loading initial Data: $e');
      throw Exception('Error loading initial Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNightAuditReport(DateTime date, int hotel, int currency) async {
    try {
      isLoading.value = true;
      final payload = {
        "Currency": currency,
        "ReportId": 163,
        "SelectedDate": DateFormat('yyyy-MM-dd').format(date).toString(),
        "hotelIdsList": hotel.toString(),
      };
      final response = await _reportsService.getNightAuditReport(payload);
      if (response["isSuccessful"] == true) {
        final result = response["result"]["reportData"];

        roomCharges.value =
            (result['roomCharges'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        checkedOutRecodes.value =
            (result['checkedOutRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        complimentaryRecodes.value =
            (result['complimentaryRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        dailySalesRecodes.value =
            (result['dailySalesRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        miscellaneousRecodes.value =
            (result['miscellaneousRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        paxAnalysisRecodes.value =
            (result['paxAnalysisRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        paxStatusRecodes.value =
            (result['paxStatusRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        receiptDetailsRecodes.value =
            (result['receiptDetailsRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        receiptSummaryPayModeWiseRecodes.value =
            (result['receiptSummaryPayModeWiseRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        receiptSummaryUserWiseRecodes.value =
            (result['receiptSummaryUserWiseRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        roomStatusRecodes.value =
            (result['roomStatusRecodes'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
      } else {
        MessageService().error(
          response["error"][0] ?? 'Error gettings night audit report data',
        );
      }
    } catch (e) {
      MessageService().error('Error gettings night audit report data $e');
      throw Exception('Error gettings night audit report data');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> safeList(Map<String, dynamic> item, String key) {
    return (item[key] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];
  }
}
