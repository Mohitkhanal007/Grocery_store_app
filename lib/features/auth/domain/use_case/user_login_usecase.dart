import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';

class LoginParams extends Equatable{
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  const LoginParams.initial():email='',password='';

  @override
  List<Object?> get props => [email, password];
}
class UserLoginUsecase implements UsecaseWithParams<String, LoginParams>{
  final IUserRepository _userRepository;

  UserLoginUsecase({required IUserRepository userRepository})
  :_userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _userRepository.loginUser(
      params.email,
      params.password,
    );
  }
}