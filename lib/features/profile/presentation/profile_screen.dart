import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 18.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
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

            return Stack(
              children: [
                // Top-Right Sun & Botanical Leaf Decorative Graphic
                Positioned(
                  top: -20,
                  right: -20,
                  child: CustomPaint(
                    size: const Size(180, 180),
                    painter: _HeaderDecorationPainter(),
                  ),
                ),

                // Main Scrollable Content
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: 10,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header (My Profile & Subtitle)
                          _buildHeader(),

                          const SizedBox(height: 20),

                          // Profile Summary Card
                          _ProfileSummaryCard(
                            name: name,
                            email: email,
                            photoUrl: photoUrl,
                            onEdit: () => _showProfileEditor(context),
                          ),

                          const SizedBox(height: 16),

                          // 1. Milestones & Achievements Card
                          _MenuTileCard(
                            icon: Icons.emoji_events_outlined,
                            iconBgColor: const Color(0xFFE0E5CE),
                            iconColor: const Color(0xFF495736),
                            cardBgColor: const Color(0xFFEFF2E4),
                            title: 'Milestones & Achievements',
                            subtitle: 'Track your growth and celebrate.',
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text('Milestones & Achievements'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            },
                          ),

                          const SizedBox(height: 14),

                          // 2. Settings Card
                          _MenuTileCard(
                            icon: Icons.settings_outlined,
                            iconBgColor: const Color(0xFFF7D4B6),
                            iconColor: const Color(0xFFD96E28),
                            cardBgColor: const Color(0xFFFDECDA),
                            title: 'Settings',
                            subtitle: 'Manage your preferences.',
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                          ),

                          const SizedBox(height: 14),

                          // 3. Help & Support Card
                          _MenuTileCard(
                            icon: Icons.help_outline_rounded,
                            iconBgColor: const Color(0xFFF9E7B6),
                            iconColor: const Color(0xFFC8932A),
                            cardBgColor: const Color(0xFFFDF4DA),
                            title: 'Help & Support',
                            subtitle: "We're here to help you.",
                            onTap: () => _showInfoDialog(
                              context,
                              'Help & Support',
                              'Need help with Sanatan Scroll? We are here to support your spiritual journey.',
                            ),
                          ),

                          const SizedBox(height: 18),

                          // 4. Synced Across Devices Card
                          const _SyncedDevicesCard(),

                          const SizedBox(height: 14),

                          // 5. Sign Out Option (ID: logout)
                          _MenuTileCard(
                            key: const Key('logout'),
                            icon: Icons.logout_rounded,
                            iconBgColor: const Color(0xFFFAD1C7),
                            iconColor: const Color(0xFFC83A2A),
                            cardBgColor: const Color(0xFFFDE8E4),
                            title: 'Sign Out',
                            titleColor: const Color(0xFFC83A2A),
                            subtitle: 'Log out of your account.',
                            onTap: () => _confirmSignOut(context),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER (My Profile & Subtitle)
  // ============================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Profile',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1B),
            height: 1.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your account, your journey.',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SIGN OUT CONFIRMATION DIALOG
  // ============================================================

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFAF7F2),
          title: Text(
            'Sign Out',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B1B1B),
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.45,
              color: const Color(0xFF555555),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
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
              child: const Text('Sign Out'),
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
    final auth = context.read<AuthProvider>();
    final nameController = TextEditingController(text: auth.userName);
    final photoController = TextEditingController(text: auth.userPhotoUrl ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFAF7F2),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.manrope(
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
                  decoration: const InputDecoration(
                    labelText: 'Display name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: photoController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Photo URL',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
                backgroundColor: const Color(0xFF1B1B1B),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    photoController.dispose();
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFAF7F2),
          title: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF7EF),
            Color(0xFFFDE8D4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
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
                        color: Colors.white,
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
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF555555),
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
                    color: const Color(0xFFE4E8D5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: Color(0xFF495736),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Google Verified',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF495736),
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
          size: 48,
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
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: titleColor ?? const Color(0xFF1B1B1B),
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          color: titleColor != null ? titleColor!.withValues(alpha: 0.7) : const Color(0xFF555555),
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
                  color: titleColor ?? const Color(0xFF1B1B1B),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFF2E4),
            Color(0xFFE5EAD4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cloud Illustration Container with Sparkles
          Container(
            width: 85,
            height: 85,
            decoration: const BoxDecoration(
              color: Color(0xFFF7FAF0),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.cloud_sync_outlined,
                  size: 40,
                  color: Color(0xFF495736),
                ),
                // Sparkle 1
                Positioned(
                  top: 14,
                  left: 14,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 10,
                    color: const Color(0xFF495736).withValues(alpha: 0.5),
                  ),
                ),
                // Sparkle 2
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 10,
                    color: const Color(0xFF495736).withValues(alpha: 0.5),
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
                  'Synced across devices',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your account is connected and your journey can be synced across devices.',
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    color: const Color(0xFF4A5538),
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4E5A35),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Account Connected',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
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

// ============================================================
// HEADER DECORATION PAINTER (Golden Circular Gradient & Leaves)
// ============================================================

class _HeaderDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Golden Sun Circles
    final sunCenter = Offset(w * 0.75, h * 0.35);

    final sunPaint1 = Paint()
      ..color = const Color(0xFFFBE4C8).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final sunPaint2 = Paint()
      ..color = const Color(0xFFF7C898).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(sunCenter, 70, sunPaint1);
    canvas.drawCircle(sunCenter, 45, sunPaint2);

    // Botanical Leaf Branch Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF495736).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final stem = Path();
    stem.moveTo(w * 0.95, h * 0.05);
    stem.cubicTo(w * 0.75, h * 0.25, w * 0.65, h * 0.55, w * 0.45, h * 0.75);
    canvas.drawPath(stem, stemPaint);

    // Leaves along stem
    _drawLeaf(canvas, Offset(w * 0.82, h * 0.20), -0.5, stemPaint);
    _drawLeaf(canvas, Offset(w * 0.72, h * 0.36), 0.4, stemPaint);
    _drawLeaf(canvas, Offset(w * 0.58, h * 0.52), -0.6, stemPaint);
    _drawLeaf(canvas, Offset(w * 0.48, h * 0.68), 0.5, stemPaint);
  }

  void _drawLeaf(Canvas canvas, Offset tip, double angle, Paint paint) {
    canvas.save();
    canvas.translate(tip.dx, tip.dy);
    canvas.rotate(angle);

    final leaf = Path();
    leaf.moveTo(0, 0);
    leaf.quadraticBezierTo(8, -10, 18, -12);
    leaf.quadraticBezierTo(10, 0, 0, 0);
    canvas.drawPath(leaf, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
