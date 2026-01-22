import 'package:get/get.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';

class LoginVm extends GetxController {
  final UserApiService _userApiService;
  LoginVm(this._userApiService);

  get getVersion => _userApiService.getVersion;
  get getIconPath => _userApiService.getIconPath;

  Future<void> login(String username, String password, String hotelId) async {
    try {
      await _userApiService.loginApi(username, password, hotelId);
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}
