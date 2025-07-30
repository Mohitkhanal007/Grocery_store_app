import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserRegisterUsecase userRegisterUsecase;

  const tUsername = 'testuser';
  const tEmail = 'test@example.com';
  const tPassword = 'securepassword';
  const tAddress = '123 Test Street, Test City';

  const tParams = RegisterUserParams(
    username: tUsername,
    email: tEmail,
    password: tPassword,
    address: tAddress,
  );

  const tUserEntity = UserEntity(
    username: tUsername,
    email: tEmail,
    password: tPassword,
    address: tAddress,
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    userRegisterUsecase = UserRegisterUsecase(
      userRepository: mockUserRepository,
    );

    registerFallbackValue(
      const UserEntity(
        username: 'fallback_username',
        email: 'fallback@example.com',
        password: 'fallback_password',
        address: 'fallback_address',
      ),
    );
  });

  test('returns void on successful registration', () async {
    // Arrange
    when(
      () => mockUserRepository.registerUser(any()),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await userRegisterUsecase(tParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockUserRepository.registerUser(tUserEntity)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('returns failure on registration error', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Registration failed');

    when(
      () => mockUserRepository.registerUser(any()),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await userRegisterUsecase(tParams);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockUserRepository.registerUser(tUserEntity)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
