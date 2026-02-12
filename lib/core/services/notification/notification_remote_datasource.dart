import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/core/services/network/api_services.dart';
import 'package:kipa/utils/constant.dart';

class NotificationRemoteDatasource {
  final ApiService _apiService;

  NotificationRemoteDatasource(this._apiService);

  Future<bool> registerDeviceToken({
    required String token,
    required String platform,
  }) async {
    try {
      final response = await _apiService.postRequest(
        endpoint: ApiEndpoints.registerDeviceTokenUrl,
        requestBody: {'token': token, 'platform': platform},
      );
      final isSuccess =
          response.success ||
          (response.statusCode == 200) ||
          response.message.toLowerCase().contains('success');

      if (isSuccess) {
        logMessage('NotificationDatasource', 'Device token registered');
        return true;
      } else {
        logMessage(
          'NotificationDatasource',
          'Failed to register token: ${response.message}',
        );
        return false;
      }
    } catch (e) {
      logMessage('NotificationDatasource', 'Error registering token: $e');
      return false;
    }
  }
}
