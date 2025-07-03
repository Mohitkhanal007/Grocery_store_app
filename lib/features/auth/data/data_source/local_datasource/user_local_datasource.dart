import 'package:jerseyhub/core/network/hive_service.dart';
import 'package:jerseyhub/features/auth/data/data_source/user_data_source.dart';
import 'package:jerseyhub/features/auth/data/model/user_hive_model.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService}) : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null) {
        return "Login successful";
      } else {
        throw Exception("Invalid email or password");
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
  Future<UserEntity> getCurrentUser(String id) async {
    final users = await _hiveService.getAllUsers();
    if (users.isNotEmpty) {
      return users.first.toEntity(); // You might update logic later
    } else {
      throw Exception("No user found in Hive.");
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
