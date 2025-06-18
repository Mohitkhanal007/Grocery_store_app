import 'package:jerseyhub/core/network/hive_service.dart';
import 'package:jerseyhub/features/auth/data/model/user_hive_model.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';

abstract class IUserDataSource {
  Future<String> loginUser(String username, String password);
  Future<void> registerUser(UserEntity user);
  Future<String> uploadProfilePicture(String filePath);
  Future<UserEntity> getCurrentUser();
}

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService}) : _hiveService = hiveService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final userData = await _hiveService.login(username, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) {
    // If you don't need profile pictures for now, throw unimplemented
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final userHiveModel = await _hiveService.getCurrentUser();
      if (userHiveModel == null) {
        throw Exception("No user logged in");
      }
      return userHiveModel.toEntity();
    } catch (e) {
      throw Exception("Failed to get current user: $e");
    }
  }
}
