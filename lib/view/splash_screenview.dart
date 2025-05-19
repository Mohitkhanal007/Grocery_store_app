import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jerseyhub/view/login_screenview.dart';

class SplashScreenview extends StatefulWidget {
  const SplashScreenview({super.key});

  @override
  State<SplashScreenview> createState() => _SplashScreenviewState();
}

class _SplashScreenviewState extends State<SplashScreenview> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenview()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Loading Indicator
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}