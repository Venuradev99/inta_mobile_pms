import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inta_mobile_pms/services/message_service.dart';

class ActivationService {
  late String appIconPath;
  ActivationService(this.appIconPath);

  get getIconPath => appIconPath;

  Future<Map<String, dynamic>> licencemanagementserviceApi(String key) async {
    try {
      final url = 'https://licencemanagementservice.intapos.com';
      final response = await http.get(
        Uri.parse('$url/api/posConfiguration/configKey/$key'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final responseBody = jsonDecode(response.body);
        MessageService().error(
          responseBody["errors"] ??
              "Error loading licence management information!",
        );
        throw Exception();
      }
    } catch (e) {
      String msg = 'Error loading licence management information : $e';
      MessageService().error(msg);
      throw Exception(msg);
    }
  }
}
