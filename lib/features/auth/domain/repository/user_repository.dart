import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/auth/domain/entity/user_entity.dart';
import 'package:grocerystore/features/auth/domain/use_case/user_login_usecase.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, LoginResult>> loginUser(String email, String password);

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, UserEntity>> getCurrentUser(String id);

  Future<Either<Failure, void>> logout();
}
