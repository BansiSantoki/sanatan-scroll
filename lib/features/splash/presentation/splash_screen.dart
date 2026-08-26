import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late final Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _startSplash();
  }

  void _startSplash() {
    _animationController.forward();

    // Navigation timer: preserves original 4-second timeout & auth route switching
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
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Responsive scaling factors
    final sunDiameter = screenWidth * 0.76;
    final logoHeight = screenHeight < 650
        ? 100.0
        : screenHeight < 800
            ? 118.0
            : 135.0;

    final titleFontSize = screenWidth < 360
        ? 40.0
        : screenWidth < 420
            ? 48.0
            : 54.0;

    final subtitleFontSize = screenWidth < 360 ? 14.0 : 15.5;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E4),
      body: Stack(
        children: [
          // ==========================================
          // 1. TOP-RIGHT SUN GRAPHIC
          // ==========================================
          Positioned(
            top: -sunDiameter * 0.16,
            right: -sunDiameter * 0.16,
            child: Container(
              width: sunDiameter,
              height: sunDiameter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFF9A01B),
                    Color(0xFFFBAA29),
                    Color(0xFFFDBC33),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ==========================================
          // 2. BOTTOM ROLLED SCROLL ARTWORK
          // ==========================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/splash_scroll_bg.png',
              width: screenWidth,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // ==========================================
          // 3. CENTER BRAND CONTENT (Logo, Title, Subtitle)
          // ==========================================
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // LOGO (Dark Olive Trishul S)
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1F3323),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/sanatan_logo.png',
                          height: logoHeight,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.self_improvement_rounded,
                              size: logoHeight * 0.7,
                              color: const Color(0xFF1F3323),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight < 650 ? 16 : 24),

                      // APP TITLE
                      Text(
                        'Sanatan Scroll',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F3323),
                          height: 1.04,
                          letterSpacing: -0.3,
                        ),
                      ),

                      SizedBox(height: screenHeight < 650 ? 12 : 18),

                      // TAGLINE / SUBTITLE ("Clarity, one scroll at a time.")
                      Text(
                        'Clarity, one scroll at a time.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2D372E),
                          letterSpacing: 0.1,
                        ),
                      ),

                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
