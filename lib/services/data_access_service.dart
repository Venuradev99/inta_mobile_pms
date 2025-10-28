import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/data/models/Api_response_model.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class DataAccessService {
  Map<String, dynamic>? configData;
  String? baseUrl;

  Future<void> loadConfigData() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final response = json.decode(configString);
      baseUrl = response['baseUrl'].toString();
    } catch (e) {
      throw Exception('Failed to load configuration: $e');
    } finally {}
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 401) {
       NavigationService().go(AppRoutes.login);
      await LocalStorageManager.clearUserData();

      String errorMsg =
          responseBody["errors"][0] ?? 'Unauthorized, try login again!';
      MessageService().error(errorMsg);
      return ApiResponse(
        errors: [errorMsg],
        isSuccessful: responseBody['isSuccessful'] ?? false,
        isDBAccessible: responseBody['isDBAccessible'] ?? false,
        result: responseBody['result'],
        message: responseBody['message'] ?? '',
        statusCode: response.statusCode,
      ).toJson();
    } else {
      return ApiResponse(
        errors: responseBody['errors'] ?? [],
        isSuccessful: responseBody['isSuccessful'] ?? false,
        isDBAccessible: responseBody['isDBAccessible'] ?? false,
        result: responseBody['result'],
        message: responseBody['message'] ?? '',
        statusCode: response.statusCode,
      ).toJson();
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();

      if (token.isEmpty) {
        throw Exception('Session key not available');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Hotelid': hotelId,
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET error: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    Map<String, dynamic> body,
    String url,
  ) async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();

      if (token.isEmpty) {
        throw Exception('Session key not available');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Hotelid': hotelId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    Map<String, dynamic> body,
    String url,
  ) async {
    try {
      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();

      if (token.isEmpty) {
        throw Exception('Session key not available');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Hotelid': hotelId,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  //   Future<Map<String, dynamic>> Post(
  //     String url,
  //     Map<String, dynamic> body,
  //   ) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.post(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     return _handleResponse(response);
  //   }

  //   Future<Map<String, dynamic>> PostList(String url, List<dynamic> body) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.post(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     return _handleResponse(response);
  //   }

  //   Future<Map<String, dynamic>> Put(
  //     String url,
  //     Map<String, dynamic> body,
  //   ) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.put(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     return _handleResponse(response);
  //   }

  //   Future<Map<String, dynamic>> PUT(String url, List<dynamic> body) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.put(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     return _handleResponse(response);
  //   }

  //   Future<Map<dynamic, dynamic>> Put_(
  //     String url,
  //     Map<dynamic, dynamic> body,
  //   ) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.put(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     return _handleResponse(response);
  //   }

  //   Future<Map<String, dynamic>> Delete(String url) async {
  //     final sessionKey = await SessionManager.getSessionKey();
  //     if (sessionKey == null) {
  //       throw Exception('Session key not available');
  //     }

  //     final serviceUrl = appData;
  //     if (serviceUrl == null) {
  //       throw Exception('Service URL not available');
  //     }

  //     final headers = {
  //       'Authorization': sessionKey,
  //       'Content-Type': 'application/json',
  //     };

  //     final response = await http.delete(
  //       Uri.parse('$serviceUrl/api$url'),
  //       headers: headers,
  //     );

  //     return _handleResponse(response);
  //   }
}
