import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum representing the possible states for splash screen
enum SplashState {
  initial,
  navigateToLogin,
}

/// SplashViewModel controls the splash screen flow
class SplashViewModel extends Cubit<SplashState> {
  SplashViewModel() : super(SplashState.initial);

  /// Determines where to navigate after splash screen
  Future<void> decideNavigation() async {
    // Optional delay to simulate splash duration
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Since you only want login, we ignore isLoggedIn
    emit(SplashState.navigateToLogin);
  }
}
