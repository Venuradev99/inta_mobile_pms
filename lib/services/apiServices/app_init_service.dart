import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class AppInitService extends GetxService {
  late String baseUrl;

  AppInitService(this.baseUrl);

  Future<AppInitService> init() async {
    try {
      final responses = await Future.wait([loadSystemInformationApi()]);
      final systemInfo = responses[0];

      if (systemInfo["isSuccessful"]) {
        await LocalStorageManager.setSystemInfo(systemInfo["result"]);
      }
    } catch (e) {
      String msg = 'Failed to load system information : $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
    return this;
  }

  Future<Map<String, dynamic>> loadSystemInformationApi() async {
    try {
      // final token = await LocalStorageManager.getAccessToken();
      // final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.getSystemInformation;
      // if (token.isEmpty) throw Exception('Session key not available');

      // final headers = {
      //   'Authorization': token,
      //   'Content-Type': 'application/json',
      //   "hotelid": hotelId,
      //   'requestedhotelid': (-1).toString(),
      // };

      final response = await http.get(Uri.parse('$baseUrl$url'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        MessageService().error(
          responseBody["errors"] ?? "Error loading system information!",
        );
        throw Exception();
      }
    } catch (e) {
      String msg = 'Failed to load system information : $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }
}
