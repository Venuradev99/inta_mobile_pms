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

  Future<Map<String, dynamic>> getInventoryStatics() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getInventoryStats}';
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

  Future<Map<String, dynamic>> getPropertyStatics() async {
    try {
      // final url = AppResources.getInventoryStats;
      // final response = await _dataAccess.get(url);

      final config = await rootBundle.loadString('assets/config.json');
      final response = json.decode(config);
      return response["propertyStatistics"];
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getOccupancyStatics() async {
    try {
      // final url = AppResources.getInventoryStats;
      // final response = await _dataAccess.get(url);

      final config = await rootBundle.loadString('assets/config.json');
      final response = json.decode(config);
      return response["occupancyStatics"];
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
