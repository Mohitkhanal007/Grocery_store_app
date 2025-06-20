import 'package:hive_flutter/hive_flutter.dart';
import 'package:jerseyhub/app/constant/hive_table_constant.dart';
import 'package:jerseyhub/features/auth/data/model/user_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String currentUserKey = 'currentUser';

  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/jersey.db';
    Hive.init(directory.path);

    Hive.registerAdapter(UserHiveModelAdapter());
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
  }

  // Register (add user)
  Future<void> register(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  // Delete user by ID
  Future<void> deleteUser(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  // Get all users
  Future<List<UserHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login and save current user
  Future<UserHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      final user = box.values.firstWhere(
            (u) => u.username == username && u.password == password,
      );
      // Save logged-in user
      await box.put(currentUserKey, user);
      return user;
    } catch (_) {
      return null;
    }
  }

  // Get currently logged-in user
  Future<UserHiveModel?> getCurrentUser() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.get(currentUserKey);
  }

  // Clear all boxes and data
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Close Hive
  Future<void> close() async {
    await Hive.close();
  }
}
