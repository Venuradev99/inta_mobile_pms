import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class UserMenuService {
 static Future<List<int>> getMenuIdList() async {
    try {
      final userData = await LocalStorageManager.getMasterData();

      return userData.menus
          .split(',')
          .map((id) => int.tryParse(id.trim()))
          .whereType<int>()
          .toList();
    } catch (e) {
      throw Exception('Error getting user menu list: $e');
    }
  }

 static Future<bool> checkMenuPrivilege(int menuId) async {
    try {
      final menus = await getMenuIdList();
      return menus.contains(menuId);
    } catch (e) {
      throw Exception('Error checking user menu privilege: $e');
    }
  }
}
