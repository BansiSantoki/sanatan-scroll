// FlutterFlow Standard Page Structure: SplashPageWidget
// File: lib/pages/splash_page/splash_page_widget.dart
// Route: /
// Target FlutterFlow Project ID: sanatan-scroll-gxh7pn

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPageWidget extends StatefulWidget {
  const SplashPageWidget({super.key});

  @override
  State<SplashPageWidget> createState() => _SplashPageWidgetState();
}

class _SplashPageWidgetState extends State<SplashPageWidget>
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

    _fadeAnimation = AlwaysStoppedAnimation<double>(1.0);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
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

    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final nextRoute = FirebaseAuth.instance.currentUser == null
          ? '/auth'
          : '/home';
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

    final logoHeight = screenHeight < 650
        ? 95.0
        : screenHeight < 800
            ? 112.0
            : 130.0;

    final titleFontSize = screenWidth < 360
        ? 38.0
        : screenWidth < 420
            ? 46.0
            : 52.0;

    final subtitleFontSize = screenWidth < 360 ? 14.5 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF6),
      body: Stack(
        children: [
          // 1. TOP-LEFT & BOTTOM-RIGHT ORANGE ORGANIC WAVES
          Positioned.fill(
            child: CustomPaint(
              painter: const _SplashWavesPainter(
                waveColor: Color(0xFFFA8320),
              ),
            ),
          ),

          // 2. CENTER BRAND CONTENT
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
                      const Spacer(flex: 3),

                      // LOGO (Dark Teal Trishul S Mark)
                      Image.asset(
                        'assets/images/sanatan_logo.png',
                        height: logoHeight,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        color: const Color(0xFF0F3B2E),
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.self_improvement_rounded,
                            size: logoHeight * 0.7,
                            color: const Color(0xFF0F3B2E),
                          );
                        },
                      ),

                      SizedBox(height: screenHeight < 650 ? 18 : 26),

                      // APP TITLE ("Sanatan Scroll" - Single Line)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Sanatan Scroll',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F3B2E),
                              height: 1.05,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight < 650 ? 10 : 14),

                      // TAGLINE ("From Scripture into Everyday Life")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'From Scripture into Everyday Life',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0F3B2E),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 4),
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

class _SplashWavesPainter extends CustomPainter {
  final Color waveColor;

  const _SplashWavesPainter({
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // 1. TOP-LEFT ORGANIC WAVE
    final topLeftPath = Path();
    topLeftPath.moveTo(0, 0);
    topLeftPath.lineTo(w * 0.46, 0);
    topLeftPath.cubicTo(
      w * 0.36,
      h * 0.08,
      w * 0.16,
      h * 0.14,
      0,
      h * 0.22,
    );
    topLeftPath.close();
    canvas.drawPath(topLeftPath, paint);

    // 2. BOTTOM-RIGHT ORGANIC WAVE
    final bottomRightPath = Path();
    bottomRightPath.moveTo(w, h);
    bottomRightPath.lineTo(w * 0.24, h);
    bottomRightPath.cubicTo(
      w * 0.48,
      h * 0.90,
      w * 0.74,
      h * 0.82,
      w,
      h * 0.73,
    );
    bottomRightPath.close();
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



