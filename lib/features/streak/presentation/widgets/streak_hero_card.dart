import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../providers/streak_provider.dart';

class StreakHeroCard extends StatelessWidget {
  const StreakHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final streak = provider.streak;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          decoration: BoxDecoration(
            gradient: AppGradients.streakCard,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBurgundy.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sanatan Tracker',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Text('🔥', style: TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                '${streak.currentStreak} Days',
                style: AppTextStyles.pageHeading.copyWith(
                  color: AppColors.white,
                  fontSize: 42,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'CURRENT DAILY STREAK',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Keep your spiritual journey going',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Track your daily progress',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
