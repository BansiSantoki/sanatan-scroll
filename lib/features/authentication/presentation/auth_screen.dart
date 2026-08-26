import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/apple_sign_in_button.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../providers/auth_provider.dart';
import 'widgets/auth_header.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E4),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Top Orange Wave Header
              const AuthHeader(),

              // Main Body Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width < 360 ? 20.0 : 28.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height < 650 ? 20 : 32),

                    // Title "Begin Your Journey"
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

                    SizedBox(height: size.height < 650 ? 10 : 14),

                    // Description text
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

                    SizedBox(height: size.height < 650 ? 28 : 36),

                    // Google & Apple buttons
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return Column(
                          children: [
                            GoogleSignInButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : () => _handleGoogleSignIn(context, auth),
                              isLoading: auth.isGoogleLoading,
                            ),

                            const SizedBox(height: 14),

                            AppleSignInButton(
                              onPressed: auth.isLoading
                                  ? null
                                  : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Apple Sign-In will be added soon',
                                          ),
                                        ),
                                      );
                                    },
                              isLoading: auth.isAppleLoading,
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: size.height < 650 ? 22 : 28),

                    // "Maybe Later" text link
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.onboarding,
                        );
                      },
                      child: Text(
                        'Maybe Later',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF141814),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF141814),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height < 650 ? 24 : 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(
    BuildContext context,
    AuthProvider auth,
  ) async {
    final error = await auth.signInWithGoogle();

    if (!context.mounted) {
      return;
    }

    if (auth.user != null) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.onboarding,
      );
      return;
    }

    if (error != null && error != 'Google Sign-In cancelled') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}