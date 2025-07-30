import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view/login_view.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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

    context.read<RegisterViewModel>().add(
      RegisterUserEvent(
        context: context,
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
      child: Builder(
        builder: (context) {
          return BlocListener<RegisterViewModel, RegisterState>(
            listener: (context, state) {
              if (state.isSuccess) {
                _usernameController.clear();
                _emailController.clear();
                _passwordController.clear();
              }
            },
            child: BlocBuilder<RegisterViewModel, RegisterState>(
              builder: (context, state) {
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

                      /// Overlay for readability
                      Positioned.fill(
                        child: Container(color: Colors.black.withOpacity(0.4)),
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
                                decoration: _fieldDecoration(),
                                child: TextFormField(
                                  key: const Key('usernameField'),
                                  controller: _usernameController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: _inputDecoration(
                                    "Enter Username",
                                    Icons.person,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              /// Email Field
                              Container(
                                decoration: _fieldDecoration(),
                                child: TextFormField(
                                  key: const Key('emailField'),
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: _inputDecoration(
                                    "Enter Email",
                                    Icons.email,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              /// Password Field
                              Container(
                                decoration: _fieldDecoration(),
                                child: TextFormField(
                                  key: const Key('passwordField'),
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: _inputDecoration(
                                    "Enter Password",
                                    Icons.lock,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              /// SignUp Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  key: const Key('signUpButton'),
                                  onPressed: state.isLoading
                                      ? null
                                      : () => _register(context),
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
                                          builder: (context) => LoginView(),
                                        ),
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
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔧 Helper for consistent input box styling
  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.4),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white54),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.black),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    );
  }
}
