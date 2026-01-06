import 'package:get/Get.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
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
  List<dynamic> responseData = [];
  final isLoading = true.obs;
  final isReportLoading = false.obs;
  final selectedHotel = 0.obs;
  final isShowHotelDropdown = false.obs;
  final receivedHotels = [].obs;
  final isMultipleHotelCheckbox = false.obs;
  int multipleHotelIndex = 0;

  final paymentData = [].obs;
  final roomChargeData = [].obs;
  final extraChargeData = [].obs;
  final adjustmentData = [].obs;
  final taxData = [].obs;
  final discountData = [].obs;
  final payoutData = [].obs;
  final posRevenueData = [].obs;
  final posRevenuePaymentData = [].obs;
  final cityLedgerData = [].obs;
  final roomSummaryData = [].obs;
  final statisticRecordsData = [].obs;

  final paymentDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final roomChargeDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final extraChargeDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final adjustmentDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final taxDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final discountDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final payoutDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final posRevenueDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final posRevenuePaymentDataTotals = {
    "today": 0.0,
    "ptd": 0.0,
    "ytd": 0.0,
  }.obs;
  final cityLedgerDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
  final roomSummaryDataTotals = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;

  final financialSections = <String, List<dynamic>>{}.obs;

  ManagerReportVm(this._reportsService);

  void resetData() {
    paymentData.value = [];
    roomChargeData.value = [];
    extraChargeData.value = [];
    adjustmentData.value = [];
    taxData.value = [];
    discountData.value = [];
    payoutData.value = [];
    posRevenueData.value = [];
    posRevenuePaymentData.value = [];
    cityLedgerData.value = [];
    roomSummaryData.value = [];
    statisticRecordsData.value = [];

    paymentDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0};
    roomChargeDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0};
    extraChargeDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    adjustmentDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    taxDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    discountDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    payoutDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    posRevenueDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0}.obs;
    posRevenuePaymentDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0};
    cityLedgerDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0};
    roomSummaryDataTotals.value = {"today": 0.0, "ptd": 0.0, "ytd": 0.0};
  }

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
          currencyResponse["error"][selectedHotel.value] ??
              'Error gettings Hotels',
        );
      }
    } catch (e) {
      MessageService().error('Error loading initial Data: $e');
      throw Exception('Error loading initial Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  loadTablesAccordingToHotel() {
    final selectedHotelId = isMultipleHotelCheckbox.value == true
        ? multipleHotelIndex
        : selectedHotel.value;
    final data = responseData;

    final statisticRecordsDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["statisticRecords"],
    );
    statisticRecordsData.value = statisticRecordsDataResult.map((item) {
      return {
        "id": item["id"] ?? 0,
        "category": item["category"] ?? 'Statistics',
        "description": item["description"] ?? '',
        "today": item["today"] ?? 0.0,
        "ptd": item["ptd"] ?? 0.0,
        "ytd": item["ytd"] ?? 0.0,
      };
    }).toList();

    
    final cityLedgerDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["cityLedgerRecodes"],
    );
    cityLedgerData.value = cityLedgerDataResult.map((item) {
      cityLedgerDataTotals["today"] =
          cityLedgerDataTotals["today"]! + (item["today"] as num? ?? 0);
      cityLedgerDataTotals["ptd"] =
          cityLedgerDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
      cityLedgerDataTotals["ytd"] =
          cityLedgerDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
      return {
        "id": item["id"] ?? 0,
        "category": item["category"] ?? '',
        "description": item["description"] ?? '',
        "today": item["today"] ?? 0.0,
        "ptd": item["ptd"] ?? 0.0,
        "ytd": item["ytd"] ?? 0.0,
      };
    }).toList();

    final paymentDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["paymentRecodes"],
    );
    paymentData.value = paymentDataResult.map((item) {
      paymentDataTotals["today"] =
          paymentDataTotals["today"]! + (item["today"] as num? ?? 0);
      paymentDataTotals["ptd"] =
          paymentDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
      paymentDataTotals["ytd"] =
          paymentDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);

      return {
        "id": item["id"] ?? 0,
        "category": item["category"] ?? 'Payment',
        "code": item["code"] ?? '',
        "description": item["description"] ?? '',
        "today": item["today"] ?? 0.0,
        "ptd": item["ptd"] ?? 0.0,
        "ytd": item["ytd"] ?? 0.0,
      };
    }).toList();

    final revenueRecordDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["revenueRecodes"],
    );

    roomChargeData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Room Charge')
        .map((item) {
          roomChargeDataTotals["today"] =
              roomChargeDataTotals["today"]! + (item["today"] as num? ?? 0);
          roomChargeDataTotals["ptd"] =
              roomChargeDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          roomChargeDataTotals["ytd"] =
              roomChargeDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    roomChargeData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Room Charge')
        .map((item) {
          roomChargeDataTotals["today"] =
              roomChargeDataTotals["today"]! + (item["today"] as num? ?? 0);
          roomChargeDataTotals["ptd"] =
              roomChargeDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          roomChargeDataTotals["ytd"] =
              roomChargeDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    extraChargeData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Extra Charge')
        .map((item) {
          extraChargeDataTotals["today"] =
              extraChargeDataTotals["today"]! + (item["today"] as num? ?? 0);
          extraChargeDataTotals["ptd"] =
              extraChargeDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          extraChargeDataTotals["ytd"] =
              extraChargeDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    adjustmentData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Adjustment')
        .map((item) {
          adjustmentDataTotals["today"] =
              adjustmentDataTotals["today"]! + (item["today"] as num? ?? 0);
          adjustmentDataTotals["ptd"] =
              adjustmentDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          adjustmentDataTotals["ytd"] =
              adjustmentDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    taxData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Tax')
        .map((item) {
          taxDataTotals["today"] =
              taxDataTotals["today"]! + (item["today"] as num? ?? 0);
          taxDataTotals["ptd"] =
              taxDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          taxDataTotals["ytd"] =
              taxDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    discountData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Discount')
        .map((item) {
          discountDataTotals["today"] =
              discountDataTotals["today"]! + (item["today"] as num? ?? 0);
          discountDataTotals["ptd"] =
              discountDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          discountDataTotals["ytd"] =
              discountDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    payoutData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'Pay Outs')
        .map((item) {
          payoutDataTotals["today"] =
              payoutDataTotals["today"]! + (item["today"] as num? ?? 0);
          payoutDataTotals["ptd"] =
              payoutDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          payoutDataTotals["ytd"] =
              payoutDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    posRevenueData.value = revenueRecordDataResult
        .where((item) => item["category"] == 'POS Revenue')
        .map((item) {
          posRevenueDataTotals["today"] =
              posRevenueDataTotals["today"]! + (item["today"] as num? ?? 0);
          posRevenueDataTotals["ptd"] =
              posRevenueDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
          posRevenueDataTotals["ytd"] =
              posRevenueDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
          return {
            "id": item["id"] ?? 0,
            "category": item["category"] ?? '',
            "description": item["description"] ?? '',
            "today": item["today"] ?? 0.0,
            "ptd": item["ptd"] ?? 0.0,
            "ytd": item["ytd"] ?? 0.0,
          };
        })
        .toList();

    final posPaymentDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["posPaymentRecodes"],
    );

    posRevenuePaymentData.value = posPaymentDataResult.map((item) {
      posRevenuePaymentDataTotals["today"] =
          posRevenuePaymentDataTotals["today"]! + (item["today"] as num? ?? 0);
      posRevenuePaymentDataTotals["ptd"] =
          posRevenuePaymentDataTotals["ptd"]! + (item["ptd"] as num? ?? 0);
      posRevenuePaymentDataTotals["ytd"] =
          posRevenuePaymentDataTotals["ytd"]! + (item["ytd"] as num? ?? 0);
      return {
        "id": item["id"] ?? 0,
        "category": item["category"] ?? '',
        "code": item["code"] ?? '',
        "description": item["description"] ?? '',
        "today": item["today"] ?? 0.0,
        "ptd": item["ptd"] ?? 0.0,
        "ytd": item["ytd"] ?? 0.0,
      };
    }).toList();

    final roomSummaryDataResult = List<Map<String, dynamic>>.from(
      data[selectedHotelId]["roomSummaryRecodes"],
    );

    roomSummaryData.value = roomSummaryDataResult.map((item) {
      final today = _toNum(item["today"]);
      final ptd = _toNum(item["ptd"]);
      final ytd = _toNum(item["ytd"]);

      roomSummaryDataTotals["today"] = roomSummaryDataTotals["today"]! + today;
      roomSummaryDataTotals["ptd"] = roomSummaryDataTotals["ptd"]! + ptd;
      roomSummaryDataTotals["ytd"] = roomSummaryDataTotals["ytd"]! + ytd;

      return {
        "id": item["id"] ?? 0,
        "category": item["category"] ?? '',
        "description": item["description"] ?? '',
        "today": today,
        "ptd": ptd,
        "ytd": ytd,
      };
    }).toList();
  }

  num _toNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> getManagerReport(
    CurrencyItem currency,
    DateTime selectedDate,
    List<HotelItem> hotels,
    bool isMultipleHotel,
  ) async {
    try {
      isMultipleHotelCheckbox.value = isMultipleHotel;
      isReportLoading.value = true;
      final payload = ManagerReportPayload(
        currency: currency.currencyId,
        reportId: 213,
        selectedDate: selectedDate.toIso8601String().substring(0, 10),
        hotelIdsList: hotels
            .map((HotelItem hotel) => hotel.hotelId)
            .toList()
            .join(',')
            .toString(),
      ).toJson();

      final response = await _reportsService.getManagerReport(payload);

      if (response["isSuccessful"] == true) {
        receivedHotels.value = (response["result"]["reportData"] as List)
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final hotel = entry.value;
              if (isMultipleHotel == true && hotel["hotelId"] == -1) {
                multipleHotelIndex = index;
              }
              return {
                "index": index,
                "hotelId": hotel["hotelId"],
                "hotelName": hotel["hotelName"],
              };
            })
            .toList();

        responseData = response["result"]["reportData"];

        loadTablesAccordingToHotel();
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
      isShowHotelDropdown.value = true;
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
