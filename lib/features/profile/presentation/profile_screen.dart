import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/onboarding_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../streak/presentation/streak_screen.dart';

import '../../../../models/streak_model.dart';
import '../../../../data/mock_streak_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            final firebaseUser =
                firebase_auth.FirebaseAuth.instance.currentUser;

            final String name =
                auth.userName.trim().isNotEmpty
                    ? auth.userName.trim()
                    : 'Sanatan Sadhaka';

            final String email =
                firebaseUser?.email ?? '';

            final String? photoUrl =
                auth.userPhotoUrl?.trim().isNotEmpty == true
                    ? auth.userPhotoUrl
                    : firebaseUser?.photoURL;

            // ==================================================
            // STREAK DATA
            // ==================================================

            final StreakModel streak =
                MockStreakData.initial;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // PAGE TITLE
                  // ==========================================

                  Text(
                    'My Profile',
                    style:
                        AppTextStyles.pageHeading.copyWith(
                      fontSize: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // PROFILE CARD
                  // ==========================================

                  _ProfileCard(
                    name: name,
                    email: email,
                    photoUrl: photoUrl,
                    onEdit: () =>
                        _showProfileEditor(context),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // PROFILE MENU
                  // ==========================================

                  _ProfileMenuCard(
                    onMilestones: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const StreakScreen(),
                        ),
                      );
                    },
                    onSettings: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.settings,
                      );
                    },
                    onHelp: () {
                      _showInfoDialog(
                        context,
                        'Help & Support',
                        'Need help with Sanatan Scroll? Support options will be available here.',
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // WEEKLY STREAK
                  // ==========================================

                  _WeeklyStreakCard(
                    streak: streak,
                    onTap: () {
                      _showStreakCalendar(
                        context,
                        streak,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // SYNC CARD
                  // ==========================================

                  const _SyncCard(),

                  const SizedBox(height: 18),

                  // ==========================================
                  // SIGN OUT
                  // ==========================================

                  Center(
                    child: TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : () =>
                              _showSignOutDialog(
                                context,
                              ),
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign Out',
                              style: AppTextStyles
                                  .bodyMedium
                                  .copyWith(
                                color:
                                    AppColors.accentRed,
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // PROFILE EDITOR
  // ==========================================================

  Future<void> _showProfileEditor(
    BuildContext context,
  ) async {
    final auth = context.read<AuthProvider>();

    final nameController =
        TextEditingController(
      text: auth.userName,
    );

    final photoController =
        TextEditingController(
      text: auth.userPhotoUrl ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Display name',
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      photoController,
                  keyboardType:
                      TextInputType.url,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Photo URL',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child:
                  const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () async {
                if (nameController
                    .text
                    .trim()
                    .isEmpty) {
                  return;
                }

                final error =
                    await auth.updateProfile(
                  displayName:
                      nameController.text
                          .trim(),
                  photoUrl:
                      photoController.text
                          .trim(),
                );

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.of(
                  dialogContext,
                ).pop();

                if (error != null &&
                    context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content:
                          Text(error),
                    ),
                  );
                }
              },
              child:
                  const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    photoController.dispose();
  }

  // ==========================================================
  // INFO DIALOG
  // ==========================================================

  void _showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: Text(
            title,
            style:
                AppTextStyles.cardTitle.copyWith(
              fontSize: 19,
            ),
          ),
          content: Text(
            message,
            style:
                AppTextStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child:
                  const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SIGN OUT DIALOG
  // ==========================================================

  void _showSignOutDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: Text(
            'Sign Out',
            style:
                AppTextStyles.cardTitle.copyWith(
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of Sanatan Scroll?',
            style:
                AppTextStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child:
                  const Text('Cancel'),
            ),

            TextButton(
              onPressed: () async {
                Navigator.of(
                  dialogContext,
                ).pop();

                final authProvider =
                    context.read<
                        AuthProvider>();

                final onboardingProvider =
                    context.read<
                        OnboardingProvider>();

                await authProvider
                    .signOut();

                if (!context.mounted) {
                  return;
                }

                onboardingProvider.reset();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                  AppRoutes.auth,
                  (route) => false,
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color:
                      AppColors.accentRed,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // STREAK CALENDAR POPUP
  // ==========================================================

  void _showStreakCalendar(
    BuildContext context,
    StreakModel streak,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _StreakCalendarDialog(
          streak: streak,
        );
      },
    );
  }
}

// ==========================================================
// PROFILE CARD
// ==========================================================

class _ProfileCard
    extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        18,
      ),
      decoration: BoxDecoration(
        color:
            AppColors.cardBackground,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior:
                Clip.none,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  border: Border.all(
                    color:
                        AppColors.divider,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: photoUrl !=
                              null &&
                          photoUrl!
                              .isNotEmpty
                      ? Image.network(
                          photoUrl!,
                          width: 86,
                          height: 86,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return _defaultAvatar();
                          },
                        )
                      : _defaultAvatar(),
                ),
              ),

              Positioned(
                right: -2,
                bottom: -2,
                child: Material(
                  color:
                      AppColors.accentRed,
                  shape:
                      const CircleBorder(),
                  child: InkWell(
                    onTap: onEdit,
                    customBorder:
                        const CircleBorder(),
                    child:
                        const SizedBox(
                      width: 34,
                      height: 34,
                      child: Icon(
                        Icons
                            .edit_rounded,
                        size: 17,
                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            name,
            textAlign:
                TextAlign.center,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style:
                AppTextStyles.cardTitle
                    .copyWith(
              fontSize: 24,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          if (email.isNotEmpty)
            Text(
              email,
              textAlign:
                  TextAlign.center,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: AppTextStyles
                  .caption
                  .copyWith(
                fontSize: 14,
              ),
            ),

          const SizedBox(
            height: 10,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration:
                BoxDecoration(
              color: AppColors
                  .peachHighlight
                  .withValues(
                alpha: 0.45,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child:
                const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons
                      .verified_outlined,
                  size: 16,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Google Verified',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color:
          AppColors.peachHighlight,
      child: const Icon(
        Icons.person_rounded,
        size: 48,
      ),
    );
  }
}

// ==========================================================
// PROFILE MENU
// ==========================================================

class _ProfileMenuCard
    extends StatelessWidget {
  const _ProfileMenuCard({
    required this.onMilestones,
    required this.onSettings,
    required this.onHelp,
  });

  final VoidCallback onMilestones;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            AppColors.cardBackground,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          _CompactMenuTile(
            icon: Icons
                .emoji_events_outlined,
            title:
                'Milestones & Achievements',
            onTap:
                onMilestones,
          ),

          _menuDivider(),

          _CompactMenuTile(
            icon: Icons
                .settings_outlined,
            title: 'Settings',
            onTap: onSettings,
          ),

          _menuDivider(),

          _CompactMenuTile(
            icon: Icons
                .help_outline_rounded,
            title:
                'Help & Support',
            onTap: onHelp,
          ),
        ],
      ),
    );
  }

  Widget _menuDivider() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Divider(
        height: 1,
        color: AppColors.divider,
      ),
    );
  }
}

// ==========================================================
// COMPACT MENU TILE
// ==========================================================

class _CompactMenuTile
    extends StatelessWidget {
  const _CompactMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 23,
              color:
                  AppColors.primaryBurgundy,
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles
                    .bodyMedium
                    .copyWith(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons
                  .chevron_right_rounded,
              size: 24,
              color:
                  AppColors.primaryBurgundy,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// WEEKLY STREAK CARD
// ==========================================================

class _WeeklyStreakCard
    extends StatelessWidget {
  const _WeeklyStreakCard({
    required this.streak,
    required this.onTap,
  });

  final StreakModel streak;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Dart weekday:
    // Monday = 1
    // Sunday = 7
    //
    // We want:
    // Sunday, Monday, Tuesday...
    final sunday = DateTime(
      now.year,
      now.month,
      now.day -
          (now.weekday % 7),
    );

    const dayLabels = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.fromLTRB(
          16,
          14,
          16,
          16,
        ),
        decoration: BoxDecoration(
          color:
              AppColors.cardBackground,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha: 0.06,
              ),
              blurRadius: 8,
              offset:
                  const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    'WEEKLY STREAK',
                    style:
                        AppTextStyles
                            .label
                            .copyWith(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Diya
                _LegendDot(
                  color:
                      Colors.amber,
                  label: 'Diya',
                ),

                const SizedBox(
                  width: 12,
                ),

                // Bhog
                _LegendDot(
                  color:
                      AppColors.accentRed,
                  label: 'Bhog',
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            // ==========================================
            // WEEK DAYS
            // ==========================================

            Row(
              children:
                  List.generate(
                7,
                (index) {
                  final date =
                      sunday.add(
                    Duration(
                      days: index,
                    ),
                  );

                  final completed =
                      streak
                          .isCompleted(
                    date,
                  );

                  final isToday =
                      date.year ==
                              now.year &&
                          date.month ==
                              now.month &&
                          date.day ==
                              now.day;

                  return Expanded(
                    child:
                        _WeekDayItem(
                      label:
                          dayLabels[
                              index],
                      date: date,
                      completed:
                          completed,
                      isToday:
                          isToday,
                      isDiya: streak
                          .isDiyaOffering(
                        date,
                      ),
                      isBhog: streak
                          .isBhogOffering(
                        date,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// WEEK DAY ITEM
// ==========================================================

class _WeekDayItem
    extends StatelessWidget {
  const _WeekDayItem({
    required this.label,
    required this.date,
    required this.completed,
    required this.isToday,
    required this.isDiya,
    required this.isBhog,
  });

  final String label;
  final DateTime date;
  final bool completed;
  final bool isToday;
  final bool isDiya;
  final bool isBhog;

  @override
  Widget build(BuildContext context) {
    Color ringColor =
        AppColors.divider;

    if (isBhog) {
      ringColor =
          AppColors.accentRed;
    } else if (isDiya) {
      ringColor =
          Colors.amber;
    } else if (completed) {
      ringColor =
          AppColors.accentRed
              .withValues(
            alpha: 0.65,
          );
    }

    return Column(
      children: [
        Text(
          label,
          style:
              AppTextStyles.caption
                  .copyWith(
            fontSize: 8,
            fontWeight: isToday
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Container(
          width: 34,
          height: 34,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            color: completed
                ? ringColor
                    .withValues(
                    alpha: 0.10,
                  )
                : Colors.transparent,
            border: Border.all(
              color: ringColor,
              width: isToday
                  ? 2.4
                  : 1.8,
            ),
          ),
          child: Center(
            child:
                completed
                    ? Icon(
                        isBhog
                            ? Icons
                                .restaurant_rounded
                            : Icons
                                .local_fire_department_rounded,
                        size: 15,
                        color:
                            ringColor,
                      )
                    : null,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// LEGEND DOT
// ==========================================================

class _LegendDot
    extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          label,
          style:
              AppTextStyles.caption
                  .copyWith(
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// STREAK CALENDAR DIALOG
// ==========================================================

class _StreakCalendarDialog
    extends StatefulWidget {
  const _StreakCalendarDialog({
    required this.streak,
  });

  final StreakModel streak;

  @override
  State<_StreakCalendarDialog>
      createState() =>
          _StreakCalendarDialogState();
}

class _StreakCalendarDialogState
    extends State<
        _StreakCalendarDialog> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    displayedMonth = DateTime(
      now.year,
      now.month,
    );
  }

  void _previousMonth() {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    final now = DateTime.now();

    final currentMonth = DateTime(
      now.year,
      now.month,
    );

    final nextMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
    );

    // Don't allow future months.
    if (nextMonth.isAfter(
      currentMonth,
    )) {
      return;
    }

    setState(() {
      displayedMonth = nextMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth =
        DateTime(
          displayedMonth.year,
          displayedMonth.month + 1,
          0,
        ).day;

    // Convert Monday based weekday to
    // Sunday based index.
    final startingOffset =
        firstDay.weekday % 7;

    final totalCells =
        ((startingOffset +
                    daysInMonth) /
                7)
            .ceil() *
        7;

    final monthTitle =
        _monthName(
      displayedMonth.month,
    );

    final currentMonth =
        DateTime(
      now.year,
      now.month,
    );

    final isCurrentMonth =
        displayedMonth.year ==
                currentMonth.year &&
            displayedMonth.month ==
                currentMonth.month;

    return Dialog(
      backgroundColor:
          Colors.transparent,
      insetPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Container(
        constraints:
            const BoxConstraints(
          maxHeight: 700,
        ),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(28),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            22,
            24,
            22,
            20,
          ),
          child: Column(
            children: [
              // ==========================================
              // TOTAL DAYS
              // ==========================================

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .peachHighlight,
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons
                              .local_fire_department_rounded,
                          size: 34,
                          color:
                              Colors.orange,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${widget.streak.totalDays}',
                          style:
                              AppTextStyles
                                  .pageHeading
                                  .copyWith(
                            fontSize: 34,
                            color: AppColors
                                .primaryBurgundy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Total days of offerings',
                      style:
                          AppTextStyles
                              .body
                              .copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ==========================================
              // MONTH NAVIGATION
              // ==========================================

              Row(
                children: [
                  _CalendarNavButton(
                    icon: Icons
                        .chevron_left_rounded,
                    onTap:
                        _previousMonth,
                  ),

                  Expanded(
                    child: Text(
                      '$monthTitle ${displayedMonth.year}',
                      textAlign:
                          TextAlign.center,
                      style:
                          AppTextStyles
                              .sectionHeading
                              .copyWith(
                        fontSize: 22,
                        color: AppColors
                            .accentRed,
                      ),
                    ),
                  ),

                  _CalendarNavButton(
                    icon: Icons
                        .chevron_right_rounded,
                    onTap: isCurrentMonth
                        ? null
                        : _nextMonth,
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // ==========================================
              // WEEK HEADER
              // ==========================================

              Row(
                children: const [
                  _CalendarWeekLabel('S'),
                  _CalendarWeekLabel('M'),
                  _CalendarWeekLabel('T'),
                  _CalendarWeekLabel('W'),
                  _CalendarWeekLabel('T'),
                  _CalendarWeekLabel('F'),
                  _CalendarWeekLabel('S'),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              // ==========================================
              // CALENDAR
              // ==========================================

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    totalCells,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                ),
                itemBuilder:
                    (context, index) {
                  final dayNumber =
                      index -
                          startingOffset +
                          1;

                  if (dayNumber <
                          1 ||
                      dayNumber >
                          daysInMonth) {
                    return const SizedBox();
                  }

                  final date =
                      DateTime(
                    displayedMonth
                        .year,
                    displayedMonth
                        .month,
                    dayNumber,
                  );

                  final completed =
                      widget.streak
                          .isCompleted(
                    date,
                  );

                  final diya =
                      widget.streak
                          .isDiyaOffering(
                    date,
                  );

                  final bhog =
                      widget.streak
                          .isBhogOffering(
                    date,
                  );

                  final isToday =
                      date.year ==
                              now.year &&
                          date.month ==
                              now.month &&
                          date.day ==
                              now.day;

                  return _CalendarDay(
                    day: dayNumber,
                    completed:
                        completed,
                    isToday:
                        isToday,
                    isDiya:
                        diya,
                    isBhog:
                        bhog,
                  );
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // ==========================================
              // LEGEND
              // ==========================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _LargeLegend(
                    color:
                        Colors.amber,
                    label:
                        'Diya Offering',
                  ),

                  const SizedBox(
                    width: 30,
                  ),

                  _LargeLegend(
                    color:
                        AppColors.accentRed,
                    label:
                        'Bhog Offering',
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // ==========================================
              // CLOSE BUTTON
              // ==========================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.accentRed,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}

// ==========================================================
// CALENDAR NAV BUTTON
// ==========================================================

class _CalendarNavButton
    extends StatelessWidget {
  const _CalendarNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null
          ? AppColors
              .softBeige
              .withValues(alpha: 0.4)
          : AppColors.softBeige,
      shape:
          const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
            const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: onTap == null
                ? AppColors.secondaryText
                : AppColors.primaryBurgundy,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// CALENDAR WEEK LABEL
// ==========================================================

class _CalendarWeekLabel
    extends StatelessWidget {
  const _CalendarWeekLabel(
    this.label,
  );

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style:
              AppTextStyles.bodyMedium
                  .copyWith(
            fontWeight:
                FontWeight.w700,
            color:
                AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// CALENDAR DAY
// ==========================================================

class _CalendarDay
    extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.completed,
    required this.isToday,
    required this.isDiya,
    required this.isBhog,
  });

  final int day;
  final bool completed;
  final bool isToday;
  final bool isDiya;
  final bool isBhog;

  @override
  Widget build(BuildContext context) {
    Color ringColor =
        AppColors.divider;

    if (isBhog) {
      ringColor =
          AppColors.accentRed;
    } else if (isDiya) {
      ringColor =
          Colors.amber;
    } else if (completed) {
      ringColor =
          AppColors.accentRed
              .withValues(
            alpha: 0.65,
          );
    }

    return Center(
      child: Container(
        width: 42,
        height: 42,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color: completed
              ? ringColor
                  .withValues(
                  alpha: 0.08,
                )
              : Colors.transparent,
          border: Border.all(
            color: ringColor,
            width:
                isToday ? 2.5 : 2,
          ),
        ),
        child: Center(
          child: Text(
            '$day',
            style:
                AppTextStyles.bodyMedium
                    .copyWith(
              fontSize: 13,
              fontWeight: isToday
                  ? FontWeight.w800
                  : FontWeight.w500,
              color:
                  AppColors.primaryBurgundy,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// LARGE LEGEND
// ==========================================================

class _LargeLegend
    extends StatelessWidget {
  const _LargeLegend({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          label,
          style:
              AppTextStyles.body.copyWith(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// SYNC CARD
// ==========================================================

class _SyncCard
    extends StatelessWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors
            .peachHighlight
            .withValues(
          alpha: 0.35,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: AppColors
              .accentRed
              .withValues(
            alpha: 0.65,
          ),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Synced across devices',
            style:
                AppTextStyles.cardTitle
                    .copyWith(
              fontSize: 20,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            'Your account is connected and your journey can be synced across devices.',
            style:
                AppTextStyles.caption
                    .copyWith(
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets
                    .symmetric(
              vertical: 11,
              horizontal: 14,
            ),
            decoration:
                BoxDecoration(
              color: AppColors
                  .peachHighlight
                  .withValues(
                alpha: 0.45,
              ),
              borderRadius:
                  BorderRadius.circular(
                28,
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: [
                Icon(
                  Icons
                      .cloud_done_outlined,
                  size: 20,
                  color: AppColors
                      .primaryBurgundy,
                ),

                const SizedBox(
                  width: 8,
                ),

                Text(
                  'Account Connected',
                  style: AppTextStyles
                      .bodyMedium
                      .copyWith(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color: AppColors
                        .primaryBurgundy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}