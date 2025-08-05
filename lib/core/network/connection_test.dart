import 'package:dio/dio.dart';
import '../../app/constant/backend_config.dart';

class ConnectionTest {
  static final Dio _dio = Dio();

  /// Test connection to Node.js backend
  static Future<bool> testBackendConnection() async {
    try {
      print('🔗 Testing connection to Node.js backend...');

      final response = await _dio.get(
        '${BackendConfig.serverAddress}/api/v1/test',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Backend connection successful!');
        print('📡 Response: ${response.data}');
        return true;
      } else {
        print('❌ Backend connection failed: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Backend connection failed: $e');
      return false;
    }
  }

  /// Test products endpoint
  static Future<bool> testProductsEndpoint() async {
    try {
      print('🔗 Testing products endpoint...');

      final response = await _dio.get(
        '${BackendConfig.baseUrl}${BackendConfig.productsEndpoint}',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Products endpoint working!');
        print('📦 Found ${response.data.length} products');
        return true;
      } else {
        print('❌ Products endpoint failed: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Products endpoint failed: $e');
      return false;
    }
  }

  /// Run all connection tests
  static Future<void> runAllTests() async {
    print('🚀 Starting connection tests...');

    final backendTest = await testBackendConnection();
    final productsTest = await testProductsEndpoint();

    print('📊 Test Results:');
    print('   Backend Connection: ${backendTest ? '✅ PASS' : '❌ FAIL'}');
    print('   Products Endpoint: ${productsTest ? '✅ PASS' : '❌ FAIL'}');

    if (backendTest && productsTest) {
      print(
        '🎉 All tests passed! Flutter app is connected to Node.js backend.',
      );
    } else {
      print('⚠️  Some tests failed. Check your backend configuration.');
    }
  }
}
