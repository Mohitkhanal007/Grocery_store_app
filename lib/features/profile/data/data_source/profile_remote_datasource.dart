import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/core/network/api_service.dart';
import 'package:jerseyhub/features/profile/data/model/profile_model.dart';
import 'package:jerseyhub/features/profile/domain/entity/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile(String userId);
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, ProfileModel>> getProfile(String userId) async {
    try {
      print('🔍 Fetching profile for user: $userId');
      final response = await apiService.dio.get('/auth/$userId');

      if (response.statusCode == 200 && response.data != null) {
        final profileModel = ProfileModel.fromJson(response.data.data);
        print('✅ Profile fetched successfully');
        return Right(profileModel);
      } else {
        print('❌ Failed to fetch profile: ${response.statusMessage}');
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to fetch profile'),
        );
      }
    } catch (e) {
      print('💥 Error fetching profile: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      print('🔄 Updating profile for user: ${profile.id}');
      final profileData = ProfileModel.fromEntity(profile).toJson();

      final response = await apiService.dio.put(
        '/auth/${profile.id}',
        data: profileData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final updatedProfile = ProfileModel.fromJson(response.data.data);
        print('✅ Profile updated successfully');
        return Right(updatedProfile);
      } else {
        print('❌ Failed to update profile: ${response.statusMessage}');
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to update profile'),
        );
      }
    } catch (e) {
      print('💥 Error updating profile: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    try {
      print('📤 Uploading profile image: $imagePath');

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await apiService.dio.post(
        '/auth/upload-profile-image',
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final imageUrl = response.data['imageUrl'] as String;
        print('✅ Profile image uploaded successfully: $imageUrl');
        return Right(imageUrl);
      } else {
        print('❌ Failed to upload profile image: ${response.statusMessage}');
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to upload profile image'),
        );
      }
    } catch (e) {
      print('💥 Error uploading profile image: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('🔐 Changing password...');

      final response = await apiService.dio.post(
        '/auth/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        print('✅ Password changed successfully');
        return const Right(true);
      } else {
        print('❌ Failed to change password: ${response.statusMessage}');
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to change password'),
        );
      }
    } catch (e) {
      print('💥 Error changing password: $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
