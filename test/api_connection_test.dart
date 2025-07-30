import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:jerseyhub/app/constant/api_endpoints.dart';

void main() {
  group('API Connection Tests', () {
    late Dio dio;

    setUp(() {
      dio = Dio();
      dio.options.baseUrl = ApiEndpoints.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);
    });

    test('should connect to Jersey backend', () async {
      try {
        // Test basic connectivity
        final response = await dio.get('');
        expect(
          response.statusCode,
          anyOf(200, 404),
        ); // 404 is fine if endpoint doesn't exist
        print(
          '✅ Successfully connected to Jersey backend at: ${ApiEndpoints.baseUrl}',
        );
      } catch (e) {
        print('❌ Failed to connect to Jersey backend: $e');
        print('🔗 Attempted URL: ${ApiEndpoints.baseUrl}');
        rethrow;
      }
    });

    test('should have correct base URL format', () {
      final baseUrl = ApiEndpoints.baseUrl;
      expect(baseUrl, contains('10.0.2.2:2000'));
      // Note: Jersey backend might not use /api/ prefix by default
      print('✅ Base URL format is correct: $baseUrl');
    });

    test('should have correct endpoint paths', () {
      expect(ApiEndpoints.loginUser, equals('user/login'));
      expect(ApiEndpoints.registerUser, equals('user/register'));
      print('✅ Endpoint paths are correct');
    });
  });
}
