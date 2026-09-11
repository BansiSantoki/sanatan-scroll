// FlutterFlow Page Implementation: StreakPage
// Route: /streak
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakPageWidget extends StatelessWidget {
  const StreakPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Journey',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B1B1B),
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Small steps, deeper transformation.',
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 22),

              // Main Tracker Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A1018), Color(0xFF7A2630), Color(0xFF9B2E35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A1018).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'TRACKER',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFF9A01B),
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '1 Day',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Current Daily Streak',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // This Week Calendar Row
              Text(
                'THIS WEEK',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  final isToday = day == 'Thu';
                  return Column(
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isToday
                            ? const Color(0xFF6B1F2A)
                            : const Color(0xFFEEE9E1),
                        child: Icon(
                          isToday ? Icons.check_rounded : Icons.circle,
                          size: 14,
                          color: isToday ? Colors.white : const Color(0xFFB5ACA0),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Milestones Section
              Text(
                'MILESTONES',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              _MilestoneTile(
                title: 'Beginning — 3 Days',
                subtitle: 'First step on your sacred journey',
                isUnlocked: true,
              ),
              const SizedBox(height: 10),
              _MilestoneTile(
                title: 'Steady — 7 Days',
                subtitle: 'Building a consistent reading habit',
                isUnlocked: false,
              ),
              const SizedBox(height: 10),
              _MilestoneTile(
                title: 'Practiced — 30 Days',
                subtitle: 'Deepening spiritual discipline',
                isUnlocked: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isUnlocked;

  const _MilestoneTile({
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E4DE)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isUnlocked
                ? const Color(0xFF6B1F2A).withValues(alpha: 0.1)
                : const Color(0xFFEEE9E1),
            child: Icon(
              isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
              color: isUnlocked ? const Color(0xFF6B1F2A) : const Color(0xFF827777),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2525),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF827777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
