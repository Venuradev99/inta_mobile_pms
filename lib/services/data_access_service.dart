import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

      return responseBody;
    } else {
      return responseBody;
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

  Future<Map<String, dynamic>> delete(String url) async {
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

      final response = await http.delete(Uri.parse(url), headers: headers);

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
}
