import 'package:get/get.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/apiServices/activation_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class ProductActivationVm extends GetxController {
  final isLoading = false.obs;

  final ActivationService _activationService;

  ProductActivationVm(this._activationService);

  get getIconPath => _activationService.getIconPath;

  Future<void> activate(String key) async {
    try {
      isLoading.value = true;
      final response = await _activationService.licencemanagementserviceApi(
        key,
      );
      if (response["IsSuccessful"]) {
        final result = response["DataSet"];
        LocalStorageManager.setActivationData(
          Map<String, dynamic>.from(result),
        );
        await validateLogin();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error while activation!',
        );
        isLoading.value = false;
      }
    } catch (e) {
      throw Exception('Error while activation!');
    } finally {
      isLoading.value = false;
    }
  }

  validateLogin() async {
    try {
      final activationData = await LocalStorageManager.getActivationData();
      if (activationData.serviceUrl.isNotEmpty) {
        NavigationService().go(AppRoutes.login);
      }
    } catch (e) {
      throw Exception('Error configuring login');
    }
  }
}
