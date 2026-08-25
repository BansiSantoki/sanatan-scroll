import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Original Sanatan Scroll Logo
        Image.asset(
          'assets/images/sanatan_logo.png',
          width: 105,
          height: 105,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),

        const SizedBox(
          height: AppDimensions.spacing32,
        ),

        // Heading
        Text(
          'Begin Your Journey',
          style: AppTextStyles.pageHeading.copyWith(
            color: AppColors.darkBurgundy,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(
          height: AppDimensions.spacing16,
        ),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            'Sign up or log in to track your streak, bookmark favorite verses, and read sacred Hindu scriptures daily.',
            style: AppTextStyles.body.copyWith(
              color: const Color.fromARGB(255, 66, 56, 56),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
