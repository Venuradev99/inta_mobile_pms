import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class UserApiService {
  late String version;
  late String baseUrl;
  late String appIconPath;

  UserApiService(this.version, this.baseUrl, this.appIconPath);

  get getVersion => version;
  get getIconPath => appIconPath;

  Future<void> login(String username, String password, String hotelId) async {
    try {
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
          final responses = await Future.wait([
            loadSystemWorkingDate(),
            loadBaseCurrency(),
            loadHotelInfo(),
          ]);

          final systemWorkingDate = responses[0];
          final baseCurrency = responses[1];
          final hotelInfo = responses[2];

          if (systemWorkingDate["isSuccessful"]) {
            await LocalStorageManager.setSystemDate(
              systemWorkingDate["result"]["systemDate"],
            );
          }

          if (baseCurrency["isSuccessful"]) {
            await LocalStorageManager.setBaseCurrencyData(
              baseCurrency["result"],
            );
          }

          if (hotelInfo["isSuccessful"]) {
            await LocalStorageManager.setHotelInfoData(hotelInfo["result"]);
          }

          NavigationService().go(AppRoutes.dashboard);
          MessageService().success("Login successful");
        } else {
          MessageService().error("No access token found in response");
        }
      } else {
        MessageService().error(
          "${jsonDecode(response.body)["error_description"]}",
        );
      }
    } catch (e) {
      MessageService().error("An error occurred while login: $e");
    }
  }

  Future<Map<String, dynamic>> loadSystemWorkingDate() async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      final url = AppResources.getSystemWorkingDate;
      if (token.isEmpty) throw Exception('Session key not available');

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

      if (token.isEmpty) throw Exception('Session key not available');

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

      if (token.isEmpty) throw Exception('Session key not available');
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

  Future<void> changeProperty(int hotelId) async {
    try {
      await LocalStorageManager.setHotelId(hotelId.toString());

      final systemInfoResponse = await Future.wait([
        loadSystemWorkingDate(),
        loadBaseCurrency(),
        loadHotelInfo(),
      ]);

      final systemWorkingDate = systemInfoResponse[0];
      final baseCurrency = systemInfoResponse[1];
      final hotelInfo = systemInfoResponse[2];

      if (systemWorkingDate["isSuccessful"]) {
        await LocalStorageManager.setSystemDate(
          systemWorkingDate["result"]["systemDate"],
        );
      }

      if (baseCurrency["isSuccessful"]) {
        await LocalStorageManager.setBaseCurrencyData(baseCurrency["result"]);
      }

      if (hotelInfo["isSuccessful"]) {
        await LocalStorageManager.setHotelInfoData(hotelInfo["result"]);
      }
    } catch (e) {
      String msg = 'Error change property: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }

  Future<void> logout() async {
    try {
      await LocalStorageManager.clearUserData();
      NavigationService().go(AppRoutes.login);
    } catch (e) {
      String msg = 'Error occured while logout: $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }
}
