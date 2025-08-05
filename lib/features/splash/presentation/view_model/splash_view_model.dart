import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SplashState { initial, navigateToHome, navigateToLogin }

class SplashViewModel extends Cubit<SplashState> {
  SplashViewModel() : super(SplashState.initial);

  Future<void> decideNavigation() async {
    // Increased delay to allow users to see the beautiful animations
    await Future.delayed(const Duration(seconds: 4));

    try {
      // Clear any existing user data to ensure fresh start
      await _clearInvalidUserData();

      print('🔄 SplashViewModel: Always navigating to login for fresh start');
      emit(SplashState.navigateToLogin);
    } catch (e) {
      print('❌ SplashViewModel: Error during navigation decision: $e');
      // On error, clear any potentially corrupted data and go to login
      await _clearInvalidUserData();
      emit(SplashState.navigateToLogin);
    }
  }

  /// Validate if the stored token is still valid
  Future<bool> _validateToken() async {
    try {
      final userSharedPrefs = serviceLocator<UserSharedPrefs>();
      final token = userSharedPrefs.getCurrentUserId();

      if (token == null || token.isEmpty) {
        return false;
      }

      // You can add additional token validation here if needed
      // For now, we'll just check if the token exists and is not empty
      return true;
    } catch (e) {
      print('❌ SplashViewModel: Token validation error: $e');
      return false;
    }
  }

  /// Clear invalid user data
  Future<void> _clearInvalidUserData() async {
    try {
      final userSharedPrefs = serviceLocator<UserSharedPrefs>();
      await userSharedPrefs.clearUserData();

      // Also clear any simulated or test data
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove('userUsername');
      await sharedPreferences.remove('userAddress');
      await sharedPreferences.remove('simulated_user_id');
      await sharedPreferences.remove('simulated_token');

      print('✅ SplashViewModel: All user data cleared for fresh start');
    } catch (e) {
      print('❌ SplashViewModel: Error clearing user data: $e');
    }
  }
}
