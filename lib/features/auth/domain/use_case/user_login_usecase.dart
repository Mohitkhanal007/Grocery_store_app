import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/shared_prefs/token_shared_prefs.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
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

class UserLoginUsecase implements UsecaseWithParams<String, LoginParams> {
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
  Future<Either<Failure, String>> call(LoginParams params) async {
    try {
      final result = await _userRepository.loginUser(
        params.email,
        params.password,
      );

      return result.fold((failure) => Left(failure), (token) async {
        // Save token to shared preferences
        final saveTokenResult = await _tokenSharedPrefs.saveToken(token);
        return saveTokenResult.fold((failure) => Left(failure), (_) async {
          // Set login status to true
          await _sharedPreferences.setBool('isLoggedIn', true);

          // Extract and store user ID from token or response
          // For now, we'll use a simple approach - store the email as user identifier
          // In a real app, you'd decode the JWT token to get the user ID
          await _sharedPreferences.setString('userEmail', params.email);

          return Right(token);
        });
      });
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
