import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class ReportsService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  ReportsService(this._dataAccess, this._appResources);

    Future<Map<String, dynamic>> getNightAudits() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getNightAudits}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getCurrencies() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getCurrencies}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

 Future<Map<String, dynamic>> getAllHotel() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllHotel}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getManagerReport(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getManagerReport}';
      final response = await _dataAccess.post(body,url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

}