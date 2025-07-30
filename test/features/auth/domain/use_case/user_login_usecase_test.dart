import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserLoginUsecase userLoginUsecase;

  const tEmail = 'test@example.com';
  const tPassword = 'securepassword';
  const tToken = 'mock_token_123';

  const tParams = LoginParams(email: tEmail, password: tPassword);

  setUp(() {
    mockUserRepository = MockUserRepository();
    userLoginUsecase = UserLoginUsecase(userRepository: mockUserRepository);

    registerFallbackValue(const LoginParams.initial());
  });

  test('returns token on successful login', () async {
    // Arrange
    when(
      () => mockUserRepository.loginUser(any(), any()),
    ).thenAnswer((_) async => const Right(tToken));

    // Act
    final result = await userLoginUsecase(tParams);

    // Assert
    expect(result, const Right(tToken));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('returns failure on login error', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Login failed');

    when(
      () => mockUserRepository.loginUser(any(), any()),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await userLoginUsecase(tParams);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
