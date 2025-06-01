import 'package:flutter/material.dart';
import 'package:jerseyhub/theme/theme_data.dart';
import 'package:jerseyhub/view/splash_screenview.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(), // Apply your custom theme here
      home: const SplashScreenview(),
    );
  }
}