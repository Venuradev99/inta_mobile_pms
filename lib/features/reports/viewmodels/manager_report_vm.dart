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
  final isReportLoading = true.obs;

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


   final Map<String, List<Map<String, dynamic>>> financialSections = {
    'Room Charges': [
      {
        'name': 'Cancellation Revenue',
        'today': 0.0,
        'pdt': 37600.0,
        'ydt': 325840.26,
      },
      {'name': 'Day Use Charges', 'today': 0.0, 'pdt': 0.0, 'ydt': 139000.0},
      {
        'name': 'Late CheckOut Charges',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 92547.25,
      },
      {'name': 'No Show Revenue', 'today': 0.0, 'pdt': 0.0, 'ydt': 349800.0},
      {
        'name': 'Room Charges',
        'today': 30000.0,
        'pdt': 265550.38,
        'ydt': 2575755.93,
      },
      {
        'name': 'Early Check In Charges',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 17200.0,
      },
      {
        'name': 'Group Total',
        'today': 30000.0,
        'pdt': 303150.38,
        'ydt': 3500143.44,
        'bold': true,
      },
    ],
    'Extra Charges': [
      {'name': 'Airport Transfer', 'today': 0.0, 'pdt': 0.0, 'ydt': 34000.0},
      {
        'name': 'Connecting Room Request',
        'today': 0.0,
        'pdt': 3666.66,
        'ydt': 7876.05,
      },
      {
        'name': 'Mini-Bar Consumption',
        'today': 0.0,
        'pdt': 454.55,
        'ydt': 5909.13,
      },
      {
        'name': 'Deep Cleaning (after pet or sm',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 3000.0,
      },
      {
        'name': 'Courier / Postage Services',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 500.0,
      },
      {'name': 'Extra Slipper', 'today': 0.0, 'pdt': 1785.72, 'ydt': 80357.2},
      {
        'name': 'Group Total',
        'today': 0.0,
        'pdt': 5906.93,
        'ydt': 131642.38,
        'bold': true,
      },
    ],
    'Adjustments': [
      {'name': 'Adjustment Amount', 'today': 0.0, 'pdt': 0.0, 'ydt': 1788.5},
      {
        'name': 'Group Total',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 1788.5,
        'bold': true,
      },
    ],
    'Tax': [
      {
        'name': 'Service Charge',
        'today': 1050.0,
        'pdt': 14045.73,
        'ydt': 220110.42,
      },
      {'name': 'TDL 1%', 'today': 210.0, 'pdt': 2800.07, 'ydt': 39976.02},
      {'name': 'VAT', 'today': 525.0, 'pdt': 6910.86, 'ydt': 108094.33},
      {'name': 'SSCL', 'today': 300.0, 'pdt': 3726.51, 'ydt': 45687.77},
      {
        'name': 'Group Total',
        'today': 2085.0,
        'pdt': 27483.17,
        'ydt': 413868.54,
        'bold': true,
      },
    ],
    'Discount': [
      {'name': 'Festive Offer(B)', 'today': 0.0, 'pdt': 0.0, 'ydt': -16860.16},
      {
        'name': 'Direct Booking Discount(E)',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': -2880.0,
      },
      {
        'name': 'Loyalty Member Discount (B)',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': -1407.5,
      },
      {
        'name': 'Anniversary Offer (R)',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': -65781.52,
      },
      {
        'name': 'Referral Discount (B)',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': -14672.5,
      },
      {'name': 'Room Discount (R)', 'today': 0.0, 'pdt': 0.0, 'ydt': -2527.94},
      {'name': 'Extra Discount (E)', 'today': 0.0, 'pdt': 0.0, 'ydt': -7510.0},
      {'name': 'Test 04', 'today': 0.0, 'pdt': 0.0, 'ydt': -20100.0},
      {
        'name': 'Group Total',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': -131739.62,
        'bold': true,
      },
    ],
    'Pay Outs': [
      {'name': 'Fresh Flowers', 'today': 0.0, 'pdt': 0.0, 'ydt': 25000.0},
      {
        'name': 'Group Total',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 25000.0,
        'bold': true,
      },
    ],
    'Total Revenue': [
      {
        'name': 'Total Revenue without Tax',
        'today': 30000.0,
        'pdt': 309057.31,
        'ydt': 3476834.70,
        'bold': true,
      },
      {
        'name': 'Total Revenue with Tax',
        'today': 32085.0,
        'pdt': 336540.48,
        'ydt': 3890703.24,
        'bold': true,
      },
    ],
    'Payment': [
      {'name': 'CASH', 'today': 0.0, 'pdt': 0.0, 'ydt': 685752.69},
      {'name': 'CHEQUE', 'today': 0.0, 'pdt': 0.0, 'ydt': 926465.86},
      {'name': 'CREDIT CARD', 'today': 0.0, 'pdt': 0.0, 'ydt': 153148.0},
      {'name': 'ADVANCE', 'today': 0.0, 'pdt': 0.0, 'ydt': 226096.07},
      {'name': 'PayPal', 'today': 0.0, 'pdt': 0.0, 'ydt': 9850.0},
      {'name': 'Bank Transfer', 'today': 0.0, 'pdt': 0.0, 'ydt': 74787.0},
      {'name': 'Digital Payment', 'today': 0.0, 'pdt': 0.0, 'ydt': 54595.0},
      {'name': 'Google Pay', 'today': 0.0, 'pdt': 0.0, 'ydt': 98593.48},
      {
        'name': 'Total Payment',
        'today': 0.0,
        'pdt': 0.0,
        'ydt': 2229288.10,
        'bold': true,
      },
    ],
    'City Ledger': [
      {
        'name': 'Opening Balance',
        'today': 286885.58,
        'pdt': 286885.58,
        'ydt': 0.0,
      },
      {'name': 'Payment Received', 'today': 0.0, 'pdt': 0.0, 'ydt': 7450.0},
      {'name': 'Charges Raised', 'today': 0.0, 'pdt': 0.0, 'ydt': 294335.58},
      {
        'name': 'Closing Balance',
        'today': 286885.58,
        'pdt': 286885.58,
        'ydt': 286885.58,
        'bold': true,
      },
    ],
  };


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

  Future<void> getManagerReport(
    String currency,
    DateTime selectedDate,
    List<String> selectedHotels,
  ) async {
    try {
      isReportLoading.value = true;
      final payload = ManagerReportPayload(
        currency: getCurrencyId(currency),
        reportId: 213,
        selectedDate: selectedDate.toIso8601String().substring(0, 10),
        hotelIdsList: getHoteIdList(selectedHotels),
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
