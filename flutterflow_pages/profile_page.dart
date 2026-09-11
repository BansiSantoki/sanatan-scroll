// FlutterFlow Page Implementation: ProfilePage
// Route: /profile
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageWidget extends StatelessWidget {
  const ProfilePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Seeker';
    final email = user?.email ?? 'seeker@sanatanscroll.app';
    final photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Profile',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your account and spiritual journey settings',
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF827777)),
              ),
              const SizedBox(height: 24),

              // Profile Card Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF6B1F2A).withValues(alpha: 0.1),
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                      child: photoUrl == null
                          ? Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6B1F2A),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      displayName,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF827777)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Settings & Sign Out Actions
              _ProfileMenuTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Language and app preferences',
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                subtitle: 'Log out of your account',
                textColor: const Color(0xFF9B2E35),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/auth');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E4DE)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: Icon(icon, color: textColor ?? const Color(0xFF6B1F2A)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor ?? const Color(0xFF1B1B1B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF827777)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF827777)),
      ),
    );
  }
}
