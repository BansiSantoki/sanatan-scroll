import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/gradient_button.dart';

class BeginJourneyScreen extends StatelessWidget {
  const BeginJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final padding = Responsive.horizontalPadding(context);

    // Responsive values
    final logoSize = (screenWidth * 0.25).clamp(85.0, 125.0);
    final titleFontSize = (screenWidth * 0.075).clamp(26.0, 34.0);
    final descriptionFontSize = (screenWidth * 0.040).clamp(14.0, 17.0);
    final verticalGap = (screenHeight * 0.045).clamp(20.0, 40.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 165, 118, 37),
              Color.fromARGB(255, 233, 202, 155),
              Color.fromARGB(255, 212, 169, 109),
              Color.fromARGB(255, 192, 162, 117),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            height: (screenHeight * 0.10).clamp(55.0, 110.0),
                          ),

                          // ================= LOGO =================
                          Image.asset(
                            'assets/images/sanatan_logo.png',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: verticalGap),

                          // ================= TITLE =================
                          Text(
                            'Begin your journey',
                            style: AppTextStyles.pageHeading.copyWith(
                              color: AppColors.darkBurgundy,
                              fontSize: titleFontSize,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                            height: (screenHeight * 0.02).clamp(12.0, 20.0),
                          ),

                          // ================= DESCRIPTION =================
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  screenWidth > 600 ? 450 : screenWidth * 0.90,
                            ),
                            child: Text(
                              'A few moments of wisdom can transform the way you see your day.',
                              style: AppTextStyles.body.copyWith(
                                color: const Color.fromARGB(255, 75, 69, 69),
                                fontSize: descriptionFontSize,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(
                            height: (screenHeight * 0.12).clamp(50.0, 130.0),
                          ),

                          // ================= BUTTON =================
                          SizedBox(
                            width: double.infinity,
                            child: GradientButton(
                              label: 'Begin Exploring',
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.main,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: (screenHeight * 0.04).clamp(20.0, 45.0),
                          ),
                        ],
                      ),
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
