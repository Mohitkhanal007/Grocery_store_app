class ApiConfig {
  // Development server URL
  static const String devBaseUrl = 'http://localhost:3001/api/v1';

  // Production server URL (update this when deploying)
  static const String prodBaseUrl = 'https://your-production-server.com/api/v1';

  // Current base URL (change this based on environment)
  static const String baseUrl = devBaseUrl;

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String customersEndpoint = '/customers';
  static const String cartEndpoint = '/cart';
  static const String ordersEndpoint = '/orders';
  static const String wishlistEndpoint = '/wishlist';
  static const String reviewsEndpoint = '/reviews';

  // Timeout settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get authorization header
  static Map<String, String> getAuthHeaders(String token) {
    return {...defaultHeaders, 'Authorization': 'Bearer $token'};
  }
}
