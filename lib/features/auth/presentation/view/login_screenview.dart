import 'package:flutter/material.dart';
import 'package:jerseyhub/features/auth/presentation/view/register_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showAlertDialog(context,
        title: "Missing Fields",
        content: "Please enter both the username and password to login.",
      );
      return;
    }

    if (password.length < 6) {
      _showAlertDialog(context,
        title: "Weak Password",
        content: "Password must be at least 6 characters long.",
      );
      return;
    }

    // Navigate or other login logic
  }

  void _showAlertDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(ctx).pop(),
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
                        fontFamily: 'OpenSans Bold',
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
                        onPressed: () => _login(context),
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
                              MaterialPageRoute(builder: (context) => RegisterView()),
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
