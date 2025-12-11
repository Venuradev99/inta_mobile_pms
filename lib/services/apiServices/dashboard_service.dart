import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class DashboardService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  DashboardService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getBookingStatics() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getBookingStats}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllLockReservations() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllLockReservations}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> lockBooking(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.lockBooking}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getInventoryPropertyOccupancyData() async {
    try {
      return {
        "errors": [],
        "isSuccessful": true,
        "isDBAccessible": true,
        "result": {
          "propertyStatistics": {
            "totalRevenue": {
              "name": "Total Revenue",
              "today": 91423.00,
              "yesterday": 17205.50,
              "percentage": 0.0,
            },
            "averageDailyRate": {
              "name": "Total Payment",
              "today": 0.0,
              "yesterday": 0.0,
              "percentage": 0.0,
            },
            "averageLengthOfStay": {
              "name": "",
              "today": 0.0,
              "yesterday": 0.0,
              "percentage": 0.0,
            },
            "revPar": {
              "name": "RevPar",
              "today": 1523.7166666666666666666666667,
              "yesterday": 286.75833333333333333333333333,
              "percentage": 0.0,
            },
            "totalPayment": {
              "name": "",
              "today": 0.0,
              "yesterday": 0.0,
              "percentage": 0.0,
            },
          },
          "occupancyStatics": {"today": 81.67, "yesterday": 23.33},
          "inventoryStatics": {
            "totalAvailableRooms": 60.0,
            "totalAvailableRoomsRate": 0.0,
            "totalRoomsSold": 49.0,
            "totalRoomsSoldRate": 0.0,
            "blockedRooms": 0.0,
            "blockedRoomsRate": 0.0,
            "complementaryRooms": 0.0,
            "complementaryRoomsRate": 0.0,
          },
        },
        "message": "",
      };
      
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
