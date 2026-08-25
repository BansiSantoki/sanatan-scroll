import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final AnimationController _loadingController;

  late final Animation<double> _logoFadeAnimation;
  late final Animation<Offset> _logoSlideAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotateAnimation;

  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _textScaleAnimation;

  late final Animation<double> _pulseAnimation;

  Timer? _pulseStartTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // =========================
    // MAIN ENTRANCE ANIMATION
    // =========================
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // =========================
    // LOGO PULSE ANIMATION
    // =========================
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // =========================
    // LOADING ROTATION ANIMATION
    // =========================
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // =========================
    // LOGO FADE
    // =========================
    _logoFadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.0,
        0.35,
        curve: Curves.easeOut,
      ),
    );

    // =========================
    // LOGO SLIDE FROM BOTTOM
    // =========================
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.55),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.60,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // =========================
    // LOGO ZOOM
    // =========================
    _logoScaleAnimation = Tween<double>(
      begin: 0.45,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // =========================
    // LOGO SMALL ROTATION
    // =========================
    _logoRotateAnimation = Tween<double>(
      begin: -0.10,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.60,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // =========================
    // TEXT FADE
    // =========================
    _textFadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.48,
        0.85,
        curve: Curves.easeOut,
      ),
    );

    // =========================
    // TEXT SLIDE
    // =========================
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.48,
          0.90,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // =========================
    // TEXT SCALE
    // =========================
    _textScaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.48,
          0.95,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // =========================
    // CONTINUOUS LOGO PULSE
    // =========================
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.045,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Start logo and text animation
    _mainController.forward();

    // Start rotating loading circle immediately
    _loadingController.repeat();

    // Start logo pulse after entrance
    _pulseStartTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });

    // =========================
    // TOTAL SPLASH TIME = 4 SECONDS
    // =========================
    _navigationTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      final nextRoute = FirebaseAuth.instance.currentUser == null
          ? AppRoutes.auth
          : AppRoutes.main;
      Navigator.of(context).pushReplacementNamed(nextRoute);
    });
  }

  @override
  void dispose() {
    _pulseStartTimer?.cancel();
    _navigationTimer?.cancel();
    _mainController.dispose();
    _pulseController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive logo size
    final logoSize = size.shortestSide < 400
        ? 125.0
        : size.shortestSide < 600
            ? 150.0
            : 185.0;

    final horizontalPadding = size.width < 400 ? 20.0 : 24.0;

    final titleFontSize = size.shortestSide < 400
        ? 27.0
        : size.shortestSide < 600
            ? 30.0
            : 34.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // =========================
        // GOLDEN MATCHING GRADIENT
        // =========================
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 165, 118, 37),
              Color.fromARGB(255, 233, 202, 155),
              Color.fromARGB(255, 212, 169, 109),
              Color.fromARGB(255, 192, 162, 117),
            ],
            stops: [
              0.0,
              0.35,
              0.65,
              1.0,
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // =========================
              // CENTER CONTENT
              // =========================
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // =========================
                          // ANIMATED LOGO
                          // =========================
                          FadeTransition(
                            opacity: _logoFadeAnimation,
                            child: SlideTransition(
                              position: _logoSlideAnimation,
                              child: RotationTransition(
                                turns: _logoRotateAnimation,
                                child: AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: child,
                                    );
                                  },
                                  child: ScaleTransition(
                                    scale: _logoScaleAnimation,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        size.shortestSide < 400 ? 10 : 14,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.16,
                                            ),
                                            blurRadius: 25,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/sanatan_logo.png',
                                        width: logoSize,
                                        height: logoSize,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.self_improvement_rounded,
                                            size: logoSize * 0.7,
                                            color: Colors.black,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: size.height < 600 ? 16 : 22,
                          ),

                          // =========================
                          // ANIMATED APP NAME
                          // =========================
                          FadeTransition(
                            opacity: _textFadeAnimation,
                            child: SlideTransition(
                              position: _textSlideAnimation,
                              child: ScaleTransition(
                                scale: _textScaleAnimation,
                                child: Text(
                                  AppConstants.appName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // =========================
                          // SUBTITLE
                          // =========================
                          FadeTransition(
                            opacity: _textFadeAnimation,
                            child: Text(
                              'Wisdom for your journey',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.shortestSide < 400 ? 13 : 15,
                                color: Colors.black54,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // =========================
              // BOTTOM ROTATING LOADING
              // =========================
              Padding(
                padding: EdgeInsets.only(
                  bottom: size.height < 600 ? 24 : 38,
                ),
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: RotationTransition(
                    turns: _loadingController,
                    child: Container(
                      width: size.shortestSide < 400 ? 34 : 38,
                      height: size.shortestSide < 400 ? 34 : 38,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.25),
                          width: 2,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.black87,
                        ),
                        backgroundColor: Colors.black12,
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
}
