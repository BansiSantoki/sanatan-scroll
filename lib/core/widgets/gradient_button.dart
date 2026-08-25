import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.icon,
    this.gradient = AppGradients.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Widget? icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isEnabled ? gradient : null,
            color: isEnabled ? null : AppColors.lightSand,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primaryBurgundy.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled && !isLoading ? onPressed : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[icon!, const SizedBox(width: 8)],
                          Text(
                            label,
                            style: AppTextStyles.button.copyWith(
                              color: isEnabled
                                  ? AppColors.white
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
