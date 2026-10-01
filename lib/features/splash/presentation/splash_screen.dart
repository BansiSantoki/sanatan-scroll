import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _startSplash();
  }

  void _startSplash() {
    _animationController.forward();

    _navigationTimer = Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      try {
        await Firebase.initializeApp();
      } catch (_) {}

      if (!mounted) return;
      String nextRoute = AppRoutes.auth;
      try {
        if (FirebaseAuth.instance.currentUser != null) {
          nextRoute = AppRoutes.main;
        }
      } catch (_) {}

      Navigator.of(context).pushReplacementNamed(nextRoute);
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF6),
      body: SizedBox.expand(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/sanatan_splash_full.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFFFFDF6),
                child: const Center(
                  child: Text(
                    'Sanatan Scroll',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3B2E),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
