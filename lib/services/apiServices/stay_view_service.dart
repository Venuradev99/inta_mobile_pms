import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class StayViewService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  StayViewService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getBookingStatics(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getBookingDetailsByDate}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getStatusColorForStayview() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getStatusColorForStayview}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAvailableRooms(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAvailableRooms}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
