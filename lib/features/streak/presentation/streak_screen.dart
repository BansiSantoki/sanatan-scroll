import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/streak_provider.dart';
import 'reading_history_calendar_screen.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================================
                  // 1. STREAK HEADER
                  // ============================================================
                  Text(
                    'Your Journey',
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                      height: 1.05,
                      isSerif: true,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Consistent steps on a wiser you.',
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: isDark ? const Color(0xFFA0A6A0) : const Color(0xFF555555),
                    ),
                  ),

                  // ============================================================
                  // 2. MAIN TRACKER CARD
                  // ============================================================
                  const _MainTrackerCard(),

                  const SizedBox(height: 28),

                  // ============================================================
                  // 4. THIS WEEK SECTION (Preserved)
                  // ============================================================
                  const _ThisWeekSection(),

                  const SizedBox(height: 28),

                  // ============================================================
                  // 5. MILESTONES SECTION (Preserved)
                  // ============================================================
                  const _MilestonesSection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// MAIN TRACKER CARD WIDGET
// ============================================================

class _MainTrackerCard extends StatelessWidget {
  const _MainTrackerCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final streakCount = provider.streak.currentStreak;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDB875), Color(0xFFF99F53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF99F53).withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Label & Flame Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.tracker,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFE46D24),
                      size: 26,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Center Streak Circular Counter & Description Row
              Row(
                children: [
                  // Circular Days Badge
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF7BE78),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$streakCount',
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                            height: 1.0,
                            isSerif: true,
                          ),
                        ),
                        Text(
                          streakCount == 1 ? l10n.day : l10n.days,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B1B1B),
                            isSerif: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 18),

                  // Title & Subtitle Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.currentDailyStreak,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.keepSpiritualJourneyGoing,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF383838),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bottom Track your daily progress Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReadingHistoryCalendarScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD95A2B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.trackDailyProgress,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// THIS WEEK SECTION WIDGET
// ============================================================

class _ThisWeekSection extends StatelessWidget {
  const _ThisWeekSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final thisWeekCount = provider.thisWeekCount;
        final weeklyMap = provider.weeklyCompletedMap;

        final dayLabels = [
          {'key': 'Mon', 'localized': l10n.mon},
          {'key': 'Tue', 'localized': l10n.tue},
          {'key': 'Wed', 'localized': l10n.wed},
          {'key': 'Thu', 'localized': l10n.thu},
          {'key': 'Fri', 'localized': l10n.fri},
          {'key': 'Sat', 'localized': l10n.sat},
          {'key': 'Sun', 'localized': l10n.sun},
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              l10n.thisWeek,
              style: AppTextStyles.getFont(
                context,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                isSerif: true,
              ),
            ),

            const SizedBox(height: 12),

            // Card Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E241E) : const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFEAE2D2),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.daysProgress(thisWeekCount),
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.keepGoingHabit,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: isDark ? const Color(0xFFA0A6A0) : const Color(0xFF555555),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.white12 : const Color(0xFFEAE2D2),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),

                  // 7 Days Circles Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: dayLabels.map((dayItem) {
                      final dayKey = dayItem['key']!;
                      final dayName = dayItem['localized']!;
                      final isDone = weeklyMap[dayKey] ?? false;

                      return Column(
                        children: [
                          Text(
                            dayName,
                            style: AppTextStyles.getFont(
                              context,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFD0D4D0) : const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          isDone
                              ? Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5A6C38),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                              : Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? Colors.white24 : const Color(0xFFC4B8A5),
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// MILESTONES SECTION WIDGET
// ============================================================

class _MilestonesSection extends StatelessWidget {
  const _MilestonesSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final currentStreak = provider.streak.currentStreak;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.milestones,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                    isSerif: true,
                  ),
                ),
                Text(
                  '${currentStreak.clamp(0, 30)} / 30 ${l10n.days}',
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFE88B60) : const Color(0xFFD96E28),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 4 Milestone Cards matching Image 2 (7, 30, 90, 180)
            _MilestoneCard(
              title: l10n.milestoneBeginning,
              targetDays: 7,
              iconBgColor: isDark ? const Color(0xFF2E3D24) : const Color(0xFFE6EED8),
              iconColor: isDark ? const Color(0xFFA5C478) : const Color(0xFF4A5C2B),
              isUnlocked: provider.isMilestoneUnlocked(7),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: l10n.milestoneSteady,
              targetDays: 30,
              iconBgColor: isDark ? const Color(0xFF3D2A1C) : const Color(0xFFFDECDA),
              iconColor: isDark ? const Color(0xFFE88B60) : const Color(0xFFC85A32),
              isUnlocked: provider.isMilestoneUnlocked(30),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: 'Committed',
              targetDays: 90,
              iconBgColor: isDark ? const Color(0xFF2E3D24) : const Color(0xFFE6EED8),
              iconColor: isDark ? const Color(0xFFA5C478) : const Color(0xFF4A5C2B),
              isUnlocked: provider.isMilestoneUnlocked(90),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: l10n.milestoneDevoted,
              targetDays: 180,
              iconBgColor: isDark ? const Color(0xFF3D2A1C) : const Color(0xFFFDECDA),
              iconColor: isDark ? const Color(0xFFE88B60) : const Color(0xFFC85A32),
              isUnlocked: provider.isMilestoneUnlocked(180),
            ),
          ],
        );
      },
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.title,
    required this.targetDays,
    required this.iconBgColor,
    required this.iconColor,
    required this.isUnlocked,
  });

  final String title;
  final int targetDays;
  final Color iconBgColor;
  final Color iconColor;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E241E) : const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFEAE2D2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Left Number Circle Badge (Matching Image 2: 7, 30, 90, 180)
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$targetDays',
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  isSerif: true,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title & Days
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$targetDays ${l10n.days}',
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFFA0A6A0) : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          // Right Lock / Unlock Status Badge
          isUnlocked
              ? Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A6C38),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                )
              : Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A302A) : const Color(0xFFE8E2D5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: isDark ? const Color(0xFFA0A6A0) : const Color(0xFF888888),
                    size: 16,
                  ),
                ),
        ],
      ),
    );
  }
}

