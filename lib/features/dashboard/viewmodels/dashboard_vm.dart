import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/dashboard/models/booking_static_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/hotel_inventory_data.dart';
import 'package:inta_mobile_pms/features/dashboard/models/today_statistics_data.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';

class DashboardVm {
  final DashboardService _dashboardService = DashboardService();

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
  final projectedRevPar = RxDouble(0);
  final projectedAdr = RxDouble(0);
  final projectedOccupancy = RxDouble(0);

  DashboardVm();
  Future<void> loadBookingStaticData() async {
    final responses = await Future.wait([
      _dashboardService.getBookingStats(),
      _dashboardService.getInventoryStats(),
    ]);

    final bookingResponse = responses[0];

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
      ////error message
    }

    final inventoryResponse = responses[1];
    if (inventoryResponse["isSuccessful"] == true) {
      final List<dynamic> todayStatisticsData =
          inventoryResponse["result"]["todayStatisticsData"];
      for (final item in todayStatisticsData) {
        final data = TodaystatisticsData.fromJson(item);

        if (data.name == "Total Rooms To Sell") {
          totalRoomsToSell = data.value;
          print('totalRoomsRoSell=$totalRoomsToSell');
        }

        if (data.name == "Total Room Sold") {
          totalRoomSold.value = data.value;
          print('totalSold=$totalRoomSold');
        }

        if (data.name == "Complimentary Rooms") {
          complementaryRooms.value = data.value;
          print('complementaryRooms=$complementaryRooms');
        }

         if (data.name == "Projected RevPAR") {
          projectedRevPar.value = data.value;
          print('projectedRevPar=$projectedRevPar');
        }

         if (data.name == "Projected ADR") {
          projectedAdr.value = data.value;
          print('projectedAdr=$projectedAdr');
        }

          if (data.name == "Projected Occupancy") {
          projectedOccupancy.value = data.value;
          print('projectedOccupancy=$projectedOccupancy');
        }

      }

      final List<dynamic> hotelInventoryData =
          inventoryResponse["result"]["hotelInventory"];
      for (final item in hotelInventoryData) {
        final data = HotelInventoryData.fromJson(item);
        // if (data.name == "Total Rooms Available") {
        //   totalAvailableRooms.value = data.value;
        //   print('totalAvailableRooms=$totalAvailableRooms');
        // }

        if (data.name == "Out of Order") {
          outOfOrderRooms.value = data.value;
          print('outOfOrder=$outOfOrderRooms');
        }
      }

      final futureInventoryModel =
          inventoryResponse["result"]["futureInventoryModel"]["totalInventory"];

      final todayInventory = futureInventoryModel.isNotEmpty
          ? futureInventoryModel[0]
          : 0;

      totalAvailableRooms.value = totalRoomsToSell - todayInventory;
      print('totalAvailableRooms=$totalAvailableRooms');

      totalRoomSoldRate.value = (totalRoomSold / totalRoomsToSell);
      print('totalRoomSoldRate=$totalRoomSoldRate');
      totalAvailableRoomsRate.value = (totalAvailableRooms / totalRoomsToSell);
      print('totalRoomSoldRate=$totalAvailableRoomsRate');
      complementaryRoomsRate.value = (complementaryRooms / totalRoomsToSell);
      print('totalRoomSoldRate=$totalAvailableRoomsRate');
      outOfOrderRoomsRate.value = (outOfOrderRooms / totalRoomsToSell);
      print('totalRoomSoldRate=$outOfOrderRoomsRate');
    } else {
      ////error message
    }
  }
}
