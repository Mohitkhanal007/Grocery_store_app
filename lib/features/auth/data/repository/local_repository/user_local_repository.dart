import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/use_case/user_login_usecase.dart';
import '../../data_source/user_data_source.dart';

class UserLocalRepository implements IUserRepository {
  final IUserDataSource _dataSource;

  UserLocalRepository({required IUserDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String id) async {
    try {
      final user = await _dataSource.getCurrentUser(id);
      return Right(user);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResult>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResult = await _dataSource.loginUser(email, password);
      return Right(loginResult);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _dataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final filePath = await _dataSource.uploadProfilePicture(file.path);
      return Right(filePath);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
