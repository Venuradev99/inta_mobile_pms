import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/dashboard/models/booking_static_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/hotel_inventory_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/occupancy_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/property_statics_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/today_statistics_data.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_search_request_model.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class DashboardVm extends GetxController {
  final DashboardService _dashboardService;
  final UserApiService _userApiService;
  final ReservationService _reservationService;

  final userName = ''.obs;
  final hotelName = ''.obs;
  final isSearching = false.obs;

  final arrivalData = Rx<BookingStaticData?>(null);
  final departureData = Rx<BookingStaticData?>(null);
  final inHouseData = Rx<BookingStaticData?>(null);
  final bookingData = Rx<BookingStaticData?>(null);
  final allReservationList = <GuestItem>[].obs;
  final allReservationListFiltered = <GuestItem>[].obs;

  double totalRoomsToSell = 0;

  final totalRoomSold = RxDouble(0);
  final totalRoomSoldRate = RxDouble(0);
  final totalAvailableRooms = RxDouble(0);
  final totalAvailableRoomsRate = RxDouble(0);
  final complementaryRooms = RxDouble(0);
  final complementaryRoomsRate = RxDouble(0);
  final outOfOrderRooms = RxDouble(0);
  final outOfOrderRoomsRate = RxDouble(0);
  final totalRoomsInProperty = RxDouble(0);

  final totalRevenueData = Rx<PropertyStaticsData?>(null);
  final averageDailyRateData = Rx<PropertyStaticsData?>(null);
  final bookingLeadTimeData = Rx<PropertyStaticsData?>(null);
  final averageLengthOfStayData = Rx<PropertyStaticsData?>(null);
  final totalPaymentData = Rx<PropertyStaticsData?>(null);
  final revParData = Rx<PropertyStaticsData?>(null);

  final occupancyData = Rx<OccupancyData?>(null);

  final isLoading = true.obs;

  DashboardVm(
    this._dashboardService,
    this._userApiService,
    this._reservationService,
  );

  Future getUserName() async {
    try {
      final name = await LocalStorageManager.getUserName();
      userName.value = name;
    } catch (e) {
      throw Exception('Error in GetUserName: $e');
    }
  }

  Future getHotelInfoData() async {
    try {
      final hotelInfo = await LocalStorageManager.getHotelInfoData();
      hotelName.value = hotelInfo.hotelName ?? '';
    } catch (e) {
      throw Exception('Error in GetHotelInfoData: $e');
    }
  }

  Future<void> loadBookingStaticData() async {
    try {
      isLoading.value = true;
      final responses = await Future.wait([
        _dashboardService.getInventoryStats(),
        _dashboardService.getBookingStatics(),
        _dashboardService.getStatistics(),
      ]);
      final inventoryStaticsResponse = responses[0];
      final bookingResponse = responses[1];
      final inventoryPropertyOccupancyResponse = responses[2];

      if (inventoryStaticsResponse["isSuccessful"] == true){
          final hotelInventory = inventoryStaticsResponse['result']['hotelInventory'] as List;
           for (final item in hotelInventory) {
              if(item['name'] == "Rooms In Property"){
                totalRoomsInProperty.value = item['value'] ?? 0;
              }
           }
      }else {
        MessageService().error(
          bookingResponse["errors"][0] ?? 'Error getting Inventory Data!',
        );
      }


      if (bookingResponse["isSuccessful"] == true) {
        List<dynamic> result = bookingResponse["result"];

        for (final item in result) {
          final data = BookingStaticData.fromJson(item);

          switch (data.type) {
            case 1:
              arrivalData.value = data;
              break;
            case 2:
              departureData.value = data;
              break;
            case 3:
              inHouseData.value = data;
              break;
            case 4:
              bookingData.value = data;
              break;
          }
        }
      } else {
        MessageService().error(
          bookingResponse["errors"][0] ?? 'Error getting booking details!',
        );
      }

      if (inventoryPropertyOccupancyResponse["isSuccessful"] == true) {
        final propertyResult =
            inventoryPropertyOccupancyResponse["result"]["propertyStatisticsData"];
        final occupancyResult =
            inventoryPropertyOccupancyResponse["result"]["occupancyStatisticsData"];
        final inventoryResult =
            inventoryPropertyOccupancyResponse["result"]["inventoryStatisticsData"];

        for (final item in propertyResult) {
          if (item['name'] == "Total Room Revenue") {
            totalRevenueData.value = PropertyStaticsData(
              name: item["name"],
              today: roundTo2(item["today"]),
              yesterday: roundTo2(item["yesterday"]),
              percentage: roundTo2(item["percentage"]),
            );
          }

          if (item['name'] == "Avg. Daily Rate") {
            averageDailyRateData.value = PropertyStaticsData(
              name: item["name"] ?? '',
              today: roundTo2(item["today"]),
              yesterday: roundTo2(item["yesterday"]),
              percentage: roundTo2(item["percentage"]),
            );
          }

          if (item['name'] == "RevPAR") {
            revParData.value = PropertyStaticsData(
              name: item["name"] ?? '',
              today: roundTo2(item["today"]),
              yesterday: roundTo2(item["yesterday"]),
              percentage: roundTo2(item["percentage"]),
            );
          }

          if (item['name'] == "Total Res. Payment") {
            totalPaymentData.value = PropertyStaticsData(
              name: item["name"] ?? '',
              today: roundTo2(item["today"]),
              yesterday: roundTo2(item["yesterday"]),
              percentage: roundTo2(item["percentage"]),
            );
          }
        }

        occupancyData.value = OccupancyData(
          today: occupancyResult[0]["value"],
          yesterday: 0,
        );

        for (final item in inventoryResult) {
          if (item['name'] == "Available Rooms") {
            totalAvailableRooms.value = item["value"];
            totalAvailableRoomsRate.value = totalRoomsInProperty == 0 ? 0 : totalAvailableRooms / totalRoomsInProperty.value;
          }
          if (item['name'] == "Sold Rooms") {
            totalRoomSold.value = item["value"];
            totalRoomSoldRate.value =totalRoomsInProperty == 0 ? 0 : totalRoomSold / totalRoomsInProperty.value;
          }
          if (item['name'] == "Blocked Rooms") {
            outOfOrderRooms.value = item["value"];
            outOfOrderRoomsRate.value = totalRoomsInProperty == 0 ? 0 : outOfOrderRooms / totalRoomsInProperty.value;
          }
          if (item['name'] == "Complimentary Rooms") {
            complementaryRooms.value = item["value"];
            complementaryRoomsRate.value = totalRoomsInProperty == 0 ? 0 : complementaryRooms / totalRoomsInProperty.value;
          }
        }
      } else {
        MessageService().error(
          inventoryPropertyOccupancyResponse["errors"][0] ??
              'Error loading dashboard inventory, occupancy, property data!',
        );
      }
    } catch (e) {
      MessageService().error('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchReservations() async {
    try {
      isSearching.value = true;
      final payload = {
        "businessSourceId": 0,
        "exceptCancelled": false,
        "fromDate": "2025-12-13",
        "isArrivalDate": true,
        "reservationTypeId": 0,
        "roomId": 0,
        "roomTypeId": 0,
        "searchByName": "",
        "searchType": 1,
        "status": 0,
        "toDate": "2025-12-17",
        "businessCategoryId": 0,
      };

      final response = await _reservationService.getAllReservationList(payload);
      if (response['isSuccessful'] == true) {
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error while searching reservations!',
        );
      }
    } catch (e) {
      throw Exception('Error while Searching!');
    } finally {
      isSearching.value = false;
    }
  }

  void filterSearchGuestItem(String query) {
    try {
      allReservationListFiltered.value = allReservationList.toList();

      if (query.isNotEmpty) {
        allReservationListFiltered.value = allReservationListFiltered
            .where(
              (item) => item.resId!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    } catch (e) {
      throw Exception('Error in Search Filtering: $e');
    }
  }

  double roundTo2(dynamic value) {
    if (value == null) return 0.0;

    double? numValue;
    if (value is num) {
      numValue = value.toDouble();
    } else if (value is String) {
      numValue = double.tryParse(value);
    }

    if (numValue == null || numValue.isNaN) return 0.0;
    return (numValue * 100).roundToDouble() / 100;
  }

  Future<void> handleLogout() async {
    await _userApiService.logout();
  }
}
