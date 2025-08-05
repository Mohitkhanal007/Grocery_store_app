import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/splash/presentation/view/splash_view.dart';
import 'package:grocerystore/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:grocerystore/core/theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(); // Initialize all dependencies before running app

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<SplashViewModel>()),
        // You can add more BlocProviders here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, child) {
        return MaterialApp(
          title: 'GroceryStore',
          debugShowCheckedModeBanner: false,
          theme: ThemeManager().getTheme(),
          home: BlocProvider(
            create: (context) => serviceLocator<SplashViewModel>(),
            child: const SplashScreenView(),
          ),
        );
      },
    );
  }
}
