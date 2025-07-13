import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create a UserModel with correct values', () {
      final user = UserModel(
        name: 'John',
        email: 'john@mail.com',
        password: 'pass123',
      );
      expect(user.name, 'John');
      expect(user.email, 'john@mail.com');
      expect(user.password, 'pass123');
    });
  });
}
