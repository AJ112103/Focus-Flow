import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focus/pages/home_screen.dart';
import 'package:focus/services/firebase_auth_methods.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleFactor = screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image with Fade-In
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login_bg.png'),
                        fit: BoxFit.cover,
                        opacity: 0.48,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Glowing Orb Effect
            Center(
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(0.2),
                      Colors.black.withOpacity(0.1),
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            ),
            // Content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    // Welcome Text with Animated Underline
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'Welcome to FocusFlow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -5 * scaleFactor,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: screenWidth * 0.5),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOut,
                            builder: (context, width, child) {
                              return Container(
                                height: 2 * scaleFactor,
                                width: width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.1),
                                      Colors.blueAccent,
                                      Colors.blue.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Lottie Animation
                    SizedBox(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.3,
                      child: Lottie.asset(
                        'assets/animations/login_animation.json',
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Larger Tagline
                    Text(
                      'Start your journey to productivity!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * scaleFactor,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Secondary Slogan
                    Text(
                      'Focus. Achieve. Succeed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 * scaleFactor,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    // Google Login Button with Scale Animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.9, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: _buildGoogleLoginButton(scaleFactor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton(double scaleFactor) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: screenWidth * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12 * scaleFactor),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 10 * scaleFactor,
            spreadRadius: 2 * scaleFactor,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _promptForGoogleSignIn, // Triggers pop-up
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16 * scaleFactor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * scaleFactor),
          ),
        ),
        icon: Icon(
          Icons.g_translate,
          color: Colors.white,
          size: 24 * scaleFactor,
        ),
        label: Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _promptForGoogleSignIn() {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.06),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[900]!.withOpacity(0.95),
                Colors.black.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In with Google',
                style: TextStyle(
                  fontSize: 22 * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                'To sync your tasks with Google Calendar:\n'
                '1. If you see "Google hasn’t verified this app", tap "Advanced".\n'
                '2. Then tap "Go to FocusFlow (unsafe)" at the bottom.\n'
                'We’re safe—just awaiting Google’s verification!',
                style: TextStyle(
                  fontSize: 14 * scaleFactor,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleGoogleSignIn();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.025,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16 * scaleFactor,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FocusFlowHome()),
      );
    } else {
      _showErrorSnackBar('Google login failed.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
