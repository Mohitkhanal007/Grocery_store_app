import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/auth/domain/entity/user_entity.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/use_case/user_login_usecase.dart';
import '../../data_source/remote_datasource/user_remote_datasource.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRemoteRepository({required UserRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String id) async {
    try {
      final user = await _remoteDataSource.getCurrentUser(id);
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResult>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResult = await _remoteDataSource.loginUser(email, password);
      return Right(loginResult);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _remoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final filePath = await _remoteDataSource.uploadProfilePicture(file.path);
      return Right(filePath);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
