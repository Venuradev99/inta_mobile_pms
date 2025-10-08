import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class DashboardService {
  final DataAccessService _dataAccess = DataAccessService();

  // DashboardService({DataAccessService? dataAccess}):  _dataAccess = dataAccess ?? DataAccessService();

  Future<Map<String, dynamic>> getBookingStats() async {
    try {
      final url = AppResources.getBookingStats;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

 Future<Map<String, dynamic>> getInventoryStats() async {
    try {
      final url = AppResources.getInventoryStats;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
  
}
