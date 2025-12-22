import 'package:get/Get.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/features/reports/models/manager_report.dart';
import 'package:inta_mobile_pms/features/reports/models/manager_report_payload.dart';
import 'package:inta_mobile_pms/services/apiServices/reports_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerReportVm extends GetxController {
  final ReportsService _reportsService;

  final hotelList = <HotelItem>[].obs;
  final currencyList = <CurrencyItem>[].obs;
  final systemWorkingDate = DateTime.now().obs;
  final isLoading = true.obs;
  final isReportLoading = false.obs;

  final paymentData = <PaymentRecordData>[].obs;
  final roomChargeData = <RevenueRecordData>[].obs;
  final extraChargeData = <RevenueRecordData>[].obs;
  final adjustmentData = <RevenueRecordData>[].obs;
  final taxData = <RevenueRecordData>[].obs;
  final discountData = <RevenueRecordData>[].obs;
  final payoutData = <RevenueRecordData>[].obs;
  final posRevenueData = <RevenueRecordData>[].obs;
  final posRevenuePaymentData = <PosPaymentData>[].obs;
  final cityLedgerData = <CityLedgerData>[].obs;
  final roomSummaryData = <RoomSummaryData>[].obs;

  final financialSections = <String, List<dynamic>>{}.obs;
  final roomSummaryItems = <RoomSummaryData>[].obs;

  ManagerReportVm(this._reportsService);

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

  Future<void> getManagerReport(String currency, DateTime selectedDate) async {
    try {
      isReportLoading.value = true;
      final hotelId = await LocalStorageManager.getHotelId();
      final payload = ManagerReportPayload(
        currency: getCurrencyId(currency),
        reportId: 213,
        selectedDate: selectedDate.toIso8601String().substring(0, 10),
        hotelIdsList: hotelId,
      ).toJson();

      final response = await _reportsService.getManagerReport(payload);

      if (response["isSuccessful"] == true) {
        final cityLedgerDataResult = List<Map<String, dynamic>>.from(
          response["result"]["reportData"][0]["cityLedgerRecodes"],
        );
        cityLedgerData.value = cityLedgerDataResult
            .map(
              (item) => CityLedgerData(
                id: item["id"] ?? 0,
                category: item["category"] ?? 'City Ledger',
                description: item["description"] ?? 'Opening Balance',
                today: item["today"] ?? 0.0,
                ptd: item["ptd"] ?? 0.0,
                ytd: item["ytd"] ?? 0.0,
              ),
            )
            .toList();

        final paymentDataResult = List<Map<String, dynamic>>.from(
          response["result"]["reportData"][0]["paymentRecodes"],
        );
        paymentData.value = paymentDataResult
            .map(
              (item) => PaymentRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? 'Payment',
                code: item["code"] ?? '',
                description: item["description"] ?? '',
                today: item["today"] ?? 0.0,
                ptd: item["ptd"] ?? 0.0,
                ytd: item["ytd"] ?? 0.0,
              ),
            )
            .toList();

        final revenueRecordDataResult = List<Map<String, dynamic>>.from(
          response["result"]["reportData"][0]["revenueRecodes"],
        );

        roomChargeData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Room Charge')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        roomChargeData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Room Charge')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        extraChargeData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Extra Charge')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        adjustmentData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Adjustment')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        taxData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Tax')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        discountData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Discount')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        payoutData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'Pay Outs')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        posRevenueData.value = revenueRecordDataResult
            .where((item) => item["category"] == 'POS Revenue')
            .map(
              (item) => RevenueRecordData(
                id: item["id"] ?? 0,
                category: item["category"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        final posPaymentDataResult = List<Map<String, dynamic>>.from(
          response["result"]["reportData"][0]["posPaymentRecodes"],
        );

        posRevenuePaymentData.value = posPaymentDataResult
            .map(
              (item) => PosPaymentData(
                id: item["id"] ?? 0,
                category: item["category"] ?? "POS Revenue Payment",
                code: item["code"] ?? '',
                description: item["description"] ?? '',
                today: (item["today"] ?? 0).toDouble(),
                ptd: (item["ptd"] ?? 0).toDouble(),
                ytd: (item["ytd"] ?? 0).toDouble(),
              ),
            )
            .toList();

        final roomSummaryDataResult = List<Map<String, dynamic>>.from(
          response["result"]["reportData"][0]["posPaymentRecodes"],
        );

        roomSummaryData.value = roomSummaryDataResult
            .map(
              (item) => RoomSummaryData(
                id: item["id"] ?? 0,
                category: item["category"] ?? "POS Revenue Payment",
                description: item["description"] ?? '',
                today: double.tryParse(item["today"].toString()) ?? 0.0,
                ptd: double.tryParse(item["ptd"].toString()) ?? 0.0,
                ytd: double.tryParse(item["ytd"].toString()) ?? 0.0,
              ),
            )
            .toList();

        financialSections['Room Charges'] = roomChargeData.toList();
        financialSections['Extra Charges'] = extraChargeData.toList();
        financialSections['Adjustments'] = adjustmentData.toList();
        financialSections['Tax'] = taxData.toList();
        financialSections['Discount'] = discountData.toList();
        financialSections['Pay Outs'] = payoutData.toList();
        financialSections['Total Revenue'] = posRevenueData.toList();
        financialSections['Payment'] = paymentData.toList();
        financialSections['City Ledger'] = cityLedgerData.toList();
        roomSummaryItems.value = roomSummaryData;
      } else {
        MessageService().error(
          response["error"][0] ?? 'Error gettings report data',
        );
      }
    } catch (e) {
      MessageService().error('Error loadingReport: $e');
      throw Exception('Error loading Report: $e');
    } finally {
      isReportLoading.value = false;
    }
  }

  String getCurrencySymbol(String? currency) {
    try {
      final currencySymbol =
          currencyList
              .firstWhereOrNull((item) => item.code == currency)
              ?.symbol ??
          '';
      return currencySymbol;
    } catch (e) {
      throw Exception('Error getting currency symbol: $e');
    }
    
  }

  int getCurrencyId(String currencyCode) {
    try {
      final currencyId = currencyList
          .firstWhereOrNull((item) => item.code == currencyCode)
          ?.currencyId;
      return currencyId!;
    } catch (e) {
      MessageService().error('Error getting currency Id: $e');
      throw Exception('Error getting currency Id: $e');
    }
  }

  String getHoteIdList(List<String> hotels) {
    try {
      List<int> hotelIdList = [];
      for (final hotel in hotels) {
        final hotelId = hotelList
            .firstWhereOrNull((item) => item.hotelName == hotel)
            ?.hotelId;
        hotelIdList.add(hotelId!);
      }

      return hotelIdList.join();
    } catch (e) {
      MessageService().error('Error getting hotel Id: $e');
      throw Exception('Error getting hotel Id: $e');
    }
  }

  void openBrowser(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        throw Exception('Count not launch!');
      }
    } catch (e) {
      throw Exception('Error launching URL: $e');
    }
  }
}
