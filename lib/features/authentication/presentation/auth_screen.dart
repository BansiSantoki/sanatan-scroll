import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/apple_sign_in_button.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../providers/auth_provider.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_header.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 165, 118, 37),
              Color.fromARGB(255, 233, 202, 155),
              Color.fromARGB(255, 212, 169, 109),
              Color.fromARGB(255, 192, 162, 117),
            ],
            stops: [
              0.0,
              0.35,
              0.72,
              1.0,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE8C8)
                      .withValues(alpha: 0.28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD6A0)
                          .withValues(alpha: 0.20),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: -140,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF6D4B5)
                      .withValues(alpha: 0.22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE6B78E)
                          .withValues(alpha: 0.16),
                      blurRadius: 110,
                      spreadRadius: 35,
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Spacer(),

                            const AuthHeader(),

                            const SizedBox(
                              height:
                                  AppDimensions.spacing40,
                            ),

                            Consumer<AuthProvider>(
                              builder: (
                                context,
                                auth,
                                _,
                              ) {
                                return Column(
                                  children: [
                                    GoogleSignInButton(
                                      onPressed: auth.isLoading
                                          ? null
                                          : () =>
                                              _handleGoogleSignIn(
                                                context,
                                                auth,
                                              ),
                                      isLoading:
                                          auth.isGoogleLoading,
                                    ),

                                    const SizedBox(
                                      height:
                                          AppDimensions.spacing12,
                                    ),

                                    AppleSignInButton(
                                      onPressed:
                                          auth.isLoading
                                              ? null
                                              : () {
                                                  ScaffoldMessenger
                                                      .of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text(
                                                        'Apple Sign-In will be added soon',
                                                      ),
                                                    ),
                                                  );
                                                },
                                      isLoading:
                                          auth.isAppleLoading,
                                    ),
                                  ],
                                );
                              },
                            ),

                            const Spacer(),

                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(
                                  AppRoutes.onboarding,
                                );
                              },
                              child: Text(
                                'Maybe Later',
                                style: AppTextStyles
                                    .bodyMedium
                                    .copyWith(
                                  color:
                                      AppColors.warmOrange,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),

                            const AuthFooter(
                              showSyncText: false,
                            ),

                            const SizedBox(
                              height:
                                  AppDimensions.spacing16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(
    BuildContext context,
    AuthProvider auth,
  ) async {
    final error =
        await auth.signInWithGoogle();

    if (!context.mounted) {
      return;
    }

    if (auth.user != null) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.onboarding,
      );
      return;
    }

    if (error != null &&
        error != 'Google Sign-In cancelled') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}