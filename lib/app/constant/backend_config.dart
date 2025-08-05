import 'package:dio/dio.dart';

/// Backend Configuration for Grocery Store
///
/// IMPORTANT: Backend server runs on port 5000 - DO NOT CHANGE THIS PORT
class BackendConfig {
  // ===== NODE.JS BACKEND CONFIGURATION =====

  /// Your Node.js backend server address
  /// For Android emulator: http://10.0.2.2:3002
  /// For physical device: http://YOUR_COMPUTER_IP:3002
  /// For production: https://your-domain.com
  ///
  /// FIXED PORT: 3002 - DO NOT CHANGE THIS PORT
  static const String serverAddress =
      "http://192.168.16.109:3002"; // Using your computer's IP address

  /// API base path for Node.js backend
  static const String apiPath = "/api/v1";

  /// Full base URL for API calls
  static String get baseUrl => "$serverAddress$apiPath/";

  /// Upload URL for images/files
  static String get uploadUrl => "$serverAddress/uploads/";

  // ===== NODE.JS ENDPOINTS =====

  /// User authentication endpoints
  static const String loginEndpoint = "auth/login";
  static const String registerEndpoint = "auth/register";
  static const String getUserEndpoint = "auth/";
  static const String uploadImageEndpoint = "auth/uploadImg";

  /// Product endpoints
  static const String productsEndpoint = "products";
  static const String categoriesEndpoint = "products/category";

  /// Order endpoints
  static const String ordersEndpoint = "orders";

  /// Payment endpoints
  static const String esewaEndpoint = "payments";

  /// Notification endpoints
  static const String notificationsEndpoint = "notifications";

  // ===== NODE.JS RESPONSE FORMATS =====

  /// Expected token field names in login response
  /// Update these to match your Node.js backend response format
  static const List<String> tokenFieldNames = [
    'token',
    'accessToken',
    'jwt',
    'authToken',
    'bearerToken',
  ];

  /// Expected success status codes
  static const List<int> successStatusCodes = [200, 201];

  /// Expected error status codes and their messages
  static const Map<int, String> errorMessages = {
    400: 'Bad Request - Invalid data provided',
    401: 'Unauthorized - Invalid credentials',
    403: 'Forbidden - Access denied',
    404: 'Not Found - Resource not found',
    409: 'Conflict - User already exists',
    500: 'Internal Server Error - Server error occurred',
  };

  /// Test backend connectivity
  static Future<bool> testBackendConnection() async {
    try {
      final dio = Dio();
      final response = await dio.get('$serverAddress/api/v1/products');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Backend connection test failed: $e');
      return false;
    }
  }

  /// Enable API logging for debugging
  static const bool enableApiLogging = true;

  /// Connection timeout in seconds
  static const int connectionTimeoutSeconds =
      10; // Increased to 10 seconds for better connectivity

  /// Receive timeout in seconds
  static const int receiveTimeoutSeconds =
      10; // Increased to 10 seconds for better connectivity
}
