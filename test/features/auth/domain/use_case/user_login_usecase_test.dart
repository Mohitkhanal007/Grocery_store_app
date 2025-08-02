import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/shared_prefs/token_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late MockSharedPreferences mockSharedPreferences;
  late UserLoginUsecase userLoginUsecase;

  const tEmail = 'test@example.com';
  const tPassword = 'securepassword';
  const tToken = 'mock_token_123';

  const tParams = LoginParams(email: tEmail, password: tPassword);

  // Create test LoginResult
  final tLoginResult = LoginResult(
    token: tToken,
    user: const UserEntity(
      id: 'test_user_id',
      username: 'Test User',
      email: tEmail,
      password: '',
      address: 'Test Address',
    ),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    mockSharedPreferences = MockSharedPreferences();
    userLoginUsecase = UserLoginUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
      sharedPreferences: mockSharedPreferences,
    );

    registerFallbackValue(const LoginParams.initial());
  });

  test('returns LoginResult on successful login', () async {
    // Arrange
    when(
      () => mockUserRepository.loginUser(any(), any()),
    ).thenAnswer((_) async => Right(tLoginResult));

    when(
      () => mockTokenSharedPrefs.saveToken(any()),
    ).thenAnswer((_) async => const Right(null));

    when(
      () => mockSharedPreferences.setBool(any(), any()),
    ).thenAnswer((_) async => true);

    when(
      () => mockSharedPreferences.setString(any(), any()),
    ).thenAnswer((_) async => true);

    // Act
    final result = await userLoginUsecase(tParams);

    // Assert
    expect(result, Right(tLoginResult));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verify(() => mockSharedPreferences.setBool('isLoggedIn', true)).called(1);
    verify(
      () => mockSharedPreferences.setString('userId', 'test_user_id'),
    ).called(1);
    verify(
      () => mockSharedPreferences.setString('userEmail', tEmail),
    ).called(1);
    verifyNoMoreInteractions(mockUserRepository);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockSharedPreferences);
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
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockSharedPreferences);
  });

  test('returns failure when token save fails', () async {
    // Arrange
    const saveFailure = SharedPreferencesFailure(
      message: 'Failed to save token',
    );

    when(
      () => mockUserRepository.loginUser(any(), any()),
    ).thenAnswer((_) async => Right(tLoginResult));

    when(
      () => mockTokenSharedPrefs.saveToken(any()),
    ).thenAnswer((_) async => const Left(saveFailure));

    // Act
    final result = await userLoginUsecase(tParams);

    // Assert
    expect(result, const Left(saveFailure));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockSharedPreferences);
  });
}
