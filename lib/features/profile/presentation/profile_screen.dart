import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_typography.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/locale_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 18.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

            final String name = auth.userName.trim().isNotEmpty
                ? auth.userName.trim()
                : 'Bansi Santoki';

            final String email = firebaseUser?.email ?? 'bansisantoki2005@gmail.com';

            final String? photoUrl = auth.userPhotoUrl?.trim().isNotEmpty == true
                ? auth.userPhotoUrl
                : firebaseUser?.photoURL;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxContentWidth,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (My Profile & Subtitle)
                      _buildHeader(context),

                      const SizedBox(height: 20),

                      // Profile Summary Card
                      _ProfileSummaryCard(
                        name: name,
                        email: email,
                        photoUrl: photoUrl,
                        onEdit: () => _showProfileEditor(context),
                      ),

                      const SizedBox(height: 16),

                      // 1. Settings Card
                      _MenuTileCard(
                        icon: Icons.settings_outlined,
                        iconBgColor: isDark ? const Color(0xFF3D2C1E) : const Color(0xFFF7D4B6),
                        iconColor: isDark ? const Color(0xFFE88B60) : const Color(0xFFD96E28),
                        cardBgColor: isDark ? const Color(0xFF2A2017) : const Color(0xFFFDECDA),
                        title: l10n.settings,
                        subtitle: l10n.settingsSubtitle,
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                      ),

                      const SizedBox(height: 14),

                      // 3. Help & Support Card
                      _MenuTileCard(
                        icon: Icons.help_outline_rounded,
                        iconBgColor: isDark ? const Color(0xFF3B331F) : const Color(0xFFF9E7B6),
                        iconColor: isDark ? const Color(0xFFE8C260) : const Color(0xFFC8932A),
                        cardBgColor: isDark ? const Color(0xFF292416) : const Color(0xFFFDF4DA),
                        title: l10n.helpAndSupport,
                        subtitle: l10n.helpSubtitle,
                        onTap: () => _showInfoDialog(
                          context,
                          l10n.helpAndSupport,
                          'Need help with Sanatan Scroll? Email us at: sanatanscrollapp@gmail.com',
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 4. Synced Across Devices Card
                      const _SyncedDevicesCard(),

                      const SizedBox(height: 14),

                      // 5. Sign Out Option
                      _MenuTileCard(
                        key: const Key('logout'),
                        icon: Icons.logout_rounded,
                        iconBgColor: isDark ? const Color(0xFF3D1F1D) : const Color(0xFFFAD1C7),
                        iconColor: isDark ? const Color(0xFFE86054) : const Color(0xFFC83A2A),
                        cardBgColor: isDark ? const Color(0xFF281816) : const Color(0xFFFDE8E4),
                        title: l10n.signOut,
                        titleColor: isDark ? const Color(0xFFE86054) : const Color(0xFFC83A2A),
                        subtitle: l10n.signOutSubtitle,
                        onTap: () => _confirmSignOut(context),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER (My Profile & Subtitle)
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;
    final langCode = context.watch<LocaleProvider>().languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.myProfile,
          style: AppTypography.pageTitle(
            langCode,
            color: isDark ? const Color(0xFFE6E8E6) : const Color(0xFF18392C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.yourAccountYourJourney,
          style: AppTypography.compact(
            langCode,
            color: isDark ? Colors.white60 : const Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SIGN OUT CONFIRMATION DIALOG
  // ============================================================

  void _confirmSignOut(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF222722) : const Color(0xFFFAF7F2),
          title: Text(
            l10n.signOutConfirmTitle,
            style: AppTextStyles.getFont(
              context,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            l10n.signOutConfirmMessage,
            style: AppTextStyles.getFont(
              context,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: AppTextStyles.getFont(context, fontSize: 14),
              ),
            ),
            FilledButton(
              key: const Key('logout_confirm'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.auth,
                    (route) => false,
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC83A2A),
              ),
              child: Text(
                l10n.signOut,
                style: AppTextStyles.getFont(context, fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EDIT PROFILE DIALOG
  // ============================================================

  Future<void> _showProfileEditor(BuildContext context) async {
    final l10n = context.l10n;
    final auth = context.read<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameController = TextEditingController(text: auth.userName);
    final photoController = TextEditingController(text: auth.userPhotoUrl ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF222722) : const Color(0xFFFAF7F2),
          title: Text(
            l10n.editProfile,
            style: AppTextStyles.getFont(
              context,
              fontSize: 18,
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
                  style: AppTextStyles.getFont(context, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: l10n.displayName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: photoController,
                  keyboardType: TextInputType.url,
                  style: AppTextStyles.getFont(context, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: l10n.photoUrl,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: AppTextStyles.getFont(context, fontSize: 14),
              ),
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

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.of(dialogContext).pop();

                if (error != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFE88B60) : const Color(0xFF1B1B1B),
              ),
              child: Text(
                l10n.save,
                style: AppTextStyles.getFont(context, fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    photoController.dispose();
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF222722) : const Color(0xFFFAF7F2),
          title: Text(
            title,
            style: AppTextStyles.getFont(
              context,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            message,
            style: AppTextStyles.getFont(
              context,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.close,
                style: AppTextStyles.getFont(context, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// PROFILE SUMMARY CARD
// ============================================================

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF2A2219), Color(0xFF221B14)]
              : const [Color(0xFFFFF7EF), Color(0xFFFDE8D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Photo & Edit Button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF3A3026) : Colors.white,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: photoUrl != null && photoUrl!.isNotEmpty
                      ? Image.network(
                          photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultAvatar(),
                        )
                      : _defaultAvatar(),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE48643),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF221B14) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // User Name, Email & Verification Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 13,
                    color: isDark ? Colors.white60 : const Color(0xFF555555),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2E3824) : const Color(0xFFE4E8D5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: isDark ? const Color(0xFFA5B888) : const Color(0xFF495736),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.l10n.googleVerified,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFA5B888) : const Color(0xFF495736),
                        ),
                      ),
                    ],
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
      color: const Color(0xFF62A7DB),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ============================================================
// MENU TILE CARD
// ============================================================

class _MenuTileCard extends StatelessWidget {
  const _MenuTileCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.cardBgColor,
    required this.title,
    this.titleColor,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color cardBgColor;
  final String title;
  final Color? titleColor;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: titleColor ?? (isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B)),
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 12.5,
                          color: titleColor != null
                              ? titleColor!.withValues(alpha: 0.7)
                              : (isDark ? Colors.white60 : const Color(0xFF555555)),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: titleColor ?? (isDark ? Colors.white70 : const Color(0xFF1B1B1B)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SYNCED ACROSS DEVICES CARD
// ============================================================

class _SyncedDevicesCard extends StatelessWidget {
  const _SyncedDevicesCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF1F281B), Color(0xFF192016)]
              : const [Color(0xFFEFF2E4), Color(0xFFE5EAD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Devices Icon Container
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2B3624) : const Color(0xFFF7FAF0),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.devices_rounded,
                  size: 36,
                  color: isDark ? const Color(0xFFA5B888) : const Color(0xFF495736),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 10,
                    color: (isDark ? const Color(0xFFA5B888) : const Color(0xFF495736)).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Text Content & Connected Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.syncedAcrossDevices,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.l10n.syncedSubtitle,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 12,
                    color: isDark ? const Color(0xFFA5B888) : const Color(0xFF4A5538),
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF38462C) : const Color(0xFF4E5A35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.l10n.accountConnected,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
