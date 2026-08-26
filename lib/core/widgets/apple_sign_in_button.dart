import 'package:flutter/material.dart';

import 'social_auth_button.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFF9CCA5),
    this.foregroundColor = const Color(0xFF141814),
    this.borderColor = const Color(0xFFF9CCA5),
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SocialAuthButton(
      label: 'Continue with Apple',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      leading: Icon(Icons.apple, size: 24, color: foregroundColor),
    );
  }
}
