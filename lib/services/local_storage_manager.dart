import 'dart:convert';
import 'package:inta_mobile_pms/data/models/MasterData.model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LocalStorageManager {
  static Future<void> setMasterData(Map<String, dynamic> masterData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('masterData', jsonEncode(masterData));
  }

  static Future<MasterData> getMasterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('masterData') ?? "";
    if (jsonString.isNotEmpty) {
      final json = jsonDecode(jsonString);
    
      return MasterData.fromJson(json);
    } else {
     
      return MasterData(
        userName: '',
        userId: '',
        clientId: '',
        menus: '',
        privileges: '',
      );
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
     await prefs.clear();
  }


   static Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'access_token':  'Bearer '+ token,
    });
    await prefs.setString('access_token', jsonString);
  }

    static Future<void> setHotelId(String hotelId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'hotelId': hotelId,
    });
    await prefs.setString('hotelId', jsonString);
  }



  static Future<void> setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'refresh_token':  'Bearer '+ token,
    });
    await prefs.setString('refresh_token', jsonString);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('access_token') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    return  data['access_token'] ?? '';
  }

  static Future<String> getHotelId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('hotelId') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    return  data['hotelId'] ?? '';
  }

 static Future<Map<String, String>> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('refresh_token') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    return {
      'refresh_token': data['refresh_token'] ?? ''
    };
  }

  



}