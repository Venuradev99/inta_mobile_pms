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

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getStatistics}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getInventoryStats() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getInventoryStats}';
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
}
