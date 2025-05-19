import 'package:flutter/material.dart';
import 'package:jerseyhub/view/dashboard_screenview.dart';
import 'package:jerseyhub/view/signup_screenview.dart';

class LoginScreenview extends StatefulWidget {
  const LoginScreenview({super.key});

  @override
  State<LoginScreenview> createState() => _LoginScreenviewState();
}

class _LoginScreenviewState extends State<LoginScreenview> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showAlertDialog(
        title: "Missing Fields",
        content: "Please enter both the username and password to login.",
      );
      return;
    }

    if (password.length < 6) {
      _showAlertDialog(
        title: "Weak Password",
        content: "Password must be at least 6 characters long.",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreenview()),
    );
  }

  void _showAlertDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image - fills entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Optional overlay for better text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// Foreground content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 80),

                    /// Username
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Enter Username",
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.person, color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// Password
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupScreenview()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
