import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/auth/presentation/view/login_view.dart';
import 'package:grocerystore/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:grocerystore/features/home/presentation/view/home_page.dart';
import 'package:grocerystore/features/home/presentation/viewmodel/homepage_viewmodel.dart';
import 'package:grocerystore/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:grocerystore/core/network/connection_test.dart';
import 'dart:math' as math;

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _rotateController.repeat();
    _particleController.repeat();

    // Trigger navigation decision
    context.read<SplashViewModel>().decideNavigation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  Widget _buildFloatingParticle(double x, double y, double size, Color color) {
    return Positioned(
      left: x,
      top: y,
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(_particleController.value * 2 * math.pi + x) * 20,
            ),
            child: Opacity(
              opacity:
                  0.6 +
                  0.4 * math.sin(_particleController.value * 2 * math.pi + y),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroceryStoreLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.shopping_basket,
        size: 60,
        color: Colors.purple.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state == SplashState.navigateToHome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => serviceLocator<HomeViewModel>(),
                child: const HomePage(),
              ),
            ),
          );
        } else if (state == SplashState.navigateToLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade900,
                Colors.purple.shade700,
                Colors.purple.shade500,
                Colors.purple.shade300,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Floating particles
              _buildFloatingParticle(50, 100, 8, Colors.white.withOpacity(0.3)),
              _buildFloatingParticle(
                300,
                150,
                6,
                Colors.purple.withOpacity(0.4),
              ),
              _buildFloatingParticle(
                100,
                300,
                10,
                Colors.purple.withOpacity(0.3),
              ),
              _buildFloatingParticle(
                350,
                400,
                7,
                Colors.white.withOpacity(0.2),
              ),
              _buildFloatingParticle(
                80,
                500,
                5,
                Colors.purple.withOpacity(0.4),
              ),
              _buildFloatingParticle(
                320,
                600,
                9,
                Colors.purple.withOpacity(0.3),
              ),

              // Main content
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo Container
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 250,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(child: _buildGroceryStoreLogo()),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App Name with Typing Effect
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'GROCERY STORE',
                          style: TextStyle(
                            fontFamily: 'OpenSans Bold',
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Fresh Groceries at Your Doorstep',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontFamily: 'OpenSans Regular',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Debug Connection Test Button (only in debug mode)
                      if (const bool.fromEnvironment('dart.vm.product') ==
                          false)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ConnectionTest.runAllTests();
                            },
                            icon: const Icon(Icons.wifi, color: Colors.white),
                            label: const Text(
                              'Test Backend Connection',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 60),

                      // Loading Indicator
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Loading Text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Animated Dots
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 600),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
