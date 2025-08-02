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
    // Note: We don't clear userId or profileImage to persist user data
  }

  // Get profile image URL
  String? getProfileImageUrl() {
    return _sharedPreferences.getString('profileImageUrl');
  }

  // Set profile image URL
  Future<void> setProfileImageUrl(String imageUrl) async {
    await _sharedPreferences.setString('profileImageUrl', imageUrl);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _sharedPreferences.getBool('isLoggedIn') ?? false;
  }
}
