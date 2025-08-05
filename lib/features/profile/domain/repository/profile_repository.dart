import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/profile/domain/entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
