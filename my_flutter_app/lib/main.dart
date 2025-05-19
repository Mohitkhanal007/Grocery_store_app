import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const LoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
    },
  ));
}

class GroceryStoreApp extends StatelessWidget {
  const GroceryStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
