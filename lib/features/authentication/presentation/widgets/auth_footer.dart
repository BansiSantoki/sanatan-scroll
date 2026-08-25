import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    this.showSyncText = true,
  });

  final bool showSyncText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSyncText) ...[
          Text(
            'Your journey, synced across your devices.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppDimensions.spacing24,
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.mutedBrown,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
