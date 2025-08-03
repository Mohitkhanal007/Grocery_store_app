import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/repository/auth_repository.dart';
import 'package:jerseyhub/features/auth/data/repository/auth_repository_impl.dart';
import 'package:jerseyhub/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:jerseyhub/features/auth/data/data_source/local_datasource/user_local_datasource.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepository Tests', () {
    const testUser = UserEntity(
      id: 'test_id',
      username: 'testuser',
      email: 'test@example.com',
      address: 'Test Address',
    );

    const testToken = 'test_token';

    test('should return LoginResult when remote login is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Right(LoginResult(token: testToken, user: testUser)));

      // Act
      final result = await authRepository.login('test@example.com', 'password');

      // Assert
      expect(result, isA<Right<Failure, LoginResult>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (loginResult) {
          expect(loginResult.token, equals(testToken));
          expect(loginResult.user, equals(testUser));
        },
      );
      verify(() => mockRemoteDataSource.login('test@example.com', 'password')).called(1);
    });

    test('should return failure when remote login fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Login failed')));

      // Act
      final result = await authRepository.login('test@example.com', 'password');

      // Assert
      expect(result, isA<Left<Failure, LoginResult>>());
      result.fold(
        (failure) => expect(failure.message, equals('Login failed')),
        (loginResult) => fail('Should not return success'),
      );
    });

    test('should return UserEntity when remote registration is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.register(any(), any(), any(), any()))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await authRepository.register('testuser', 'test@example.com', 'password', 'Test Address');

      // Assert
      expect(result, isA<Right<Failure, UserEntity>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) => expect(user, equals(testUser)),
      );
    });

    test('should return failure when remote registration fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.register(any(), any(), any(), any()))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Registration failed')));

      // Act
      final result = await authRepository.register('testuser', 'test@example.com', 'password', 'Test Address');

      // Assert
      expect(result, isA<Left<Failure, UserEntity>>());
      result.fold(
        (failure) => expect(failure.message, equals('Registration failed')),
        (user) => fail('Should not return success'),
      );
    });

    test('should return UserEntity when getting current user from local storage', () async {
      // Arrange
      when(() => mockLocalDataSource.getCurrentUser())
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await authRepository.getCurrentUser();

      // Assert
      expect(result, isA<Right<Failure, UserEntity>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) => expect(user, equals(testUser)),
      );
    });

    test('should return failure when local storage has no current user', () async {
      // Arrange
      when(() => mockLocalDataSource.getCurrentUser())
          .thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'No user found')));

      // Act
      final result = await authRepository.getCurrentUser();

      // Assert
      expect(result, isA<Left<Failure, UserEntity>>());
      result.fold(
        (failure) => expect(failure.message, equals('No user found')),
        (user) => fail('Should not return success'),
      );
    });

    test('should return success when logout is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockLocalDataSource.logout()).called(1);
    });

    test('should return failure when logout fails', () async {
      // Arrange
      when(() => mockLocalDataSource.logout())
          .thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'Logout failed')));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (failure) => expect(failure.message, equals('Logout failed')),
        (_) => fail('Should not return success'),
      );
    });

    test('should return success when updating profile picture', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateProfilePicture(any()))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await authRepository.updateProfilePicture('test_image_path');

      // Assert
      expect(result, isA<Right<Failure, UserEntity>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) => expect(user, equals(testUser)),
      );
    });

    test('should return failure when profile picture update fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateProfilePicture(any()))
          .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Update failed')));

      // Act
      final result = await authRepository.updateProfilePicture('test_image_path');

      // Assert
      expect(result, isA<Left<Failure, UserEntity>>());
      result.fold(
        (failure) => expect(failure.message, equals('Update failed')),
        (user) => fail('Should not return success'),
      );
    });
  });
} 