import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class UserApiService {
  
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
      return {
        "isLoggingSuccessful": false,
        "message": "An error occurred while logging in: $e",
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await LocalStorageManager.clearUserData();
      // final logoutUrl = AppResources.logoutUrl;
      // final response = await http.post(Uri.parse(logoutUrl));
      return {"isUserLogout": true, "message": "User Logged out!"};
    } catch (e) {
      return {
        "isUserLogout": false,
        "message": "An error occurred while logging in: $e",
      };
    }
  }
}
