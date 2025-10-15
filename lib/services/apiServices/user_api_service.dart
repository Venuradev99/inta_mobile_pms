import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/loading_controller.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class UserApiService {
  final loadingController = Get.find<LoadingController>();

  static Future<Map<String, dynamic>> getConfigJSON() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final response = json.decode(configString);
      return response;
    } catch (e) {
      throw Exception('Failed to load configuration: $e');
    }
  }

  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String hotelId,
  ) async {
    try {
      final config = await UserApiService.getConfigJSON();
      final baseUrl = config['baseUrl'] ?? '';
      final loginUrl = '$baseUrl${AppResources.authentication}';
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'HotelId': hotelId,
          'ClientId': '099153c2625149bc8ecb3e85e03f0022',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final token = responseData["access_token"];
        if (token != null &&
            responseData["access_token"].toString().isNotEmpty) {
          await LocalStorageManager.setMasterData({
            "userName": responseData["userName"],
            "userid": responseData["userid"],
            "ClientId": responseData["ClientId"],
            "Menus": responseData["Menus"],
            "Privileges": responseData["Privileges"],
          });
          await LocalStorageManager.setAccessToken(
            responseData["access_token"],
          );
          await LocalStorageManager.setRefreshToken(
            responseData["refresh_token"],
          );
          await LocalStorageManager.setHotelId(hotelId);

          final systemInfo = await loadSystemInformation();
          if (systemInfo["isSuccessful"]) {
            await LocalStorageManager.setSystemDate(
              systemInfo["result"]["systemDate"],
            );
          }

          return {
            "isSuccessful": true,
            "message": "No access token found in response",
          };
        } else {
          return {
            "isSuccessful": false,
            "message": "No access token found in response",
          };
        }
      } else {
        return {
          "isSuccessful": false,
          "message": "Login failed: ${response.body}",
        };
      }
    } catch (e) {
      throw Exception('Error occurede while login: $e');
    } 
  }

  Future<Map<String, dynamic>> loadSystemInformation() async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.getSystemWorkingDate;

      final configDataResponse = await ApiConfigService().getConfigJSON();
      final baseUrl = configDataResponse['baseUrl'];

      if (token.isEmpty) throw Exception('Session key not available');
      if (baseUrl == null) throw Exception('baseUrl URL not available');

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        "hotelid": hotelId,
        'requestedhotelid': (-1).toString(),
      };

      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load system information');
      }
    } catch (e) {
      throw Exception('Error loading system information: $e');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      loadingController.show();
      await LocalStorageManager.clearUserData();
      // final logoutUrl = AppResources.logoutUrl;
      // final response = await http.post(Uri.parse(logoutUrl));
      return {"isUserLogout": true, "message": "User Logged out!"};
    } catch (e) {
      throw Exception('Error occured while logout: $e');
    }
  }
}
