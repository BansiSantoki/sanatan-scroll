// FlutterFlow Page Implementation: AuthPage
// Route: /auth
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../flutterflow_custom_code/custom_actions/sync_firebase_user_profile.dart';

class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.84);

    final controlPoint1 = Offset(size.width * 0.38, size.height * 1.05);
    final endPoint1 = Offset(size.width * 0.72, size.height * 0.94);
    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      endPoint1.dx,
      endPoint1.dy,
    );

    final controlPoint2 = Offset(size.width * 0.88, size.height * 0.88);
    final endPoint2 = Offset(size.width, size.height * 0.98);
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AuthPageWidget extends StatefulWidget {
  const AuthPageWidget({super.key});

  @override
  State<AuthPageWidget> createState() => _AuthPageWidgetState();
}

class _AuthPageWidgetState extends State<AuthPageWidget> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        await syncFirebaseUserProfile();

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-In failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * 0.37;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E4),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Header Wave
              ClipPath(
                clipper: HeaderWaveClipper(),
                child: Container(
                  width: double.infinity,
                  height: headerHeight,
                  color: const Color(0xFFE88242),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1F3323),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/sanatan_logo.png',
                            height: size.height < 650 ? 70 : 88,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sanatan Scroll',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: size.width < 360 ? 30 : 36,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F3323),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Wisdom for your journey',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: size.width < 360 ? 14 : 15.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1F3323),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Body Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width < 360 ? 20.0 : 28.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Begin Your Journey',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: size.width < 360 ? 34 : 42,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF141814),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Explore timeless wisdom.\nBuild clarity. Live with purpose.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: size.width < 360 ? 14.5 : 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2D352E),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Color(0xFF1F3323))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/app_logo.png', height: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with Google',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1F3323),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Maybe Later Link
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/onboarding');
                      },
                      child: Text(
                        'Maybe Later',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF141814),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
