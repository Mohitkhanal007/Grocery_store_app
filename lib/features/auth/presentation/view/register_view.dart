import 'package:flutter/material.dart';
import 'package:jerseyhub/features/auth/presentation/view/login_screenview.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showAlertDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlertDialog(
        context,
        title: "Missing Fields",
        content: "Please fill in all the fields before registering.",
      );
      return;
    }

    if (password.length < 6) {
      _showAlertDialog(
        context,
        title: "Weak Password",
        content: "Password must be at least 6 characters long.",
      );
      return;
    }

    _showAlertDialog(
      context,
      title: "Success",
      content: "You have been registered successfully!",
    );

    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Optional overlay for readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// Centered Signup Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// Username Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Enter Username",
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white54),
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
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// SignUp Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Already Have Account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginView()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
