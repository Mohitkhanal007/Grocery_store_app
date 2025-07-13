import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/login_usecase.dart';

// Paste or import your FakeAuthRepository here
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
  late LoginUseCase usecase;

  setUp(() {
    usecase = LoginUseCase(FakeAuthRepository());
  });

  test('should return true when correct credentials are given', () async {
    final user = UserEntity(email: 'test@example.com', password: '1234');

    final result = await usecase(user);

    expect(result, true);
  });

  test('should return false when wrong credentials are given', () async {
    final user = UserEntity(email: 'wrong@mail.com', password: 'wrong');

    final result = await usecase(user);

    expect(result, false);
  });
}
