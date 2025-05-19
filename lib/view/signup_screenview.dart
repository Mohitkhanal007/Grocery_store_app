import 'package:flutter/material.dart';
import 'package:jerseyhub/view/login_screenview.dart';

class SignupScreenview extends StatefulWidget {
  const SignupScreenview({super.key});

  @override
  State<SignupScreenview> createState() => _SignupScreenviewState();
}

class _SignupScreenviewState extends State<SignupScreenview> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  void _register() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlertDialog(
        title: "Missing Fields",
        content: "Please fill in all the fields before registering.",
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

    _showAlertDialog(
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
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

                  /// Username Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  /// Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

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
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  /// SignUp Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  /// Already Have Account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreenview()),
                          );
                        },
                        child: Text(
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
