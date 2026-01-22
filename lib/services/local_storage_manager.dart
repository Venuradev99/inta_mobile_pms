import 'dart:convert';
import 'package:inta_mobile_pms/data/models/Base_currency_model.dart';
import 'package:inta_mobile_pms/data/models/checkin_checkout_data_model.dart';
import 'package:inta_mobile_pms/data/models/hotel_information_model.dart';
import 'package:inta_mobile_pms/data/models/master_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static Future<void> setMasterData(Map<String, dynamic> masterData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('masterData', jsonEncode(masterData));
  }

  static Future<MasterData> getMasterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('masterData') ?? "";
    final json = jsonDecode(jsonString);
    return MasterData.fromJson(json);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('masterData') ?? "";
    final json = jsonDecode(jsonString);
    final masterData = MasterData.fromJson(json);
    return masterData.userId;
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('masterData') ?? "";
    final json = jsonDecode(jsonString);
    final masterData = MasterData.fromJson(json);
    return masterData.userName;
  }

  static Future<void> setHotelInfoData(
    Map<String, dynamic> hotelInfoData,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hotelInformation', jsonEncode(hotelInfoData));
  }

  static Future<HotelInformationModel> getHotelInfoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('hotelInformation') ?? "";
    final json = jsonDecode(jsonString);
    return HotelInformationModel.fromJson(json);
  }

  static Future<void> setCheckinCheckoutData(
    List<Map<String, dynamic>> checkinCheckoutData,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'checkinCheckoutData',
      jsonEncode(checkinCheckoutData),
    );
  }

  static Future<List<CheckinCheckoutDataModel>> getCheckinCheckoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('checkinCheckoutData') ?? "[]";
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((jsonItem) => CheckinCheckoutDataModel.fromJson(jsonItem))
        .toList();
  }

  static Future<void> setBaseCurrencyData(
    Map<String, dynamic> baseCurrencyData,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseCurrency', jsonEncode(baseCurrencyData));
  }

  static Future<BaseCurrency> getBaseCurrencyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('baseCurrency') ?? "";
    final json = jsonDecode(jsonString);
    return BaseCurrency.fromJson(json);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setSystemInfo(Map<String, dynamic> sysInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(sysInfo);
    await prefs.setString('system_info', jsonString);
  }

  static Future<Map<String, dynamic>> getSystemInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('system_info') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data;
  }

  static Future<void> setSystemDate(String systemDate) async {
    String systemWorkingDate = systemDate.substring(0, 10);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({'system_date': systemWorkingDate});
    await prefs.setString('system_date', jsonString);
  }

  static Future<String> getSystemDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('system_date') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data['system_date'] ?? '';
  }

  static Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({'access_token': 'Bearer $token'});
    await prefs.setString('access_token', jsonString);
  }

  static Future<void> setHotelId(String hotelId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({'hotelId': hotelId});
    await prefs.setString('hotelId', jsonString);
  }

  static Future<void> setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({'refresh_token': 'Bearer $token'});
    await prefs.setString('refresh_token', jsonString);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('access_token') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);

    return data['access_token'] ?? '';
  }

  static Future<String> getHotelId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('hotelId') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);

    return data['hotelId'] ?? '';
  }

  static Future<Map<String, String>> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('refresh_token') ?? '{}';
    final Map<String, dynamic> data = jsonDecode(jsonString);

    return {'refresh_token': data['refresh_token'] ?? ''};
  }
}
