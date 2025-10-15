import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class DataAccessService {

  Map<String, dynamic>? configData;
  String? baseUrl;
  final ApiConfigService apiConfigService = ApiConfigService();
  String? errorMessage;
  var serviceUrl;

  Future<void> loadConfigData() async {
    try {

      final response = await ApiConfigService().getConfigJSON();
      configData = response;
      baseUrl = response['baseUrl'];
    } catch (e) {
      throw Exception('Failed to load configuration: $e');
    } finally {
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to make ${response.request?.method} request. '
        'Status Code: ${response.statusCode}, '
        'Response: ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    try {

      final token = await LocalStorageManager.getAccessToken();
      final hotelId = await LocalStorageManager.getHotelId();
      if (baseUrl == null) {
        await loadConfigData();
      }

      if (token.isEmpty) {
        throw Exception('Session key not available');
      }

      if (baseUrl == null) {
        throw Exception('baseUrl URL not available');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Hotelid': hotelId,
      };

      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: headers,
      );

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
      if (baseUrl == null) {
        await loadConfigData();
      }

      if (token.isEmpty) {
        throw Exception('Session key not available');
      }

      if (baseUrl == null) {
        throw Exception('baseUrl URL not available');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Hotelid': hotelId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl$url'),
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

class ApiConfigService {
  Future<Map<String, dynamic>> getConfigJSON() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final response = json.decode(configString);
      return response;
    } catch (e) {
      throw Exception('Failed to load configuration: $e');
    }
  }
}
