import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Mock class for the use case
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

// Register fallback value for LoginParams
class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late MockUserLoginUsecase mockUsecase;
  late LoginViewModel loginBloc;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  // Create test LoginResult
  final testLoginResult = LoginResult(
    token: 'token123',
    user: const UserEntity(
      id: 'test_user_id',
      username: 'Test User',
      email: 'test@example.com',
      password: '',
      address: 'Test Address',
    ),
  );

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockUsecase = MockUserLoginUsecase();
    loginBloc = LoginViewModel(mockUsecase);
  });

  test('initial state is LoginState.initial()', () {
    expect(loginBloc.state, const LoginState.initial());
  });

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(
        () => mockUsecase.call(any()),
      ).thenAnswer((_) async => Right(testLoginResult));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LoginWithEmailAndPasswordEvent(email: testEmail, password: testPassword),
    ),
    expect: () => [
      const LoginState(isLoading: true, isSuccess: false, errorMessage: ''),
      const LoginState(isLoading: false, isSuccess: true, errorMessage: ''),
    ],
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [navigateToRegister = true] when NavigateToRegisterViewEvent is added',
    build: () => loginBloc,
    act: (bloc) => bloc.add(NavigateToRegisterViewEvent()),
    expect: () => [
      const LoginState(
        isLoading: false,
        isSuccess: false,
        navigateToRegister: true,
        errorMessage: '',
      ),
    ],
  );
}
