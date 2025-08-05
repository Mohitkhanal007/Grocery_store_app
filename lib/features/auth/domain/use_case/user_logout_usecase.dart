import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/shared_prefs/token_shared_prefs.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/auth/domain/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogoutUseCase {
  final IUserRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUseCase({
    required IUserRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _repository = repository,
       _tokenSharedPrefs = tokenSharedPrefs;

  Future<Either<Failure, void>> call() async {
    try {
      // Clear authentication token from shared preferences
      final clearTokenResult = await _tokenSharedPrefs.clearToken();
      if (clearTokenResult.isLeft()) {
        return clearTokenResult;
      }

      // Clear login status from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Call repository logout method to clear API service headers
      final logoutResult = await _repository.logout();
      if (logoutResult.isLeft()) {
        return logoutResult;
      }

      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
