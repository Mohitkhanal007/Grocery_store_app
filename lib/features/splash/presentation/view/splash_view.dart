import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/auth/presentation/view/login_view.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jerseyhub/features/home/presentation/view/HomePage.dart';
import 'package:jerseyhub/features/home/presentation/viewmodel/homepage_viewmodel.dart';
import 'package:jerseyhub/features/splash/presentation/view_model/splash_view_model.dart';

class SplashScreenView extends StatefulWidget {
  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().decideNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state == SplashState.navigateToHome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => serviceLocator<HomeViewModel>(),
                child: const HomePage(),
              ),
            ),
          );
        } else if (state == SplashState.navigateToLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/image.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
