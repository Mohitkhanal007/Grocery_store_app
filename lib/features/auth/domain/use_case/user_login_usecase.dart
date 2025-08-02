import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/shared_prefs/token_shared_prefs.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  const LoginParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class LoginResult extends Equatable {
  final String token;
  final UserEntity user;

  const LoginResult({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class UserLoginUsecase implements UsecaseWithParams<LoginResult, LoginParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;
  final SharedPreferences _sharedPreferences;

  UserLoginUsecase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
    required SharedPreferences sharedPreferences,
  }) : _userRepository = userRepository,
       _tokenSharedPrefs = tokenSharedPrefs,
       _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, LoginResult>> call(LoginParams params) async {
    try {
      print(
        '🔐 UserLoginUsecase: Calling repository login for email: ${params.email}',
      );

      final result = await _userRepository.loginUser(
        params.email,
        params.password,
      );

      return result.fold(
        (failure) {
          print(
            '❌ UserLoginUsecase: Repository returned failure - ${failure.message}',
          );
          return Left(failure);
        },
        (loginResult) async {
          print(
            '✅ UserLoginUsecase: Repository returned success - Token: ${loginResult.token.substring(0, 10)}..., User: ${loginResult.user.username}',
          );

          // Save token to shared preferences
          final saveTokenResult = await _tokenSharedPrefs.saveToken(
            loginResult.token,
          );
          return saveTokenResult.fold(
            (failure) {
              print(
                '❌ UserLoginUsecase: Failed to save token - ${failure.message}',
              );
              return Left(failure);
            },
            (_) async {
              // Set login status to true
              await _sharedPreferences.setBool('isLoggedIn', true);

              // Store the actual user ID from the response
              if (loginResult.user.id != null) {
                await _sharedPreferences.setString(
                  'userId',
                  loginResult.user.id!,
                );
                print(
                  '✅ UserLoginUsecase: Saved user ID: ${loginResult.user.id}',
                );
              }

              // Also store email for backward compatibility
              await _sharedPreferences.setString(
                'userEmail',
                loginResult.user.email,
              );
              print(
                '✅ UserLoginUsecase: Saved user email: ${loginResult.user.email}',
              );

              return Right(loginResult);
            },
          );
        },
      );
    } catch (e) {
      print('❌ UserLoginUsecase: Exception occurred - $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
