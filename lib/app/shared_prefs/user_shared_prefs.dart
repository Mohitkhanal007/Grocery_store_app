import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefs {
  final SharedPreferences _sharedPreferences;

  UserSharedPrefs(this._sharedPreferences);

  // Get current user email (used as identifier)
  String? getCurrentUserEmail() {
    return _sharedPreferences.getString('userEmail');
  }

  // Set current user email
  Future<void> setCurrentUserEmail(String email) async {
    await _sharedPreferences.setString('userEmail', email);
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _sharedPreferences.getString('userId');
  }

  // Set current user ID
  Future<void> setCurrentUserId(String userId) async {
    await _sharedPreferences.setString('userId', userId);
  }

  // Clear user data on logout
  Future<void> clearUserData() async {
    await _sharedPreferences.remove('userEmail');
    await _sharedPreferences.setBool('isLoggedIn', false);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _sharedPreferences.getBool('isLoggedIn') ?? false;
  }
}
