import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/user_login_usecase.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity user);

  Future<LoginResult> loginUser(String username, String password);

  Future<String> uploadProfilePicture(String filePath);

  Future<UserEntity> getCurrentUser(String id);

  Future<void> logout();
}
