import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/splash/presentation/view/splash_view.dart';
import 'package:jerseyhub/features/splash/presentation/view_model/splash_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();  // Initialize all dependencies before running app

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<SplashViewModel>()),
        // You can add more BlocProviders here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenView(),
      ),
    ),
  );
}
