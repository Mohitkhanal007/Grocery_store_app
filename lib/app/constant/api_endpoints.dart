import 'backend_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static Duration get connectionTimeout =>
      Duration(seconds: BackendConfig.connectionTimeoutSeconds);
  static Duration get receiveTimeout =>
      Duration(seconds: BackendConfig.receiveTimeoutSeconds);

  // Base URLs
  static String get serverAddress => BackendConfig.serverAddress;
  static String get baseUrl => BackendConfig.baseUrl;
  static String get imageUrl => BackendConfig.uploadUrl;

  // User endpoints
  static const String registerUser = BackendConfig.registerEndpoint;
  static const String loginUser = BackendConfig.loginEndpoint;
  static const String getAllUsers = BackendConfig.getUserEndpoint;
  static const String uploadImg = BackendConfig.uploadImageEndpoint;
  static String getUserById(String id) => "${BackendConfig.getUserEndpoint}$id";
  static String updateUserById(String id) =>
      "${BackendConfig.getUserEndpoint}$id";
  static String deleteUserById(String id) =>
      "${BackendConfig.getUserEndpoint}$id";
}
