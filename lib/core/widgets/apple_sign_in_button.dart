import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'social_auth_button.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SocialAuthButton(
      label: 'Continue with Apple',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.white,
      borderColor: AppColors.black,
      leading: const Icon(Icons.apple, size: 24, color: AppColors.white),
    );
  }
}
