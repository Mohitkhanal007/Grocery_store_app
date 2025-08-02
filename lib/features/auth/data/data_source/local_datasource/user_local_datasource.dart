import 'package:jerseyhub/core/network/hive_service.dart';
import 'package:jerseyhub/features/auth/data/data_source/user_data_source.dart';
import 'package:jerseyhub/features/auth/data/model/user_hive_model.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<LoginResult> loginUser(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null) {
        // Create a LoginResult with mock data for local storage
        final user = UserEntity(
          id: 'local_user_id',
          username: userData.username,
          email: userData.email,
          password: '',
          address: userData.address,
        );

        return LoginResult(
          token: 'local_token_${DateTime.now().millisecondsSinceEpoch}',
          user: user,
        );
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

  @override
  Future<void> logout() async {
    try {
      // Clear all Hive data
      await _hiveService.clearAll();
      print('Local logout successful - Hive data cleared');
    } catch (e) {
      throw Exception('Failed to logout from local storage: $e');
    }
  }
}
