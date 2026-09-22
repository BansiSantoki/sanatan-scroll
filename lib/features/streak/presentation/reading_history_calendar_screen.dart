import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../providers/streak_provider.dart';

class ReadingHistoryCalendarScreen extends StatefulWidget {
  const ReadingHistoryCalendarScreen({super.key});

  @override
  State<ReadingHistoryCalendarScreen> createState() =>
      _ReadingHistoryCalendarScreenState();
}

class _ReadingHistoryCalendarScreenState
    extends State<ReadingHistoryCalendarScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    });
  }

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
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Back Button Navigation Bar
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          size: 32,
                          color: Color(0xFF1B1B1B),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title: Reading History
                  Text(
                    'Reading History',
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                      height: 1.05,
                      isSerif: true,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle: Your journey, day by day.
                  Text(
                    'Your journey, day by day.',
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 1. Streak Summary Card (Current Streak | Active Days | Started)
                  const StreakSummaryCard(),

                  const SizedBox(height: 20),

                  // 2. Monthly Calendar Card (< Month Year >, Mon-Sun grid, checkmark circles)
                  MonthlyCalendarCard(
                    selectedMonth: _selectedMonth,
                    onPreviousMonth: _previousMonth,
                    onNextMonth: _nextMonth,
                  ),

                  const SizedBox(height: 32),
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
// STREAK SUMMARY CARD WIDGET (Current Streak | Active Days | Started)
// ============================================================

class StreakSummaryCard extends StatelessWidget {
  const StreakSummaryCard({super.key});

  String _formatStartedDate(List<DateTime> completedDates) {
    if (completedDates.isEmpty) {
      final now = DateTime.now();
      return '${now.day} ${_monthAbbr(now.month)}';
    }

    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => a.compareTo(b));
    final earliest = sorted.first;
    return '${earliest.day} ${_monthAbbr(earliest.month)}';
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final streak = provider.streak;
        final currentStreak = streak.currentStreak;
        final activeDays = streak.completedDates.isNotEmpty
            ? streak.completedDates.length
            : streak.totalDays;
        final startedText = _formatStartedDate(streak.completedDates);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFEAE2D2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Column 1: Current Streak
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Streak',
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$currentStreak ${currentStreak == 1 ? 'Day' : 'Days'}',
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B1B1B),
                        isSerif: true,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical Divider
              Container(
                width: 1,
                height: 38,
                color: const Color(0xFFEAE2D2),
              ),

              // Column 2: Active Days
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Days',
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$activeDays',
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B1B1B),
                          isSerif: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Vertical Divider
              Container(
                width: 1,
                height: 38,
                color: const Color(0xFFEAE2D2),
              ),

              // Column 3: Started
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Started',
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        startedText,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B1B1B),
                          isSerif: true,
                        ),
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
// MONTHLY CALENDAR CARD WIDGET
// ============================================================

class MonthlyCalendarCard extends StatelessWidget {
  const MonthlyCalendarCard({
    super.key,
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  String _formatMonthYear(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final firstDayOfMonth =
            DateTime(selectedMonth.year, selectedMonth.month, 1);
        final daysInMonth =
            DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
        final startWeekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun

        final leadingPaddingDays = startWeekday - 1;
        final prevMonthLastDay =
            DateTime(selectedMonth.year, selectedMonth.month, 0).day;

        final totalGridCells = ((leadingPaddingDays + daysInMonth + 6) ~/ 7) * 7;

        // Calculate active days in selected month
        int activeDaysCount = 0;
        for (int day = 1; day <= daysInMonth; day++) {
          final date = DateTime(selectedMonth.year, selectedMonth.month, day);
          if (provider.isDateCompleted(date)) {
            activeDaysCount++;
          }
        }

        final weekHeaderLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFEAE2D2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Header with Navigation Arrows (< Month Year >)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onPreviousMonth,
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 26,
                      color: Color(0xFF1B1B1B),
                    ),
                    splashRadius: 20,
                  ),
                  Text(
                    _formatMonthYear(selectedMonth),
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                      isSerif: true,
                    ),
                  ),
                  IconButton(
                    onPressed: onNextMonth,
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      size: 26,
                      color: Color(0xFF1B1B1B),
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Weekday Headers (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekHeaderLabels.map((label) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Calendar Days Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalGridCells,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  int dayNum;
                  bool isCurrentMonthCell = true;
                  DateTime cellDate;

                  if (index < leadingPaddingDays) {
                    isCurrentMonthCell = false;
                    dayNum = prevMonthLastDay - (leadingPaddingDays - index - 1);
                    cellDate = DateTime(
                        selectedMonth.year, selectedMonth.month - 1, dayNum);
                  } else if (index >= leadingPaddingDays + daysInMonth) {
                    isCurrentMonthCell = false;
                    dayNum = index - (leadingPaddingDays + daysInMonth) + 1;
                    cellDate = DateTime(
                        selectedMonth.year, selectedMonth.month + 1, dayNum);
                  } else {
                    dayNum = index - leadingPaddingDays + 1;
                    cellDate = DateTime(
                        selectedMonth.year, selectedMonth.month, dayNum);
                  }

                  final isCompleted = provider.isDateCompleted(cellDate);
                  final isTodayDate = cellDate.year == today.year &&
                      cellDate.month == today.month &&
                      cellDate.day == today.day;

                  return _CalendarDayCell(
                    dayNumber: dayNum,
                    isCurrentMonth: isCurrentMonthCell,
                    isCompleted: isCompleted,
                    isToday: isTodayDate,
                  );
                },
              ),

              const SizedBox(height: 18),

              // Active Days Count at bottom of calendar card
              Text(
                '$activeDaysCount active days this month',
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.isCompleted,
    required this.isToday,
  });

  final int dayNumber;
  final bool isCurrentMonth;
  final bool isCompleted;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    if (!isCurrentMonth) {
      return Center(
        child: Text(
          '$dayNumber',
          style: AppTextStyles.getFont(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFCCCCCC),
          ),
        ),
      );
    }

    if (isCompleted) {
      // Completed reading day: filled dark green circle with white checkmark
      return Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF5D7046), // Muted dark green
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }

    if (isToday) {
      // Today indicator: highlighted border circle with a dot underneath
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC85A32),
                  width: 1.5,
                ),
              ),
              child: Text(
                '$dayNumber',
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B1B1B),
                  isSerif: true,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFC85A32),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    }

    // Standard unread day in current month: light outline circle
    return Center(
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE5DEC9),
            width: 1.2,
          ),
        ),
        child: Text(
          '$dayNumber',
          style: AppTextStyles.getFont(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF444444),
            isSerif: true,
          ),
        ),
      ),
    );
  }
}
