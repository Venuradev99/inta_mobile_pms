import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class QuickReservationService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  QuickReservationService(this._dataAccess, this._appResources);

 Future<Map<String, dynamic>> getAllTitle() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllTitle}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getAllRoomTypes() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllRoomTypes}';
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
