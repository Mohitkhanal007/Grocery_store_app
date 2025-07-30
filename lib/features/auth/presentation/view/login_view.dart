import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view/register_view.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:jerseyhub/features/home/presentation/view/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
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

  void _login(BuildContext context) {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showAlertDialog(
        context,
        title: "Missing Fields",
        content: "Please enter both email and password.",
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

    context.read<LoginViewModel>().add(
      LoginWithEmailAndPasswordEvent(email: username, password: password),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(serviceLocator<UserLoginUsecase>()),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) async {
              if (state.isSuccess) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login successful!'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              } else if (state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<LoginViewModel, LoginState>(
              builder: (context, state) {
                return Scaffold(
                  body: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/login.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Overlay
                      Positioned.fill(
                        child: Container(color: Colors.black.withOpacity(0.4)),
                      ),

                      // Content
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

                                // Email TextField
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: TextFormField(
                                    key: const Key('emailField'),
                                    controller: _usernameController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: "Enter Email",
                                      hintStyle: TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 10,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 50),

                                // Password TextField
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: TextFormField(
                                    key: const Key('passwordField'),
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: "Enter Password",
                                      hintStyle: TextStyle(color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 10,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    key: const Key('loginButton'),
                                    onPressed: state.isLoading
                                        ? null
                                        : () => _login(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(
                                        0.7,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: state.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // Sign Up link
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
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterView(),
                                          ),
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
              },
            ),
          );
        },
      ),
    );
  }
}
