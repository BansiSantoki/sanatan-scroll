
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/onboarding_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../streak/presentation/streak_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
 
            final String name = auth.userName.trim().isNotEmpty
    ? auth.userName.trim()
    : 'Sanatan Sadhaka';

            final String email = firebaseUser?.email ?? '';

            final String? photoUrl = auth.userPhotoUrl?.trim().isNotEmpty == true
                ? auth.userPhotoUrl
                : firebaseUser?.photoURL;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // PAGE TITLE
                  // ==========================================
                  Text(
                    'My Profile',
                    style: AppTextStyles.pageHeading.copyWith(
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
                    onEdit: () => _showProfileEditor(context),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // PROFILE MENU
                  // ==========================================
                  _ProfileMenuCard(
                    onMilestones: () {
                      // Open Streak/Milestones screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const StreakScreen(),
                      ));
                    },
                    onSettings: () {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
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
                  // SYNC CARD
                  // ==========================================
                  _SyncCard(),

                  const SizedBox(height: 18),

                  // ==========================================
                  // SIGN OUT
                  // ==========================================
                  Center(
                    child: TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : () => _showSignOutDialog(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign Out',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accentRed,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
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

  Future<void> _showProfileEditor(BuildContext context) async {
    final auth = context.read<AuthProvider>();

    final nameController = TextEditingController(
      text: auth.userName,
    );

    final photoController = TextEditingController(
      text: auth.userPhotoUrl ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Display name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: photoController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Photo URL',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                final error = await auth.updateProfile(
                  displayName: nameController.text.trim(),
                  photoUrl: photoController.text.trim(),
                );

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop();

                if (error != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                    ),
                  );
                }
              },
              child: const Text('Save'),
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
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 19,
            ),
          ),
          content: Text(
            message,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SIGN OUT DIALOG
  // ==========================================================

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Sign Out',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of Sanatan Scroll?',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final authProvider = context.read<AuthProvider>();
                final onboardingProvider =
                    context.read<OnboardingProvider>();

                await authProvider.signOut();

                if (!context.mounted) return;

                onboardingProvider.reset();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.auth,
                  (route) => false,
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ==========================================================
// PROFILE CARD
// ==========================================================

class _ProfileCard extends StatelessWidget {
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
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        18,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ==========================================
          // PROFILE IMAGE
          // ==========================================
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.divider,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: photoUrl != null && photoUrl!.isNotEmpty
                      ? Image.network(
                          photoUrl!,
                          width: 86,
                          height: 86,
                          fit: BoxFit.cover,
                          errorBuilder: (
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

              // EDIT BUTTON
              Positioned(
                right: -2,
                bottom: -2,
                child: Material(
                  color: AppColors.accentRed,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onEdit,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 34,
                      height: 34,
                      child: Icon(
                        Icons.edit_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==========================================
          // NAME
          // ==========================================
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          // ==========================================
          // EMAIL
          // ==========================================
          if (email.isNotEmpty)
            Text(
              email,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontSize: 14,
              ),
            ),

          const SizedBox(height: 10),

          // ==========================================
          // GOOGLE VERIFIED
          // ==========================================
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.peachHighlight.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Google Verified',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
      color: AppColors.peachHighlight,
      child: const Icon(
        Icons.person_rounded,
        size: 48,
      ),
    );
  }
}

// ==========================================================
// PROFILE MENU CARD
// ==========================================================

class _ProfileMenuCard extends StatelessWidget {
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
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          _CompactMenuTile(
            icon: Icons.person_outline_rounded,
            title: 'Milestones & Achievements',
            onTap: onMilestones,
          ),

          _menuDivider(),

          _CompactMenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: onSettings,
          ),

          _menuDivider(),

          _CompactMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: onHelp,
          ),
        ],
      ),
    );
  }

  Widget _menuDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
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

class _CompactMenuTile extends StatelessWidget {
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
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 23,
              color: AppColors.primaryBurgundy,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: AppColors.primaryBurgundy,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// SYNC CARD
// ==========================================================

class _SyncCard extends StatelessWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.peachHighlight.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentRed.withValues(
            alpha: 0.65,
          ),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synced across devices',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Your account is connected and your journey can be synced across devices.',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.peachHighlight.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_done_outlined,
                  size: 20,
                  color: AppColors.primaryBurgundy,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Connected',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBurgundy,
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