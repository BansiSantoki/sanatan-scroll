import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/mock_streak_data.dart';
import '../../../../providers/streak_provider.dart';
import 'widgets/statistic_card.dart';
import 'widgets/streak_calendar.dart';
import 'widgets/streak_hero_card.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.spacing16),
              Text('Sadhana Tracker', style: AppTextStyles.pageHeading),
              const SizedBox(height: AppDimensions.spacing20),
              const StreakHeroCard(),
              const SizedBox(height: AppDimensions.spacing24),
              const StreakCalendar(),
              const SizedBox(height: AppDimensions.spacing24),
              _MilestoneSection(),
              const SizedBox(height: AppDimensions.spacing24),
              Consumer<StreakProvider>(
                builder: (context, provider, _) {
                  final streak = provider.streak;
                  return Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          label: 'Current Streak',
                          value: '${streak.currentStreak} Days',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticCard(
                          label: 'Wisdom Collected',
                          value: '${streak.wisdomCollected} Verses',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestoneSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final streak = provider.streak;
        final progress = streak.currentStreak / streak.milestoneTarget;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Milestone', style: AppTextStyles.cardTitle),
                Text(
                  '${streak.currentStreak}/${streak.milestoneTarget} days',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warmOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.softBeige,
                color: AppColors.primaryBurgundy,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(streak.milestoneLabel, style: AppTextStyles.caption),
            const SizedBox(height: AppDimensions.spacing16),
            ...MockStreakData.milestones.map((m) {
              final isActive = streak.currentStreak >= m.$3;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.primaryBurgundy
                            : AppColors.softBeige,
                      ),
                      child: Icon(
                        isActive ? Icons.check_rounded : Icons.lock_outline,
                        size: 18,
                        color: isActive
                            ? AppColors.white
                            : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.$1,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isActive
                                  ? AppColors.primaryBurgundy
                                  : AppColors.darkText,
                            ),
                          ),
                          Text(m.$2, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
