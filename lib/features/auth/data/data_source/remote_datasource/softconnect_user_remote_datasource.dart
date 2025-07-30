/// Softconnect User Remote Data Source - Reference Implementation
/// This shows how softconnect handles backend communication with their specific response format

import 'package:dio/dio.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../../../../core/network/api_service.dart';
import '../../model/user_api_model.dart';
import '../user_data_source.dart';

class SoftconnectUserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  SoftconnectUserRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserEntity> getCurrentUser(String id) async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getUserById(id));

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Softconnect uses {success: true, data: {...}} format
        if (responseData is Map<String, dynamic> &&
            responseData['success'] == true &&
            responseData['data'] != null) {
          final userData = responseData['data'] as Map<String, dynamic>;
          final userApiModel = UserApiModel.fromJson(userData);
          return userApiModel.toEntity();
        } else {
          throw Exception(
            "Invalid response structure or unsuccessful response",
          );
        }
      } else {
        throw Exception("Failed to fetch user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to get current user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      // Note: Softconnect sends FCM token with login request
      // You would need to add Firebase Messaging for this
      // final fcmToken = await FirebaseMessaging.instance.getToken();

      final response = await _apiService.dio.post(
        ApiEndpoints.loginUser,
        data: {
          "email": email.toString(),
          "password": password.toString(),
          // "fcmToken": fcmToken, // Uncomment if using Firebase
        },
      );

      if (response.statusCode == 200) {
        // Softconnect returns {token: "...", data: {...}} format
        final token = response.data['token'];
        final userData = response.data['data'];
        final userApiModel = UserApiModel.fromJson(userData);
        final userEntity = userApiModel.toEntity();

        return token;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Failed to login user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final data = userApiModel.toJson();

      // Note: Your UserEntity doesn't have profilePhoto field
      // If you need profile photo support, add it to UserEntity

      final response = await _apiService.dio.post(
        ApiEndpoints.registerUser,
        data: data,
      );

      // Softconnect accepts both 200 and 201 for successful registration
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'profilePhoto': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiService.dio.post(
        ApiEndpoints.uploadImg,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        // Softconnect returns filename in data field
        final filename = response.data['data'];
        return filename;
      } else {
        throw Exception('Upload failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}
