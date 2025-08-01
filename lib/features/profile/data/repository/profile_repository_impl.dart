import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/profile/data/data_source/profile_remote_datasource.dart';
import 'package:jerseyhub/features/profile/data/model/profile_model.dart';
import 'package:jerseyhub/features/profile/domain/entity/profile_entity.dart';
import 'package:jerseyhub/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    final result = await remoteDataSource.getProfile(userId);
    return result.fold(
      (failure) => Left(failure),
      (profileModel) => Right(profileModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    final result = await remoteDataSource.updateProfile(profile);
    return result.fold(
      (failure) => Left(failure),
      (profileModel) => Right(profileModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    return await remoteDataSource.uploadProfileImage(imagePath);
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
