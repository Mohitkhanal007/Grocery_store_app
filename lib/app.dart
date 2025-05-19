import 'package:flutter/material.dart';
import 'package:jerseyhub/view/splash_screenview.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SplashScreenview (),
      debugShowCheckedModeBanner: false,
    );
  }
}
