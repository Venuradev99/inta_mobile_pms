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

  String getLastDayOfWeek(String fromDate) {
    try {
      DateTime startDate = DateTime.parse(fromDate);
      DateTime endDate = startDate.add(Duration(days: 6));
      return endDate.toIso8601String().substring(0, 10);
    } catch (e) {
      throw Exception('Error in GetToDateForWeek');
    }
  }

  Future<void> loadBookingStaticData() async {
    try {
      isLoading.value = true;
      final today = await LocalStorageManager.getSystemDate();
      final body = ReservationSearchRequest(
        businessSourceId: 0,
        exceptCancelled: false,
        fromDate: today.toString(),
        isArrivalDate: true,
        reservationTypeId: 0,
        roomId: 0,
        roomTypeId: 0,
        searchByName: "",
        searchType: 1,
        status: 0,
        toDate: getLastDayOfWeek(today.toString()),
        businessCategoryId: 0,
      ).toJson();

      final responses = await Future.wait([
        _dashboardService.getBookingStatics(),
        _dashboardService.getInventoryPropertyOccupancyData(),
        _reservationService.getAllReservationList(body),
      ]);

      final bookingResponse = responses[0];
      final inventoryPropertyOccupancyResponse = responses[1];
      final arrivalListResponse = responses[2];

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
            inventoryPropertyOccupancyResponse["result"]["propertyStatistics"];
        final occupancyResult =
            inventoryPropertyOccupancyResponse["result"]["occupancyStatics"];
        final inventoryResult =
            inventoryPropertyOccupancyResponse["result"]["inventoryStatics"];

        final totalRevenue = propertyResult["totalRevenue"];

        totalRevenueData.value = PropertyStaticsData(
          name: totalRevenue["name"],
          today: roundTo2(totalRevenue["today"]),
          yesterday: roundTo2(totalRevenue["yesterday"]),
          percentage: roundTo2(totalRevenue["percentage"]),
        );
        final averageDailyRate = propertyResult["averageDailyRate"];

        averageDailyRateData.value = PropertyStaticsData(
          name: averageDailyRate["name"] ?? '',
          today: roundTo2(averageDailyRate["today"]),
          yesterday: roundTo2(averageDailyRate["yesterday"]),
          percentage: roundTo2(averageDailyRate["percentage"]),
        );

        final averageLengthOfStay = propertyResult["averageLengthOfStay"];

        averageLengthOfStayData.value = PropertyStaticsData(
          name: averageLengthOfStay["name"] ?? '',
          today: roundTo2(averageLengthOfStay["today"]),
          yesterday: roundTo2(averageLengthOfStay["yesterday"]),
          percentage: roundTo2(averageLengthOfStay["percentage"]),
        );

        final revPar = propertyResult["revPar"];

        revParData.value = PropertyStaticsData(
          name: revPar["name"] ?? '',
          today: roundTo2(revPar["today"]),
          yesterday: roundTo2(revPar["yesterday"]),
          percentage: roundTo2(revPar["percentage"]),
        );

        final totalPayment = propertyResult["totalPayment"];

        totalPaymentData.value = PropertyStaticsData(
          name: totalPayment["name"] ?? '',
          today: roundTo2(totalPayment["today"]),
          yesterday: roundTo2(totalPayment["yesterday"]),
          percentage: roundTo2(totalPayment["percentage"]),
        );

        occupancyData.value = OccupancyData(
          today: occupancyResult["today"],
          yesterday: occupancyResult["yesterday"],
        );

        totalAvailableRooms.value = inventoryResult["totalAvailableRooms"];
        totalAvailableRoomsRate.value =
            inventoryResult["totalAvailableRoomsRate"];
        totalRoomSold.value = inventoryResult["totalRoomsSold"];
        totalRoomSoldRate.value = inventoryResult["totalRoomsSoldRate"];
        outOfOrderRooms.value = inventoryResult["blockedRooms"];
        outOfOrderRoomsRate.value = inventoryResult["blockedRoomsRate"];
        complementaryRooms.value = inventoryResult["complementaryRooms"];
        complementaryRoomsRate.value =
            inventoryResult["complementaryRoomsRate"];
      } else {
        MessageService().error(
          inventoryPropertyOccupancyResponse["errors"][0] ??
              'Error loading dashboard inventory, occupancy, property data!',
        );
      }

      if (arrivalListResponse["isSuccessful"] == true) {
        final List<dynamic> result = arrivalListResponse["result"];

        for (final item in result) {
          final data = GuestItem(
            bookingRoomId: item['bookingRoomId'].toString(),
            guestName: item['bookingGuestWithTitle'] ?? '',
            resId: item['reservationNo'] ?? '',
            folioId: item['bookingId'].toString(),
            startDate: item['arrivalDate'] ?? '',
            endDate: item['departureDate'] ?? '',
            nights: item['nights'] ?? 0,
            roomType: item['roomName'] ?? '',
            reservationType: item['reservationType'] ?? '',
            adults: item['noOfAdults'] ?? 0,
            totalAmount: (item['totalAmount'] ?? 0).toDouble(),
            balanceAmount: (item['balanceAmount'] ?? 0).toDouble(),
            room: item['roomName'] ?? '',
          );
          allReservationList.add(data);
          allReservationListFiltered.add(data);
        }
      } else {
        MessageService().error(
          arrivalListResponse["errors"][0] ?? 'Error loading arrival list!',
        );
      }
    } catch (e) {
      MessageService().error('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
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
