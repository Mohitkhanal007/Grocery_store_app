import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:jerseyhub/app/constant/api_endpoints.dart';

void main() {
  group('API Connection Tests', () {
    late Dio dio;

    setUp(() {
      dio = Dio();
      // For testing on development machine, use localhost instead of 10.0.2.2
      dio.options.baseUrl = "http://localhost:5050/api/";
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);
    });

    test('should connect to Jersey backend', () async {
      try {
        // Test basic connectivity using a valid endpoint
        final response = await dio.get('admin/product');
        expect(response.statusCode, 200);
        print(
          '✅ Successfully connected to Jersey backend at: ${ApiEndpoints.baseUrl}',
        );
        print('📦 Products endpoint response: ${response.data}');
      } catch (e) {
        print('❌ Failed to connect to Jersey backend: $e');
        print('🔗 Attempted URL: ${ApiEndpoints.baseUrl}');
        rethrow;
      }
    });

    test('should have correct base URL format', () {
      final baseUrl = ApiEndpoints.baseUrl;
      expect(baseUrl, contains('10.0.2.2:5050'));
      expect(baseUrl, contains('/api/'));
      print('✅ Base URL format is correct: $baseUrl');
    });

    test('should have correct endpoint paths', () {
      expect(ApiEndpoints.loginUser, equals('auth/login'));
      expect(ApiEndpoints.registerUser, equals('auth/register'));
      print('✅ Endpoint paths are correct');
    });
  });
}
