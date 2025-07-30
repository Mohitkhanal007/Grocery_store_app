import 'package:dartz/dartz.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';

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

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      username: params.username,
      email: params.email,
      password: params.password,
      address: params.address,
    );

    return _userRepository.registerUser(userEntity);
  }
}
