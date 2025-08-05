import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/auth/domain/entity/user_entity.dart';
import 'package:grocerystore/features/auth/domain/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUserParams {
  final String username;
  final String email;
  final String password;
  final String address;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.password,
    required this.address,
  });
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;
  final SharedPreferences _sharedPreferences;

  UserRegisterUsecase({
    required IUserRepository userRepository,
    required SharedPreferences sharedPreferences,
  }) : _userRepository = userRepository,
       _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    final userEntity = UserEntity(
      username: params.username,
      email: params.email,
      password: params.password,
      address: params.address,
    );

    final result = await _userRepository.registerUser(userEntity);

    return result.fold((failure) => Left(failure), (_) async {
      // Store user data in SharedPreferences after successful registration
      await _sharedPreferences.setString('userEmail', params.email);
      await _sharedPreferences.setString('userUsername', params.username);
      await _sharedPreferences.setString('userAddress', params.address);
      print(
        '✅ UserRegisterUsecase: Saved user data - Email: ${params.email}, Username: ${params.username}',
      );
      return const Right(null);
    });
  }
}
