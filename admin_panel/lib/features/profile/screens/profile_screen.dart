import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AdminAuthProvider>();
    final user = authProvider.user;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AdminColors.primaryDark,
                    child: Text(
                      user?.email?.isNotEmpty == true
                          ? user!.email![0].toUpperCase()
                          : 'A',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.email ?? 'Administrator',
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Chip(
                    label: Text('Super Admin Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: AdminColors.saffron,
                  ),
                  const Divider(height: 36),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Admin Firebase UID', style: GoogleFonts.inter(color: AdminColors.textSecondary)),
                      Text(user?.uid ?? '-', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Authentication Email', style: GoogleFonts.inter(color: AdminColors.textSecondary)),
                      Text(user?.email ?? '-', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email Verified', style: GoogleFonts.inter(color: AdminColors.textSecondary)),
                      Text(user?.emailVerified == true ? 'Yes' : 'No', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (user?.email != null) {
                              authProvider.sendPasswordReset(user!.email!).then((err) {
                                if (err == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Password reset email sent to ${user.email}.')),
                                  );
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.lock_reset, size: 18),
                          label: const Text('Reset Password'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminColors.error,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            authProvider.signOut();
                          },
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Sign Out'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
