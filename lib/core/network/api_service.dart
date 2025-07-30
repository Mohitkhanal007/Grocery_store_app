import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../app/constant/api_endpoints.dart';
import '../../app/constant/backend_config.dart';
import 'dio_error_interceptor.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: false,
          enabled: BackendConfig.enableApiLogging,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }

  // Helper method to add authorization header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Helper method to remove authorization header
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
