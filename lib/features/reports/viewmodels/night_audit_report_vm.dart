import 'package:get/Get.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/features/reports/models/night_audit_models.dart';
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

  var paxStatusTotals = {"adult": 0, "chilren": 0}.obs;
  var paxAnalysisTotals = {"adult": 0, "chilren": 0}.obs;
  var miscTotals = {"amount": 0.0, "quantity": 0}.obs;
  var dailySalesTotals = {
    "adjustment": 0.0,
    "discount": 0.0,
    "extraCharges": 0.0,
    "extraServiceCharges": 0.0,
    "extraTax": 0.0,
    "roomCharges": 0.0,
    "roomServiceCharges": 0.0,
    "roomTax": 0.0,
    "totalSales": 0.0,
  }.obs;
  var checkedOutTotals = {
    "adjust": 0.0,
    "balanceAmount": 0.0,
    "discount": 0.0,
    "extraCharges": 0.0,
    "receivedAmount": 0.0,
    "roomCharge": 0.0,
    "serviceChargeAmount": 0.0,
    "taxAmount": 0.0,
    "nights": 0.0,
  }.obs;
  var roomChargesTotals = {
    "totalTax": 0.0,
    "totalRent": 0.0,
    "serviceChargeAmount": 0.0,
    "ofrdTariff": 0.0,
    "nrmlTariff": 0.0,
    "discountAmount": 0.0,
  }.obs;

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
                symbol: item["symbol"],
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

  Future<void> loadNightAuditReport(
    DateTime date,
    int hotel,
    int currency,
  ) async {
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

        arrangeRoomCharges(result['roomCharges']);
        arrangeCheckedOutRecodes(result['checkedOutRecodes']);
        arrangeComplimentaryRecodes(result['complimentaryRecodes']);
        arrangeDailySalesRecodes(result['dailySalesRecodes']);
        arrangeMiscellaneousRecodes(result['miscellaneousRecodes']);
        arrangePaxAnalysisRecodes(result['paxAnalysisRecodes']);
        arrangePaxStatusRecodes(result['paxStatusRecodes']);
        arrangeReceiptDetailsRecodes(result['receiptDetailsRecodes']);
        arrangeReceiptSummaryPayModeWiseRecodes(
          result['receiptSummaryPayModeWiseRecodes'],
        );
        arrangeReceiptSummaryUserWiseRecodes(
          result['receiptSummaryUserWiseRecodes'],
        );
        arrangeRoomStatusRecodes(result['roomStatusRecodes']);
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

  arrangeComplimentaryRecodes(List<dynamic> data) {
    complimentaryRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
  }

  void arrangeDailySalesRecodes(List<dynamic> data) {
    // Initialize totals map
    final Map<String, double> totals = {
      "adjustment": 0.0,
      "discount": 0.0,
      "extraCharges": 0.0,
      "extraServiceCharges": 0.0,
      "extraTax": 0.0,
      "roomCharges": 0.0,
      "roomServiceCharges": 0.0,
      "roomTax": 0.0,
      "totalSales": 0.0,
    };

    dailySalesRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    for (final element in dailySalesRecodes) {
      totals["adjustment"] =
          totals["adjustment"]! + (element["adjustment"] as num? ?? 0);
      totals["discount"] =
          totals["discount"]! + (element["discount"] as num? ?? 0);
      totals["extraCharges"] =
          totals["extraCharges"]! + (element["extraCharges"] as num? ?? 0);
      totals["extraServiceCharges"] =
          totals["extraServiceCharges"]! +
          (element["extraServiceCharges"] as num? ?? 0);
      totals["extraTax"] =
          totals["extraTax"]! + (element["extraTax"] as num? ?? 0);
      totals["roomCharges"] =
          totals["roomCharges"]! + (element["roomCharges"] as num? ?? 0);
      totals["roomServiceCharges"] =
          totals["roomServiceCharges"]! +
          (element["roomServiceCharges"] as num? ?? 0);
      totals["roomTax"] =
          totals["roomTax"]! + (element["roomTax"] as num? ?? 0);
      totals["totalSales"] =
          totals["totalSales"]! + (element["totalSales"] as num? ?? 0);
    }

    totals.forEach((key, value) => dailySalesTotals[key] = value);
  }

  arrangeMiscellaneousRecodes(List<dynamic> data) {
    double totalAmount = 0;
    int totalQuantity = 0;
    miscellaneousRecodes.value =
        (data as List<dynamic>?)?.map((e) {
          totalAmount += (e["amount"] as num).toDouble();
          totalQuantity += (e["quantity"] as num).toInt();
          return Map<String, dynamic>.from(e);
        }).toList() ??
        [];
    miscTotals["amount"] = totalAmount;
    miscTotals["quantity"] = totalQuantity;
  }

  arrangePaxStatusRecodes(List<dynamic> data) {
    int totalAdults = 0;
    int totalChildren = 0;
    paxStatusRecodes.value =
        (data as List<dynamic>?)?.map((e) {
          totalAdults += (e["adults"] as num).toInt();
          totalChildren += (e["children"] as num).toInt();
          return Map<String, dynamic>.from(e);
        }).toList() ??
        [];
    paxStatusTotals["adult"] = totalAdults;
    paxStatusTotals["children"] = totalChildren;
  }

  arrangeReceiptDetailsRecodes(List<dynamic> data) {
    receiptDetailsRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
  }

  arrangeReceiptSummaryPayModeWiseRecodes(List<dynamic> data) {
    receiptSummaryPayModeWiseRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
  }

  arrangeReceiptSummaryUserWiseRecodes(List<dynamic> data) {
    receiptSummaryUserWiseRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
  }

  arrangeRoomStatusRecodes(List<dynamic> data) {
    roomStatusRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
  }

  void arrangeCheckedOutRecodes(List<dynamic> data) {
    final totals = {
      "adjust": 0.0,
      "balanceAmount": 0.0,
      "discount": 0.0,
      "extraCharges": 0.0,
      "receivedAmount": 0.0,
      "roomCharge": 0.0,
      "serviceChargeAmount": 0.0,
      "taxAmount": 0.0,
      "nights": 0.0,
    };

    checkedOutRecodes.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    for (final element in checkedOutRecodes) {
      totals["adjust"] = totals["adjust"]! + (element["adjust"] as num? ?? 0);
      totals["balanceAmount"] =
          totals["balanceAmount"]! + (element["balanceAmount"] as num? ?? 0);
      totals["discount"] =
          totals["discount"]! + (element["discount"] as num? ?? 0);
      totals["extraCharges"] =
          totals["extraCharges"]! + (element["extraCharges"] as num? ?? 0);
      totals["receivedAmount"] =
          totals["receivedAmount"]! + (element["receivedAmount"] as num? ?? 0);
      totals["roomCharge"] =
          totals["roomCharge"]! + (element["roomCharge"] as num? ?? 0);
      totals["serviceChargeAmount"] =
          totals["serviceChargeAmount"]! +
          (element["serviceChargeAmount"] as num? ?? 0);
      totals["taxAmount"] =
          totals["taxAmount"]! + (element["taxAmount"] as num? ?? 0);
      totals["nights"] = totals["nights"]! + (element["nights"] as num? ?? 0);
    }

    totals.forEach((key, value) => checkedOutTotals[key] = value);
  }

  void arrangeRoomCharges(List<dynamic> data) {
    final totals = {
      "totalTax": 0.0,
      "totalRent": 0.0,
      "serviceChargeAmount": 0.0,
      "ofrdTariff": 0.0,
      "nrmlTariff": 0.0,
      "discountAmount": 0.0,
    };

    roomCharges.value =
        (data as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    for (final element in roomCharges) {
      totals["totalTax"] =
          totals["totalTax"]! + (element["totalTax"] as num? ?? 0);
      totals["totalRent"] =
          totals["totalRent"]! + (element["totalRent"] as num? ?? 0);
      totals["serviceChargeAmount"] =
          totals["serviceChargeAmount"]! +
          (element["serviceChargeAmount"] as num? ?? 0);
      totals["ofrdTariff"] =
          totals["ofrdTariff"]! + (element["ofrdTariff"] as num? ?? 0);
      totals["nrmlTariff"] =
          totals["nrmlTariff"]! + (element["nrmlTariff"] as num? ?? 0);
      totals["discountAmount"] =
          totals["discountAmount"]! + (element["discountAmount"] as num? ?? 0);
    }

    totals.forEach((key, value) => roomChargesTotals[key] = value);
  }

  arrangePaxAnalysisRecodes(List<dynamic> data) {
    int totalAdults = 0;
    int totalChildren = 0;
    paxAnalysisRecodes.value =
        (data as List<dynamic>?)?.map((e) {
          totalAdults += (e["adults"] as num).toInt();
          totalChildren += (e["children"] as num).toInt();

          return Map<String, dynamic>.from(e);
        }).toList() ??
        [];

    paxAnalysisTotals["adult"] = totalAdults;
    paxAnalysisTotals["children"] = totalChildren;
  }
}
