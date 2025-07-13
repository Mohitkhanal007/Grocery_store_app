import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:my_flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_flutter_app/features/auth/presentation/bloc/login_bloc.dart';

// Fake repository implementation for testing
class FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> login(UserEntity user) async {
    if (user.email == 'test@example.com' && user.password == '1234') {
      return true;
    }
    return false;
  }
}

void main() {
  late LoginBloc loginBloc;
  late LoginUseCase loginUseCase;

  setUp(() {
    loginUseCase = LoginUseCase(FakeAuthRepository());
    loginBloc = LoginBloc(loginUseCase);
  });

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginSuccess] when login is successful',
    build: () => loginBloc,
    act: (bloc) => bloc.add(LoginSubmitted(email: 'test@example.com', password: '1234')),
    expect: () => [LoginLoading(), LoginSuccess()],
  );

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginFailure] when login fails',
    build: () => loginBloc,
    act: (bloc) => bloc.add(LoginSubmitted(email: 'wrong@mail.com', password: 'wrong')),
    expect: () => [LoginLoading(), isA<LoginFailure>()],
  );
}
