import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../providers/navigation_provider.dart';
import '../../../../providers/streak_provider.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
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
                  // 1. HEADER (Your Journey)
                  // ============================================================
                  Text(
                    'Your Journey',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Small steps, deeper transformation.',
                    style: GoogleFonts.manrope(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ============================================================
                  // 2. MAIN TRACKER CARD
                  // ============================================================
                  const _MainTrackerCard(),

                  const SizedBox(height: 28),

                  // ============================================================
                  // 3. THIS WEEK SECTION
                  // ============================================================
                  const _ThisWeekSection(),

                  const SizedBox(height: 28),

                  // ============================================================
                  // 4. MILESTONES SECTION
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
                    'Tracker',
                    style: GoogleFonts.manrope(
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
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          streakCount == 1 ? 'Day' : 'Days',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B1B1B),
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
                          'Current Daily Streak',
                          style: GoogleFonts.manrope(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Keep your spiritual\njourney going.',
                          style: GoogleFonts.manrope(
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
                    context.read<NavigationProvider>().setIndex(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD95A2B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Track your daily progress',
                    style: GoogleFonts.manrope(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final thisWeekCount = provider.thisWeekCount;
        final weeklyMap = provider.weeklyCompletedMap;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Week',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<NavigationProvider>().setIndex(0);
                  },
                  child: Row(
                    children: [
                      Text(
                        'View all',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A6C38),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Color(0xFF5A6C38),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Card Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFEAE2D2),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$thisWeekCount / 7 Days',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep going, you\'re building\na beautiful habit.',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF555555),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFEAE2D2),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),

                  // 7 Days Circles Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                      final isDone = weeklyMap[day] ?? false;

                      return Column(
                        children: [
                          Text(
                            day,
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
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
                                      color: const Color(0xFFC4B8A5),
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
                  'Milestones',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                Text(
                  '${currentStreak.clamp(0, 30)} / 30 days',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD96E28),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 4 Milestone Cards
            _MilestoneCard(
              title: 'Beginning',
              targetDays: 7,
              icon: Icons.eco_outlined,
              iconBgColor: const Color(0xFFEAF0D8),
              iconColor: const Color(0xFF5A6C38),
              isUnlocked: provider.isMilestoneUnlocked(7),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: 'Steady',
              targetDays: 30,
              icon: Icons.local_florist_outlined,
              iconBgColor: const Color(0xFFFDF0D8),
              iconColor: const Color(0xFFD96E28),
              isUnlocked: provider.isMilestoneUnlocked(30),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: 'Practiced',
              targetDays: 60,
              icon: Icons.nature_outlined,
              iconBgColor: const Color(0xFFEAF0D8),
              iconColor: const Color(0xFF5A6C38),
              isUnlocked: provider.isMilestoneUnlocked(60),
            ),
            const SizedBox(height: 12),
            _MilestoneCard(
              title: 'Devoted',
              targetDays: 100,
              icon: Icons.filter_vintage_outlined,
              iconBgColor: const Color(0xFFFDECDA),
              iconColor: const Color(0xFFC85A32),
              isUnlocked: provider.isMilestoneUnlocked(100),
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
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.isUnlocked,
  });

  final String title;
  final int targetDays;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEAE2D2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Left Spiritual Icon Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
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
                  style: GoogleFonts.manrope(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$targetDays Days',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8E2D5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFF888888),
                    size: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
