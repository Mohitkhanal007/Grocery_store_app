import 'package:hive_flutter/hive_flutter.dart';
import 'package:jerseyhub/features/auth/data/model/user_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String userBoxName = 'userBox';
  static const String currentUserKey = 'currentUser';

  /// Initialize Hive and register adapters
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory(); // safer than cache
    Hive.init(directory.path);

    Hive.registerAdapter(UserHiveModelAdapter());

    // Open the box
    await Hive.openBox<UserHiveModel>(userBoxName);
  }

  /// Register (store) a user locally
  Future<void> register(UserHiveModel userHiveModel) async {
    final box = Hive.box<UserHiveModel>(userBoxName);
    await box.put(currentUserKey, userHiveModel); // Overwrites existing user
  }

  /// Login user (returns user model if email matches)
  Future<UserHiveModel?> login(String email, String password) async {
    final box = Hive.box<UserHiveModel>(userBoxName);
    final user = box.get(currentUserKey);

    if (user != null && user.email == email) {
      return user;
    }

    return null;
  }

  /// Retrieve currently logged in user
  Future<UserHiveModel?> getCurrentUser() async {
    final box = Hive.box<UserHiveModel>(userBoxName);
    return box.get(currentUserKey);
  }

  /// Clear user data (e.g., on logout)
  Future<void> logout() async {
    final box = Hive.box<UserHiveModel>(userBoxName);
    await box.delete(currentUserKey);
  }
}
