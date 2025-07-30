/// Backend Configuration for Jersey Hub
///
/// Update these values to match your Jersey backend setup
class BackendConfig {
  // ===== JERSEY BACKEND CONFIGURATION =====

  /// Your Jersey backend server address
  /// For Android emulator: http://10.0.2.2:PORT
  /// For physical device: http://YOUR_COMPUTER_IP:PORT
  /// For production: https://your-domain.com
  static const String serverAddress =
      "http://10.0.2.2:5050"; // Local Jersey backend for testing

  /// API base path (usually empty for Jersey, or "/api" if you have it configured)
  static const String apiPath = "/api";

  /// Full base URL for API calls
  static String get baseUrl => "$serverAddress$apiPath/";

  /// Upload URL for images/files
  static String get uploadUrl => "$serverAddress/uploads/";

  // ===== JERSEY ENDPOINTS =====

  /// User authentication endpoints
  static const String loginEndpoint = "auth/login";
  static const String registerEndpoint = "auth/register";
  static const String getUserEndpoint = "auth/";
  static const String uploadImageEndpoint = "auth/uploadImg";

  /// Product endpoints
  static const String productsEndpoint = "admin/product";
  static const String categoriesEndpoint = "admin/category";

  /// Order endpoints
  static const String ordersEndpoint = "orders";

  /// Payment endpoints
  static const String esewaEndpoint = "esewa";

  /// Notification endpoints
  static const String notificationsEndpoint = "notifications";

  // ===== JERSEY RESPONSE FORMATS =====

  /// Expected token field names in login response
  /// Update these to match your Jersey backend response format
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

  // ===== DEBUGGING =====

  /// Enable/disable API logging
  static const bool enableApiLogging = true;

  /// Connection timeout in seconds
  static const int connectionTimeoutSeconds =
      5; // Reduced for faster simulation

  /// Receive timeout in seconds
  static const int receiveTimeoutSeconds = 5; // Reduced for faster simulation
}
