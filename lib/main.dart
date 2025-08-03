import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/splash/presentation/view/splash_view.dart';
import 'package:jerseyhub/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:jerseyhub/core/widgets/sensor_aware_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(); // Initialize all dependencies before running app

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<SplashViewModel>()),
        // You can add more BlocProviders here if needed
      ],
      child: SensorAwareWidget(
        onThemeChanged: (bool isDarkMode) {
          print('🎨 Theme changed to: ${isDarkMode ? "Dark" : "Light"} mode');
        },
        onRefreshRequested: () {
          print('🔄 Refresh requested via shake sensor');
          // You can add global refresh logic here
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreenView(),
        ),
      ),
    ),
  );
}
