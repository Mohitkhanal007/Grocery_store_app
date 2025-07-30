import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SplashState { initial, navigateToHome, navigateToLogin }

class SplashViewModel extends Cubit<SplashState> {
  SplashViewModel() : super(SplashState.initial);

  Future<void> decideNavigation() async {
    // Increased delay to allow users to see the beautiful animations
    await Future.delayed(const Duration(seconds: 4));
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(SplashState.navigateToHome);
    } else {
      emit(SplashState.navigateToLogin);
    }
  }
}
