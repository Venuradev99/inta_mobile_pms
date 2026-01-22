import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class DashboardService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  DashboardService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getBookingStaticsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getBookingStats}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllLockReservationsApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllLockReservations}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getStatisticsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getStatistics}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getInventoryStatsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getInventoryStats}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> lockBookingApi(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.lockBooking}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

    Future<Map<String, dynamic>> getAllHotelsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllHotels}/0';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
