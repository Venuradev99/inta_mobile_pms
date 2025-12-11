import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class UserApiService {
  static Future<Map<String, dynamic>> getConfigJSON() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final response = json.decode(configString);
      return response;
    } catch (e) {
      String msg = 'Failed to load configuration: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }

  Future<void> login(String username, String password, String hotelId) async {
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

        if (token != null && token.isNotEmpty) {
          // Save data locally
          await LocalStorageManager.setMasterData({
            "userName": responseData["userName"],
            "userId": responseData["userid"],
            "clientId": responseData["ClientId"],
            "menus": responseData["Menus"],
            "privileges": responseData["Privileges"],
          });
          await LocalStorageManager.setAccessToken(token);
          await LocalStorageManager.setRefreshToken(
            responseData["refresh_token"],
          );
          await LocalStorageManager.setHotelId(hotelId);

          final systemInfoResponse = await Future.wait([
            loadSystemInformation(),
            loadBaseCurrency(),
            loadHotelInfo(),
          ]);

          final systemInfo = systemInfoResponse[0];
          final baseCurrency = systemInfoResponse[1];
          final hotelInfo = systemInfoResponse[2];

          if (systemInfo["isSuccessful"]) {
            await LocalStorageManager.setSystemDate(
              systemInfo["result"]["systemDate"],
            );
          }

          if (baseCurrency["isSuccessful"]) {
            await LocalStorageManager.setBaseCurrencyData(
              baseCurrency["result"],
            );
          }

          if (hotelInfo["isSuccessful"]) {
            await LocalStorageManager.setHotelInfoData(
              hotelInfo["result"],
            );
          }
          // Show success
          NavigationService().go(AppRoutes.dashboard);
          MessageService().success("Login successful");
        } else {
          MessageService().error("No access token found in response");
        }
      } else {
        //login failed message
        MessageService().error(
          "${jsonDecode(response.body)["error_description"]}",
        );
      }
    } catch (e) {
      MessageService().error("An error occurred while login: $e");
    }
  }

  Future<Map<String, dynamic>> loadSystemInformation() async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.getSystemWorkingDate;

      final config = await UserApiService.getConfigJSON();
      final baseUrl = config['baseUrl'] ?? '';

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

  Future<Map<String, dynamic>> loadBaseCurrency() async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.getBaseCurrency;

      final config = await UserApiService.getConfigJSON();
      final baseUrl = config['baseUrl'] ?? '';

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        String msg = 'Failed to load system information';
        MessageService().error(msg);
        throw Exception(msg);
      }
    } catch (e) {
      String msg = 'Error loading system information: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> loadHotelInfo() async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.hotel;

      final config = await UserApiService.getConfigJSON();
      final baseUrl = config['baseUrl'] ?? '';

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        String msg = 'Failed to load hotel information';
        MessageService().error(msg);
        throw Exception(msg);
      }
    } catch (e) {
      String msg = 'Error loading hotel information: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }

  Future<void> logout() async {
    try {
      await LocalStorageManager.clearUserData();
      // final logoutUrl = AppResources.logoutUrl;
      // final response = await http.post(Uri.parse(logoutUrl));

      NavigationService().go(AppRoutes.login);
    } catch (e) {
      String msg = 'Error occured while logout: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }
}
