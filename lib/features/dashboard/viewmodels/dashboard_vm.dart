import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/dashboard/models/booking_static_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/hotel_inventory_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/occupancy_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/property_statics_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/today_statistics_data.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class DashboardVm extends GetxController {
  final DashboardService _dashboardService;
   final UserApiService _userApiService;

  final arrivalData = Rx<BookingStaticData?>(null);
  final departureData = Rx<BookingStaticData?>(null);
  final inHouseData = Rx<BookingStaticData?>(null);
  final bookingData = Rx<BookingStaticData?>(null);

  double totalRoomsToSell = 0;

  final totalRoomSold = RxDouble(0);
  final totalRoomSoldRate = RxDouble(0);
  final totalAvailableRooms = RxDouble(0);
  final totalAvailableRoomsRate = RxDouble(0);
  final complementaryRooms = RxDouble(0);
  final complementaryRoomsRate = RxDouble(0);
  final outOfOrderRooms = RxDouble(0);
  final outOfOrderRoomsRate = RxDouble(0);

  // final projectedRevPar = RxDouble(0);
  // final projectedAdr = RxDouble(0);

  // final projectedOccupancy = RxDouble(0);

  final totalRevenueData = Rx<PropertyStaticsData?>(null);
  final averageDailyRateData = Rx<PropertyStaticsData?>(null);
  final bookingLeadTimeData = Rx<PropertyStaticsData?>(null);
  final averageLengthOfStayData = Rx<PropertyStaticsData?>(null);
  final totalPaymentData = Rx<PropertyStaticsData?>(null);
  final revParData = Rx<PropertyStaticsData?>(null);

  final occupancyData = Rx<OccupancyData?>(null);

  final isLoading = true.obs;

  DashboardVm(this._dashboardService,this._userApiService);

  Future<void> loadBookingStaticData() async {
    isLoading.value = true;
    try {

      final responses = await Future.wait([
        _dashboardService.getBookingStatics(),
        _dashboardService.getInventoryStatics(),
        _dashboardService.getPropertyStatics(),
        _dashboardService.getOccupancyStatics(),
      ]);

      final bookingResponse = responses[0];
      final inventoryResponse = responses[1];
      final propertyStatisticsResponse = responses[2];
      final occupancyStaticsResponse = responses[3];

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
        MessageService().error(bookingResponse["errors"][0] ?? 'Error getting booking details!');
      }

      if (inventoryResponse["isSuccessful"] == true) {
        final List<dynamic> todayStatisticsData =
            inventoryResponse["result"]["todayStatisticsData"];
        for (final item in todayStatisticsData) {
          final data = TodaystatisticsData.fromJson(item);

          if (data.name == "Total Rooms To Sell") {
            totalRoomsToSell = data.value;
          }

          if (data.name == "Total Room Sold") {
            totalRoomSold.value = data.value;
          }

          if (data.name == "Complimentary Rooms") {
            complementaryRooms.value = data.value;
          }

          // if (data.name == "Projected RevPAR") {
          //   projectedRevPar.value = data.value;
          //  
          // }

          // if (data.name == "Projected ADR") {
          //   projectedAdr.value = data.value;
          //  
          // }

          // if (data.name == "Projected Occupancy") {
          //   projectedOccupancy.value = data.value;
          //   
          // }
        }

        final List<dynamic> hotelInventoryData =
            inventoryResponse["result"]["hotelInventory"];
        for (final item in hotelInventoryData) {
          final data = HotelInventoryData.fromJson(item);
          // if (data.name == "Total Rooms Available") {
          //   totalAvailableRooms.value = data.value;
          //   
          // }

          if (data.name == "Out of Order") {
            outOfOrderRooms.value = data.value;
            //
          }
        }

        final futureInventoryModel =
            inventoryResponse["result"]["futureInventoryModel"]["totalInventory"];

        final todayInventory = futureInventoryModel.isNotEmpty
            ? futureInventoryModel[0]
            : 0;
        totalAvailableRooms.value = totalRoomsToSell - todayInventory;
        totalRoomSoldRate.value =  totalRoomsToSell == 0 ? 0 : (totalRoomSold / totalRoomsToSell);
        totalAvailableRoomsRate.value = totalRoomsToSell == 0 ? 0 :
            (totalAvailableRooms / totalRoomsToSell) ;
        complementaryRoomsRate.value = totalRoomsToSell == 0 ? 0 :  (complementaryRooms / totalRoomsToSell);
        outOfOrderRoomsRate.value = totalRoomsToSell == 0 ? 0 : (outOfOrderRooms / totalRoomsToSell);
      } else {
       MessageService().error(inventoryResponse["errors"][0] ?? 'Error getting inventory details!');
      }

      if (propertyStatisticsResponse["isSuccessful"] == true) {
        final List<dynamic> result = propertyStatisticsResponse["result"];

        for (final item in result) {
          final data = PropertyStaticsData.fromJson(item);
          switch (data.name) {
            case "Total Revenue":
              totalRevenueData.value = data;
              break;
            case "Average Daily Rate":
              averageDailyRateData.value = data;
              break;
            case "Booking Lead Time":
              bookingLeadTimeData.value = data;
              break;
            case "Average Length Of Stay":
              averageLengthOfStayData.value = data;
              break;
            case "Total Payment":
              totalPaymentData.value = data;
              break;
            case "RevPar":
              revParData.value = data;
              break;
          }
        }
      } else {
       MessageService().error(propertyStatisticsResponse["errors"][0] ?? 'Error getting property statistics details!');
      }

      if (occupancyStaticsResponse["isSuccessful"] == true) {
        final result = occupancyStaticsResponse["result"];
        final data = OccupancyData.fromJson(result);
        occupancyData.value = data;
      } else {
       MessageService().error(occupancyStaticsResponse["errors"][0] ?? 'Error getting booking details!');
      }
    } catch (e) {
      MessageService().error('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
      
    }
  }

    Future<void> handleLogout() async {
   await _userApiService.logout();
  }
}